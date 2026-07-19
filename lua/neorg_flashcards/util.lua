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

local function normalized_path(path)
  if M.isempty(path) then
    return ""
  end

  local normalized = vim.fs.normalize(path)
  return vim.fs.normalize(vim.fn.resolve(normalized))
end

local function without_trailing_slash(path)
  if path == "/" or path:match("^%a:/$") then
    return path
  end

  return path:gsub("/+$", "")
end

function M.loaded_buffer(path)
  local target = normalized_path(path)
  if target == "" then
    return nil
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local buffer_path = vim.api.nvim_buf_get_name(bufnr)
    if vim.api.nvim_buf_is_loaded(bufnr) and normalized_path(buffer_path) == target then
      return bufnr
    end
  end

  return nil
end

function M.path_is_within(path, root)
  path = without_trailing_slash(normalized_path(path))
  root = without_trailing_slash(normalized_path(root))

  if path == "" or root == "" then
    return false
  end

  if path == root then
    return true
  end

  local prefix = root:sub(-1) == "/" and root or (root .. "/")
  return path:sub(1, #prefix) == prefix
end

function M.path_label(path, root)
  path = without_trailing_slash(normalized_path(path))
  root = without_trailing_slash(normalized_path(root))

  if path == "" then
    return "[No Name]"
  end

  if M.path_is_within(path, root) and path ~= root then
    local prefix = root:sub(-1) == "/" and root or (root .. "/")
    return path:sub(#prefix + 1)
  end

  return vim.fn.fnamemodify(path, ":~")
end

function M.lines_fingerprint(lines)
  return vim.fn.sha256(table.concat(lines, "\n"))
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
