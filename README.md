# deirdre

A Claude Code agent that reviews your prose the way Deirdre McCloskey teaches writing: warm, witty, and gently merciless toward flab, fog, and pretension. It grounds every finding in a rule from [*Economical Writing*](https://press.uchicago.edu/ucp/books/book/chicago/E/bo29562607.html) (or the LLM-tic list), quotes the offending line, and supplies a concrete rewrite. A rule without a rewrite is a lecture — deirdre shows.

deirdre also hunts the tells of machine-written prose: the "It's not X, it's Y" antithesis, rule-of-three closings, "moreover/furthermore," intensifiers, and metacommentary.

## What you get

- **`skills/deirdre/SKILL.md`** — an installable Claude Code skill. Self-contained: persona, doctrine, method, and output format. Triggers on review/edit/critique requests. If you installed the agent, the skill dispatches it; if not, it runs the review itself.
- **`agents/deirdre-writing-reviewer.md`** — the agent. Reviews drafts, essays, blog posts, READMEs, emails, marketing copy. Findings ordered by severity (🔴 clarity-breaking → 🟠 weakens the prose → 🟡 polish), each with a quoted original and a rewrite, closing with a verdict: publish / tighten-then-publish / needs a rewrite.
- **`commands/deirdre.md`** — a `/deirdre` slash command that dispatches the agent.
- **`scripts/llm-lint.sh`** — a grep-based linter that catches the mechanical tics (banned intensifiers, stock transitions, buzzword filler, the obvious not-X-it's-Y patterns). Exit 1 on hard failures, so it drops into CI or a pre-commit hook. deirdre handles the judgment a regex can't: rhythm, argument, whether a cut adds joy or merely subtracts words.
- **`STYLE_GUIDE.md`** — the doctrine: McCloskey's 35 rules (chapter list) plus a 20-item catalog of LLM writing tics.

## Install

The skill alone is enough — it carries the full persona and method:

```bash
git clone https://github.com/miqcie/deirdre.git
mkdir -p ~/.claude/skills/deirdre
cp deirdre/skills/deirdre/SKILL.md deirdre/STYLE_GUIDE.md ~/.claude/skills/deirdre/
```

Everything else is optional. The agent runs the review in a subagent, keeping your main context clean; `/deirdre` gives you a slash command; the linter drops into a writing repo:

```bash
cp deirdre/agents/deirdre-writing-reviewer.md ~/.claude/agents/
cp deirdre/commands/deirdre.md ~/.claude/commands/
cp deirdre/scripts/llm-lint.sh your-repo/scripts/
```

## Use

In any Claude Code session:

```
/deirdre path/to/draft.md
```

Or just ask: "review this draft." Claude dispatches deirdre. Bare `/deirdre` reviews the prose file you edited most recently.

Run the linter directly:

```bash
scripts/llm-lint.sh path/to/post.md
```

## Example output

```
Scope: reviewing draft.md (1,400 words).

🔴 Clarity-breaking
> "It's not just a tool, it's a paradigm shift."
LLM tic: not-X-it's-Y + inflated adjective. The sentence asserts
significance instead of showing it.
Rewrite: "The tool replaces a four-step manual process with one command."

🟠 Weakens the prose
> "There are several reasons why this approach is highly effective."
McCloskey #25, active verbs. "There are" padding plus an intensifier.
Rewrite: "This approach works for three reasons."

Verdict: tighten-then-publish. The middle section argues well — the
case study carries real weight. Fix the intro and the closer.
```

## Credit

The doctrine comes from Deirdre McCloskey's *Economical Writing* (University of Chicago Press) — short, cheap, funny, and worth every page: https://press.uchicago.edu/ucp/books/book/chicago/E/bo29562607.html

This repo is an homage, not an affiliation. Buy the book.

## License

MIT — see [LICENSE](LICENSE). (The license covers this repo's files; McCloskey's book remains her publisher's copyright, and only chapter titles are reproduced here.)
