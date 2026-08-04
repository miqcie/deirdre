# Session Recap: installable skill + deirdre reviews herself

**Date:** 2026-08-04 (continues 2026-08-03 initial release)
**Project:** miqcie/deirdre
**PRs Merged:** none here (direct commits to main); Humaine-studio PR #43 opened (draft post, unmerged)

## What Was Built

- `skills/deirdre/SKILL.md` — self-contained installable skill (persona, doctrine, method, output format). Dispatches the agent when installed, runs the review itself when not. README now leads with the skill as the primary install path.
- deirdre reviewed her own repo (verdict: tighten-then-publish). All findings applied, including the initially deferred tic-list dedup.
- Two new tics in `STYLE_GUIDE.md` (em-dash overuse; "here's the thing" false-intimacy opener) with matching `llm-lint.sh` warn rules, including an em-dash density check.
- Announcement post drafted for humaine.studio (`_drafts/deirdre.md`, PR #43) — publishes nothing until moved to `_posts/`.

## Key Decisions

| Decision | Rationale |
|---|---|
| Skill install copies STYLE_GUIDE.md too | Her blocking finding: "the skill alone is enough" was a broken promise while the skill referenced a file the installer never copied |
| Tic list stays at exactly 20 items | "20-item list" is referenced in three files; merged duplicates freed slots that new tics backfilled, so no renumbering ripple |
| Draft post lives in `_drafts/` on a feature branch | Jekyll never deploys `_drafts/`; publishing stays a deliberate human step |

## Corrections Applied

None from the user; deirdre's own review supplied the corrections (pronoun pileup, install-section cadence, elegant variation on the product name, orphaned style-guide reference).

## What's Next

- Publish the announcement post: date-prefix into `_posts/`, merge Humaine-studio PR #43, then Substack mirror + LinkedIn (bead chrismcconnell-w866).
