local M = {}

function M.notify(message, level)
  if message and message ~= "" then
    vim.notify(message, level or vim.log.levels.INFO, { title = "Neorg flashcards" })
  end
end

function M.trim(value)
  local result = tostring(value or "")
  result = result:gsub("^%s+", "")
  result = result:gsub("%s+$", "")
  return result
end

function M.isempty(value)
  return M.trim(value) == ""
end

function M.fname(path)
  return vim.fn.fnameescape(path)
end

local random_seeded = false

local function ensure_random_seeded()
  if random_seeded then
    return
  end

  local seed = os.time()
  local uv = vim.uv or vim.loop
  if uv and uv.hrtime then
    seed = seed + (uv.hrtime() % 1000000)
  end

  math.randomseed(seed)
  math.random()
  math.random()
  random_seeded = true
end

function M.shuffled(items)
  ensure_random_seeded()

  local result = vim.deepcopy(items)
  for index = #result, 2, -1 do
    local swap = math.random(index)
    result[index], result[swap] = result[swap], result[index]
  end

  return result
end

return M
