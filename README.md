# luixbits-neorg-flashcards.nvim

Local flashcards for Neorg notes.

This plugin stores cards as plain `.norg` files, opens a small prompt for new
cards, and provides an in-editor review popup with tags, score filters, and
simple 1/2/3 ratings. It does not require Anki, a server, or network sync.

## Install

With lazy.nvim:

```lua
{
  "LuixBits/luixbits-neorg-flashcards.nvim",
  dependencies = {
    "nvim-neorg/neorg",
  },
  config = function()
    local presets = require("neorg_flashcards.presets")

    require("neorg_flashcards").setup({
      flashcards_dir = vim.fn.expand("~/notes/flashcards"),
      default_file = vim.fn.expand("~/notes/flashcards/cards.norg"),
      default_kind = "japanese",
      languages = presets.only("japanese"),
    })
  end,
}
```

Use a local checkout while developing:

```lua
{
  dir = "~/projects/nvim-plugins/luixbits-neorg-flashcards.nvim",
  name = "luixbits-neorg-flashcards.nvim",
  config = function()
    local presets = require("neorg_flashcards.presets")

    require("neorg_flashcards").setup({
      flashcards_dir = vim.fn.expand("~/notes/flashcards"),
      default_file = vim.fn.expand("~/notes/flashcards/cards.norg"),
      default_kind = "japanese",
      languages = presets.only("japanese"),
    })
  end,
}
```

## Commands

- `:NeorgFlashcardOpen` opens the configured default file.
- `:NeorgFlashcardAdd [kind]` prompts for a new card. Without `[kind]`, it uses `default_kind`.
- `:NeorgFlashcardHelp` opens a short in-editor guide.
- `:NeorgFlashcardReview` reviews all valid cards under `flashcards_dir`.
- `:NeorgFlashcardReviewFile` reviews valid cards in the current file.
- `:NeorgFlashcardReviewTag [tag]` reviews cards with a matching `tags:` value.
- `:NeorgFlashcardReviewScore [bad|mid|good|new]` reviews cards by score.
- `:NeorgFlashcardValidate` validates flashcards in the current file.

Compatibility aliases `:NeorgFlashcardAddJapanese` and
`:NeorgFlashcardInsertJapanese` are available when the Japanese preset is
configured.

## Review Keys

- `Space` / `Enter`: reveal the answer, then advance.
- `1`: save `score: 1` and advance.
- `2`: save `score: 2` and advance.
- `3`: save `score: 3` and advance.
- `n`: advance without changing score.
- `p`: previous card.
- `e`: open the source card for editing.
- `q`: close review.

If the source card file is already open and has unsaved edits, ratings update
that buffer but do not write it automatically. Save the file normally to persist
both your edits and the rating.

## Card Format

Cards are plain Neorg blocks:

```norg
@flashcard japanese
japanese: 勉強
reading: べんきょう
english: study
notes: noun / suru verb
tags: jlpt vocab
score: 2
reviewed: 2026-07-01
@end
```

Only fields marked `required = true` in the language schema are required.
`score:` and `reviewed:` are maintained by the review UI when you press `1`,
`2`, or `3`.

## Language Presets

Japanese:

```lua
local presets = require("neorg_flashcards.presets")

require("neorg_flashcards").setup({
  default_kind = "japanese",
  languages = presets.only("japanese"),
})
```

Chinese:

```lua
local presets = require("neorg_flashcards.presets")

require("neorg_flashcards").setup({
  default_kind = "chinese",
  languages = presets.only("chinese"),
})
```

Multiple languages:

```lua
local presets = require("neorg_flashcards.presets")

require("neorg_flashcards").setup({
  default_kind = "japanese",
  languages = presets.only("japanese", "chinese"),
})
```

Custom language:

```lua
require("neorg_flashcards").setup({
  default_kind = "spanish",
  languages = {
    spanish = {
      label = "Spanish",
      front = "spanish",
      fields = {
        { key = "spanish", label = "Spanish: ", title = "Spanish", required = true },
        { key = "english", label = "English: ", title = "English", required = true, reveal = true },
        { key = "notes", label = "Notes: ", title = "Notes", reveal = true },
        { key = "tags", label = "Tags: ", title = "Tags" },
      },
    },
  },
})
```

## Suggested Keymaps

```lua
vim.keymap.set("n", "<leader>nco", "<cmd>NeorgFlashcardOpen<CR>", { desc = "Open flashcards" })
vim.keymap.set("n", "<leader>nci", "<cmd>NeorgFlashcardAdd<CR>", { desc = "Add flashcard" })
vim.keymap.set("n", "<leader>nch", "<cmd>NeorgFlashcardHelp<CR>", { desc = "Flashcard help" })
vim.keymap.set("n", "<leader>ncr", "<cmd>NeorgFlashcardReview<CR>", { desc = "Review flashcards" })
vim.keymap.set("n", "<leader>ncf", "<cmd>NeorgFlashcardReviewFile<CR>", { desc = "Review file flashcards" })
vim.keymap.set("n", "<leader>nct", "<cmd>NeorgFlashcardReviewTag<CR>", { desc = "Review flashcards by tag" })
vim.keymap.set("n", "<leader>ncs", "<cmd>NeorgFlashcardReviewScore<CR>", { desc = "Review flashcards by score" })
vim.keymap.set("n", "<leader>ncv", "<cmd>NeorgFlashcardValidate<CR>", { desc = "Validate flashcards" })
```

## Development

Run the local checks:

```sh
bash scripts/test.sh
```

Check the plugin from an isolated Neovim config:

```sh
bash scripts/check-clean-install.sh
```

If `stylua` is installed, the test script also checks formatting.

## Platform Support

The first release targets Linux and macOS. Windows is not a `0.1.0` release
target; path handling should be treated as best effort there until a Windows
user can validate it.

## Demo

A short asciinema-compatible terminal demo is available at
[`docs/demo.cast`](docs/demo.cast).

Module layout:

```text
lua/neorg_flashcards/init.lua     public setup, commands, add/open actions
lua/neorg_flashcards/presets.lua  bundled language presets
lua/neorg_flashcards/schema.lua   schema lookup, validation, render fields
lua/neorg_flashcards/parser.lua   @flashcard parsing and collection
lua/neorg_flashcards/review.lua   review popup and rating actions
lua/neorg_flashcards/store.lua    score/reviewed writeback
lua/neorg_flashcards/help.lua     short guide popup
lua/neorg_flashcards/popup.lua    shared floating window helper
lua/neorg_flashcards/util.lua     shared helpers
```
