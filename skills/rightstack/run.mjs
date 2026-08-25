#!/usr/bin/env node

import { spawnSync } from "node:child_process";

const PIN = "rightstack@0.3.1";
const raw = (process.env.SKILL_VAR ?? "").trim();

function fail(message, code = 2) {
  console.error(message);
  process.exit(code);
}

if (!raw) {
  fail("RIGHTSTACK_EMPTY: provide a build goal or an operation prefix", 2);
}

let command = "recommend";
let args = [raw];

const match = raw.match(/^([a-z-]+)\s*:\s*(.*)$/s);
if (match) {
  const operation = match[1];
  const value = match[2].trim();
  if (!value) fail(`RIGHTSTACK_BAD_INPUT: ${operation} requires a value`);

  switch (operation) {
    case "recommend":
      command = "recommend";
      args = [value];
      break;
    case "workflow":
      command = "workflow";
      args = [value];
      break;
    case "explain":
      command = "explain";
      args = [value, "--json"];
      break;
    case "migrate":
      command = "migrate";
      args = [value, "--json"];
      break;
    case "compare": {
      const tools = value.split("|").map((part) => part.trim()).filter(Boolean);
      if (tools.length !== 2) {
        fail("RIGHTSTACK_BAD_INPUT: compare requires exactly two tools separated by |");
      }
      command = "compare";
      args = tools;
      break;
    }
    default:
      fail(`RIGHTSTACK_BAD_INPUT: unsupported operation ${operation}`);
  }
}

const result = spawnSync(
  "npx",
  ["--yes", "--package", PIN, "rightstack", command, ...args],
  {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"],
    env: { ...process.env, npm_config_ignore_scripts: "true" },
  },
);

if (result.stdout) process.stdout.write(result.stdout);
if (result.stderr) process.stderr.write(result.stderr);

if (result.error) {
  fail(`RIGHTSTACK_TOOL_ERROR: ${result.error.message}`, 1);
}

process.exit(result.status ?? 1);
