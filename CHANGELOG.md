# Changelog

All notable changes to deirdre. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Versions: [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

- **Major**: a change that breaks a user's setup or habits (command name, install method, file paths, removed agent).
- **Minor**: new behavior (a tic rule, a lint feature, a change to how she reviews).
- **Patch**: fixes that change no expectation (wording, false positives, typos).

To release: add a section below, then run `scripts/release.sh bump X.Y.Z`, merge the PR, and run `scripts/release.sh publish` on `main`.

## [2.1.0] - 2026-09-28

### Changed

- `llm-lint.sh` checks only the author's prose. It skips front matter, fenced and inline code, blockquotes, and text in double quotes, so a quoted example of a tic no longer fails the lint. Line numbers still point at the original lines.

### Added

- `<!-- llm-lint: ignore -->` on a line skips that line, for deliberate use of a tic.
- `scripts/test-llm-lint.sh`, a self-check for the linter.
- `CHANGELOG.md` and `scripts/release.sh` for versioned releases.

## [2.0.0] - 2026-09-28

### Added

- Claude Code plugin: `/plugin marketplace add miqcie/deirdre`, then `/plugin install deirdre@deirdre`. It installs the skill and the `deirdre-writing-reviewer` subagent together.
- The skill gives the subagent the absolute path of `STYLE_GUIDE.md`.

### Changed

- **Breaking:** `STYLE_GUIDE.md` moved to `skills/deirdre/STYLE_GUIDE.md`, so the skill folder works on its own. The v1 copy-install commands do not work with this layout.
- **Breaking:** with the plugin, the command is `/deirdre:deirdre` (plugin skills are namespaced). Asking for a prose review in plain words also triggers her.

### Removed

- **Breaking:** `commands/deirdre.md`. The skill supplies the command.

## [1.0.0] - 2026-08-04

### Added

- `deirdre-writing-reviewer` agent: McCloskey's *Economical Writing* rules plus LLM-tic detection. Every finding has a quote, a rule, and a rewrite. Findings are sorted by severity and the review ends with a verdict.
- `skills/deirdre/SKILL.md`: an installable skill that dispatches the agent, or runs the review itself when no agent is installed.
- `/deirdre` slash command.
- `scripts/llm-lint.sh`: a grep linter for the mechanical tics. It exits 1 on hard rules, for CI.
- `STYLE_GUIDE.md`: McCloskey's 35 rules (chapter titles) and a 20-item LLM-tic catalog, including em-dash overuse and "here's the thing".

[2.1.0]: https://github.com/miqcie/deirdre/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/miqcie/deirdre/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/miqcie/deirdre/releases/tag/v1.0.0
