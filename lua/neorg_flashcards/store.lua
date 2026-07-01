local util = require("neorg_flashcards.util")

local M = {}

local function field_line(lines, start_line, end_line, field)
  for index = start_line + 1, math.min(end_line - 1, #lines) do
    local key = lines[index]:match("^%s*([%w_-]+)%s*:")
    if key and key:lower():gsub("-", "_") == field then
      return index
    end
  end
  return nil
end

local function source_buffer(path)
  local target = vim.fs.normalize(path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)) == target then
      return bufnr
    end
  end
  return nil
end

local function source_lines(card)
  if util.isempty(card.path) then
    return nil, nil, "Cannot save rating for an unsaved buffer"
  end

  local bufnr = source_buffer(card.path)
  if bufnr then
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), bufnr, nil
  end

  local ok, lines = pcall(vim.fn.readfile, card.path)
  if not ok then
    return nil, nil, string.format("%s: could not read file", card.path)
  end

  return lines, nil, nil
end

local function write_source_lines(path, bufnr, lines)
  if bufnr then
    local was_modified = vim.bo[bufnr].modified
    local modifiable = vim.bo[bufnr].modifiable
    vim.bo[bufnr].modifiable = true
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.bo[bufnr].modifiable = modifiable

    if was_modified then
      return true, "Rating updated in open modified buffer; write the file to persist it.", false
    end

    local ok, err = pcall(vim.api.nvim_buf_call, bufnr, function()
      vim.cmd("silent write")
    end)
    if not ok then
      return false, err, false
    end
    return true, nil, true
  end

  local ok, err = pcall(vim.fn.writefile, lines, path)
  if not ok then
    return false, err, false
  end
  return true, nil, true
end

local function end_line_for_card(lines, card)
  if lines[card.end_line] and lines[card.end_line]:match("^%s*@end%s*$") then
    return card.end_line
  end

  for index = card.start_line, #lines do
    if lines[index]:match("^%s*@end%s*$") then
      return index
    end
  end

  return nil
end

local function upsert_field(lines, start_line, end_line, field, value)
  local line = field_line(lines, start_line, end_line, field)
  local rendered = field .. ": " .. value

  if line then
    lines[line] = rendered
    return 0
  end

  table.insert(lines, end_line, rendered)
  return 1
end

local function adjust_cached_lines(cards, updated_card, original_end_line, delta)
  if delta == 0 then
    return
  end

  for _, card in ipairs(cards or {}) do
    if card.path == updated_card.path and card ~= updated_card and card.start_line > original_end_line then
      card.start_line = card.start_line + delta
      card.end_line = card.end_line + delta
    end
  end
end

function M.set_card_fields(card, updates, opts)
  local lines, bufnr, err = source_lines(card)
  if not lines then
    return false, err, false
  end

  local original_end_line = card.end_line
  local end_line = end_line_for_card(lines, card)
  if not end_line then
    return false, "Could not find @end for " .. card.path .. ":" .. card.start_line, false
  end

  local before = #lines
  for _, update in ipairs(updates) do
    local inserted = upsert_field(lines, card.start_line, end_line, update.field, update.value)
    end_line = end_line + inserted
  end

  local ok, message, persisted = write_source_lines(card.path, bufnr, lines)
  if not ok then
    return false, "Could not save rating: " .. tostring(message), false
  end

  local delta = #lines - before
  for _, update in ipairs(updates) do
    card.values[update.field] = update.value
  end
  card.end_line = card.end_line + delta
  adjust_cached_lines(opts and opts.cards, card, original_end_line, delta)

  return true, message, persisted
end

return M
