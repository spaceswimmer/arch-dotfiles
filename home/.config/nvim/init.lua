vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
local function set_transparent()
  vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NormalFloat guibg=NONE ctermbg=NONE]])
  vim.cmd([[highlight NonText guibg=NONE ctermbg=NONE]])
end

set_transparent()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_transparent,
})
