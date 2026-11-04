## Decision review

- Before `superpowers:finishing-a-development-branch` or opening a PR, use the `decision-review` skill.
- In `superpowers:subagent-driven-development`, run `decision-review` after the final review and **before** deleting the plan's workspace (`.superpowers/sdd/<plan>/`).
- Implementer subagents: in the report file, add a "Decisions" section listing every choice the brief did not dictate (defaults, error handling, edge cases, scope cuts), with the reason for each.
