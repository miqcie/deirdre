# Session Recap: deirdre initial public release

**Date:** 2026-08-03
**Project:** miqcie/deirdre
**PRs Merged:** none (root commit direct to main — new repo)

## What Was Built

Turned the private `/deirdre` setup (agent in `~/.claude/agents/`, command in `~/.claude/commands/`, linter in the Humaine Studio repo) into a public, promotable repo: agent, slash command, `scripts/llm-lint.sh`, `STYLE_GUIDE.md`, README with install/usage/example, MIT license, GitHub topics.

## Key Decisions

| Decision | Rationale |
|---|---|
| Strip business content from the public style guide | The private WRITING_STYLE_GUIDE.md mixes writing doctrine with Caldris/Eagle Ridge SEO and publishing workflow; only the McCloskey rules and LLM-tic list belong in public |
| Reproduce McCloskey chapter titles only, with attribution | Titles aren't copyrightable; README links to the book and states homage-not-affiliation |
| Bundle the linter with the repo | The agent's "companion linter" reference now resolves for anyone who clones |
| Sync local agent from the repo (repo is source of truth) | Local copy referenced a dead path; local now points at `~/GitHub/deirdre/STYLE_GUIDE.md` |

## Corrections Applied

None — the dead style-guide path in the local agent predates this session and was fixed as part of the release.

## What's Next

- Promotion: Humaine Studio blog post (Gilfoyle post as template), link from the agents story (bead chrismcconnell-w866).
