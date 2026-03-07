vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- to remove the ~ sign
vim.opt.fillchars:append({ eob = " " })

-- conceallevel for obsidian.nvim
vim.opt.conceallevel = 1

-- tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = true
opt.linebreak = true
opt.breakindent = true

--search settings
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

--backspace
opt.backspace = "indent,eol,start"

--clipboard
opt.clipboard:append("unnamedplus")

--split windows
opt.splitright = true
opt.splitbelow = true

--autocomplete
vim.opt.completeopt = "menu,menuone,noselect"
