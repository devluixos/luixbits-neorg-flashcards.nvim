# LuixBits Neorg Flashcards Release Plan

Goal: turn the personal Neorg flashcard helper into a standalone Neovim plugin
that can be installed with lazy.nvim, configured for different languages, used
outside NixOS, and optionally consumed by the local NVF/Nix configuration.

## Phase 1 - Repository Bootstrap

- [x] Create `/home/luiz/projects/nvim-plugins/luixbits-neorg-flashcards.nvim`.
- [x] Initialize it as an independent git repository.
- [x] Copy the current flashcard plugin into the standalone repo.
- [x] Add MIT license.
- [x] Add `.gitignore`.
- [x] Add `README.md`.
- [x] Add `CHANGELOG.md`.
- [x] Add this `PLAN.md` checklist.

## Phase 2 - Standalone Plugin Cleanup

- [x] Keep a standard Neovim Lua module layout under `lua/neorg_flashcards/`.
- [x] Remove hardcoded Japanese paths from plugin defaults.
- [x] Move personal Japanese defaults into user setup configuration.
- [x] Make `flashcards_dir`, `default_file`, `default_kind`, and `languages` configurable.
- [x] Keep review, parser, schema, popup, help, store, and utility code split by responsibility.
- [x] Keep old Japanese commands as compatibility aliases while making generic commands primary.
- [x] Add semantic versioning tags once the first public release is ready.

## Phase 3 - Language Configuration

- [x] Add bundled Japanese preset.
- [x] Add bundled Chinese preset.
- [x] Make presets opt-in instead of automatic defaults.
- [x] Support fully custom language schemas.
- [x] Document fields, required values, reveal fields, aliases, and front field behavior.
- [x] Do not add more presets for `0.1.0`; add more only when there is clear user need.

## Phase 4 - Public API and Commands

- [x] `require("neorg_flashcards").setup(opts)` configures the plugin.
- [x] `:NeorgFlashcardOpen` opens the configured default file.
- [x] `:NeorgFlashcardAdd [kind]` creates a card.
- [x] `:NeorgFlashcardReview` reviews all configured cards.
- [x] `:NeorgFlashcardReviewFile` reviews current-file cards.
- [x] `:NeorgFlashcardReviewTag [tag]` filters by tag.
- [x] `:NeorgFlashcardReviewScore [score]` filters by score.
- [x] `:NeorgFlashcardValidate` validates the current file.
- [x] `:NeorgFlashcardHelp` opens the short guide popup.
- [x] Keep Japanese compatibility aliases through `0.x`; revisit removal before `1.0.0`.

## Phase 5 - User Documentation

- [x] Document lazy.nvim installation.
- [x] Document local development install with `dir =`.
- [x] Document Japanese setup.
- [x] Document Chinese setup.
- [x] Document custom language setup.
- [x] Document commands and review keys.
- [x] Add Vim help docs under `doc/`.
- [x] Add screenshots or a short demo recording before public announcement.

## Phase 6 - Testing and Quality

- [x] Add syntax checks for Lua files.
- [x] Add headless Neovim tests for parsing, validation, presets, and score writeback.
- [x] Add a `scripts/test.sh` runner.
- [x] Add GitHub Actions CI.
- [x] Add stylua formatting config after choosing formatting rules.
- [x] Add regression tests for the interactive prompt flow.
- [x] Add regression tests for open modified source buffers.

## Phase 7 - Release Readiness

- [x] Create a GitHub repo under the LuixBits namespace.
- [x] Push the standalone repository.
- [x] Add repository topics: `neovim`, `neorg`, `flashcards`, `lua`, `language-learning`.
- [x] Add a public `v0.1.0` tag.
- [x] Add a release note using `CHANGELOG.md`.
- [x] Confirm install instructions against a clean Neovim config.
- [x] Confirm behavior on Linux and macOS.
- [x] Decide whether Windows paths should be supported for the first release.

## Phase 8 - Local NVF/Nix Integration

- [x] Keep NixOS/NVF as a local integration layer, not the plugin source of truth.
- [x] Point NVF at the standalone plugin checkout.
- [x] Configure the local layer with Japanese paths and the Japanese preset.
- [x] Keep personal keymaps in the Nix layer.
- [x] Rebuild Home Manager and confirm the plugin loads from the standalone checkout.

## Acceptance Criteria

- [x] A lazy.nvim user can install the plugin from a normal plugin repo.
- [x] A user can configure Japanese, Chinese, or a custom language without editing plugin code.
- [x] Cards stay as local `.norg` files with no Anki requirement.
- [x] Reviews are shuffled and support tag and score filters.
- [x] Scores are saved back to card files.
- [x] The local NVF/Nix setup uses the standalone plugin as a dependency.
- [x] The first public release is tagged and documented.
