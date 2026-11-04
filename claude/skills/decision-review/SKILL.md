---
name: decision-review
description: Use when implementation is complete and before finishing-a-development-branch, opening a PR, or deleting a subagent-driven-development plan workspace - when your human partner will review the work by its decisions rather than reading every line of the diff
---

# Decision Review

## Overview

Your human partner cannot read every line you wrote. They can read every decision you made. This skill turns the decisions buried in the plan, the ledger, the reports and the diff into one file they can review in minutes.

**Core principle:** A decision your human partner never saw is a decision made in secret. The diff shows what changed; only you know what you chose.

**Announce at start:** "I'm using the decision-review skill to write up the decisions I made."

**Save to:** `docs/superpowers/decisions/YYYY-MM-DD-<feature-name>.md`, next to the plan it reviews. Commit it to the branch, so it reaches the PR. Write it in the language your human partner writes to you in.

## When to Run

Run it once, after the work is verified and before any of these:

- `superpowers:finishing-a-development-branch`
- opening a PR by any other route
- deleting a subagent-driven-development workspace (`.superpowers/sdd/<plan>/`)

If you are in subagent-driven-development, run it **before** you delete the plan's workspace: the ledger and the task reports live there, and they are your best source. If the workspace is already gone, use the "Rulings I made" list from the conversation and `git log`, and say in the file that the task reports were not available.

## Step 1: Gather Sources

Read, in this order:

1. **The spec and the plan.** What was asked and what was promised.
2. **The SDD ledger** (`<workspace>/progress.md`), if one exists. Every `Ruling:` line, every parked finding.
3. **Every task report** (`<workspace>/task-N-report.md`). Concerns, DONE_WITH_CONCERNS, self-review findings.
4. **The whole-branch diff** (`git diff <merge-base>..HEAD`). Read it for decisions that no report mentions.

## Step 2: Find the Decisions

A decision is any point where a reasonable engineer could have done it differently and the spec did not say which. Look for these in the diff even when no report names them:

| Look for | Example |
|----------|---------|
| Defaults and constants | Timeout set to 30s, page size 50, retries 3 |
| Behavior on the unhappy path | Error swallowed vs raised, partial write vs rollback |
| Ordering and boundaries | What sits inside the transaction, what runs before the lock |
| Scope cuts | Requirement left out, edge case explicitly not handled |
| Interpretations | Two requirements conflicted, or one was ambiguous |
| Deviations from the plan | Different file, signature, approach, or test than the plan said |
| New dependencies or interfaces | Added a library, changed a public signature, new config key |
| Changed existing behavior | Anything an existing caller or user will notice |

## Step 3: Write the File

The file has exactly these sections, in this order. Every section is REQUIRED; write "None" when a section is empty, never omit it.

```markdown
# Decision Review: <feature>

Plan: <path>  ·  Branch: <name>  ·  Commits: <base7>..<head7>

## Decisions I made
| # | Decision | Why | Alternative I rejected | Cost if wrong | Where |
|---|----------|-----|------------------------|---------------|-------|

## Where I deviated from the plan
- <plan said X> → <I did Y> because <reason>. <file:line>

## Assumptions I could not confirm
- <assumption> — <how your human partner could check it>

## What the checks do not prove
- <test or check> proves <property>; it does not prove <property>.

## Read these hunks yourself
- <file:line> — <why this one needs a human: risk, irreversibility, or a decision above>

## Quiz
1. <question about a decision above whose answer is not in this file's wording>
```

Rules for the content:

- **Decisions table:** one row per decision, highest cost-if-wrong first. Every `Ruling:` from the ledger appears here. "Where" is a `file:line`, not a file name.
- **What the checks do not prove:** at least one line per test file or check you rely on. "All tests pass" is not an entry.
- **Read these hunks yourself:** at most 5. Choose by risk, not by size. A hunk that touches a decision with a high cost-if-wrong always qualifies.
- **Quiz:** 3 questions. Each one should be answerable only by someone who read the decisions and the hunks, for example "If the payment call times out after the order row is written, what state is the order in?"

## Step 4: Hand It Over

Commit the file, then tell your human partner:

```
Decision review written: <path>
<N> decisions, <M> deviations from the plan, <K> hunks to read yourself.
```

Do not summarize the decisions in chat. The file is the review; a chat summary invites skimming it.

Then continue with `superpowers:finishing-a-development-branch` (or whatever finishing step you were about to run).

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "The plan specified everything, there were no decisions" | Every implementation fills gaps the plan left. Read the diff with the table in Step 2. |
| "The final reviewer approved it" | The reviewer checked the code against the spec. It did not ask your human partner whether they agree with your choices. |
| "That choice is too small to list" | Small defaults are the ones nobody looks for later. If a reasonable engineer could have chosen differently, list it. |
| "The rulings are already in my final message" | A chat message scrolls away. The file is committed with the code it explains. |
| "Tests cover it, so nothing to list under what checks don't prove" | Every check proves one property. Name what it leaves out. |
| "The workspace is cluttering things, delete it first" | The ledger and reports are your sources. Write the review, then delete. |
