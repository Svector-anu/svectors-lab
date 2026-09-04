const patterns = {
  url: /^(?:https?|ftp):\/\/(?:[^\s:@]+(?::[^\s@]*)?@)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)(?:\.(?:[a-z0-9\u{00a1}-\u{ffff}]+-)*[a-z0-9\u{00a1}-\u{ffff}]+)*(?:\.(?:[a-z\u{00a1}-\u{ffff}]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/iu,
  hostname: /^(?=.{1,253}\.?$)[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[-0-9a-z]{0,61}[0-9a-z])?)*\.?$/i,
  email: /^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$/i,
  uriTemplate: /^(?:(?:[^\x00-\x20"'<>%\\^`{|}]|%[0-9a-f]{2})|\{[+#./;?&=,!@|]?(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?(?:,(?:[a-z0-9_]|%[0-9a-f]{2})+(?::[1-9][0-9]{0,3}|\*)?)*\})*$/i,
};

function timed(name, re, input) {
  const start = process.hrtime.bigint();
  const result = re.test(input);
  const ms = Number(process.hrtime.bigint() - start) / 1e6;
  console.log(`${name}: input_len=${input.length} result=${result} time_ms=${ms.toFixed(2)}`);
  return ms;
}

// adversarial payloads targeting nested-quantifier backtracking
const payloads = {
  url: 'https://' + 'a-'.repeat(35) + '!',            // fails at end, many optional '-' groups
  hostname: 'a'.repeat(80) + '!',                       // fails at end after repeated groups
  email: 'a'.repeat(40) + '.' .repeat(1) + 'a'.repeat(40) + '!',
  uriTemplate: '{' + 'a%00,'.repeat(40) + '!}',
};

for (const [name, re] of Object.entries(patterns)) {
  const ms = timed(name, re, payloads[name]);
  if (ms > 500) console.log(`!!! POSSIBLE REDOS: ${name} took ${ms}ms`);
}
