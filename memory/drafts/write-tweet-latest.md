tweet drafts: agent skills are dependencies, not prompts

— one-liner —
1a. agent skills are dependencies with prose as executable code
1b. if a skill can touch your shell, “just a markdown file” is doing a lot of work

— two-punch —
2a. we keep reviewing agent skills like prompts. they can read files, call tools and run code, so the right model is a dependency with privileges
2b. portable skills are great until trust becomes portable too. verify the author, pin the version and inspect what the skill can actually touch

— paragraph —
3a. 26.1% of 31,132 agent skills in one study had at least one vulnerability. skills with scripts were 2.12x more likely to be vulnerable. the install button needs to become a security boundary
3b. signing proves who shipped a skill. it does not prove the skill behaves like its description. agent registries need both provenance and a claim-to-behavior check before install

— long tweet —
4a. an agent skill is not “just markdown” once the model can turn its instructions into shell commands, network calls and file access. traditional scanning catches suspicious code. it can miss a clean-looking instruction that makes the agent create the payload at runtime. verification has to cover metadata, scripts and natural-language behavior together
4b. portable skills are the right direction. i want the same workflow to run across codex, claude code, grok, kimi and whatever comes next. but portability raises the trust requirement: pin the exact artifact, declare capabilities, scan code and instructions, then enforce those capabilities at runtime. otherwise we just made supply-chain risk portable too

— thread opener —
5a. agent skills are becoming package dependencies, except one executable layer is written in natural language. our security tooling still mostly understands only the other layer
5b. the next useful primitive for agent skills is not another marketplace. it is a receipt proving the installed skill matches what was reviewed and stayed inside its declared capabilities

best: #4b — connects portability to the concrete trust controls it now requires
