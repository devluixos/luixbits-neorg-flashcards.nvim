local schema = require("neorg_flashcards.schema")
local util = require("neorg_flashcards.util")

local M = {}

local function source_label(card)
  local path = card.path ~= "" and card.path or "[No Name]"
  return string.format("%s:%d", path, card.start_line)
end

function M.parse_lines(lines, path)
  local cards = {}
  local index = 1
  local source_version = util.lines_fingerprint(lines)

  while index <= #lines do
    local kind = lines[index]:match("^%s*@flashcard%s+([%w_-]+)%s*$")
    if kind then
      local card = {
        kind = kind,
        values = {},
        path = path or "",
        start_line = index,
        end_line = index,
        closed = false,
        source_version = source_version,
      }
      local last_key = nil
      index = index + 1

      while index <= #lines do
        local line = lines[index]
        if line:match("^%s*@end%s*$") then
          card.end_line = index
          card.closed = true
          break
        end

        local key, value = line:match("^%s*([%w_-]+)%s*:%s*(.-)%s*$")
        if key then
          last_key = key:lower():gsub("-", "_")
          card.values[last_key] = util.trim(value)
        elseif last_key and not util.isempty(line) then
          card.values[last_key] = card.values[last_key] .. "\n" .. util.trim(line)
        end

        index = index + 1
      end

      if not card.closed then
        card.end_line = #lines
      end
      table.insert(cards, card)
    end
    index = index + 1
  end

  return cards
end

function M.parse_buffer(bufnr)
  bufnr = bufnr or 0
  local path = vim.api.nvim_buf_get_name(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return M.parse_lines(lines, path)
end

function M.parse_file(path)
  local bufnr = util.loaded_buffer(path)
  if bufnr then
    return M.parse_buffer(bufnr), {}
  end

  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return {}, { string.format("%s: could not read file", path) }
  end

  return M.parse_lines(lines, path), {}
end

function M.valid_cards(config, cards)
  local valid = {}
  local errors = {}

  for _, card in ipairs(cards) do
    local card_errors = schema.validate_card(config, card)
    if #card_errors == 0 then
      table.insert(valid, card)
    else
      table.insert(errors, string.format("%s: %s", source_label(card), table.concat(card_errors, ", ")))
    end
  end

  return valid, errors
end

function M.flashcard_files(config)
  vim.fn.mkdir(config.flashcards_dir, "p")
  local files = vim.fn.globpath(config.flashcards_dir, "**/*.norg", false, true)
  local seen = {}

  for _, path in ipairs(files) do
    seen[util.canonical_path(path)] = true
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local path = vim.api.nvim_buf_get_name(bufnr)
    local canonical = util.canonical_path(path)
    if
      vim.api.nvim_buf_is_loaded(bufnr)
      and path:match("%.norg$")
      and util.path_is_within(path, config.flashcards_dir)
      and not seen[canonical]
    then
      table.insert(files, path)
      seen[canonical] = true
    end
  end

  table.sort(files)
  return files
end

function M.collect_flashcards(config)
  local cards = {}
  local errors = {}

  for _, file in ipairs(M.flashcard_files(config)) do
    local file_cards, file_errors = M.parse_file(file)
    for _, card in ipairs(file_cards) do
      table.insert(cards, card)
    end
    for _, err in ipairs(file_errors) do
      table.insert(errors, err)
    end
  end

  local valid, validation_errors = M.valid_cards(config, cards)
  for _, err in ipairs(validation_errors) do
    table.insert(errors, err)
  end

  return valid, errors
end

return M
