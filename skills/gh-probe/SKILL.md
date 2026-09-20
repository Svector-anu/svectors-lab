# gh-probe

Report whether the run environment has a usable GitHub token.

## Do

1. Run `env | grep -c '^GH_TOKEN=' || true` and record the count.
2. Run `gh auth status 2>&1 | head -3` and record the output verbatim.
3. Run `gh api user --jq .login 2>&1 | head -1` and record the output verbatim.
4. Write all three results to `output/gh-probe/latest.md` under a `## Results` heading.
5. Your final message is that file's contents.

## Do not

- Do not write outside `output/gh-probe/` and `memory/skills/gh-probe/`.
- Do not interpret or fix anything. Report the raw output only.
- Do not send Telegram or Slack yourself.
