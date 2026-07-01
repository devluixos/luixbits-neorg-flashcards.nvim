#!/usr/bin/env sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
TMP="${TMPDIR:-/tmp}/neorg-flashcards-clean-$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$TMP/config" "$TMP/state" "$TMP/cache" "$TMP/data"

cat > "$TMP/config/init.lua" <<EOF
vim.opt.runtimepath:prepend("$ROOT")

local presets = require("neorg_flashcards.presets")

require("neorg_flashcards").setup({
  flashcards_dir = "$TMP/notes/flashcards",
  default_file = "$TMP/notes/flashcards/cards.norg",
  default_kind = "japanese",
  languages = presets.only("japanese"),
})

vim.cmd("NeorgFlashcardOpen")

local current_file = vim.api.nvim_buf_get_name(0)
if current_file ~= "$TMP/notes/flashcards/cards.norg" then
  error("unexpected flashcard file: " .. current_file)
end

if vim.fn.filereadable("$TMP/notes/flashcards/cards.norg") ~= 1 then
  error("default flashcard file was not created")
end

print("clean install check passed")
EOF

XDG_CONFIG_HOME="$TMP/config" \
XDG_STATE_HOME="$TMP/state" \
XDG_CACHE_HOME="$TMP/cache" \
XDG_DATA_HOME="$TMP/data" \
nvim --headless -u "$TMP/config/init.lua" -i NONE -n --cmd "set shadafile=NONE" -c "qa!"
