local M = {}

M.japanese = {
  label = "Japanese",
  front = "japanese",
  aliases = {
    japanese = { "word" },
  },
  fields = {
    { key = "japanese", label = "Japanese: ", title = "Japanese", required = true },
    { key = "reading", label = "Reading: ", title = "Reading", reveal = true },
    { key = "english", label = "English: ", title = "English", required = true, reveal = true },
    { key = "notes", label = "Notes: ", title = "Notes", reveal = true },
    { key = "tags", label = "Tags: ", title = "Tags" },
  },
}

M.chinese = {
  label = "Chinese",
  front = "chinese",
  aliases = {
    chinese = { "hanzi", "word" },
    pinyin = { "reading" },
  },
  fields = {
    { key = "chinese", label = "Chinese: ", title = "Chinese", required = true },
    { key = "pinyin", label = "Pinyin: ", title = "Pinyin", reveal = true },
    { key = "english", label = "English: ", title = "English", required = true, reveal = true },
    { key = "notes", label = "Notes: ", title = "Notes", reveal = true },
    { key = "tags", label = "Tags: ", title = "Tags" },
  },
}

function M.only(...)
  local languages = {}
  for _, name in ipairs({ ... }) do
    if M[name] then
      languages[name] = vim.deepcopy(M[name])
    end
  end
  return languages
end

return M
