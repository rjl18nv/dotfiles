local opts = {silent = true}

vim.keymap.set("n", "<S-t>", ":tabnew<CR>", opts)

vim.keymap.set("n", "1<Tab>", "1gt", opts)
vim.keymap.set("n", "2<Tab>", "2gt", opts)
vim.keymap.set("n", "3<Tab>", "3gt", opts)

-- Move to previous/next
vim.keymap.set('n', ',q', ':BufferLineCyclePrev<CR>', opts)
vim.keymap.set('n', ',w', ':BufferLineCycleNext<CR>', opts)

-- Close buffer
vim.keymap.set('n', ',bd', ':bdelete %<CR>', opts)
vim.keymap.set('n', ',bda', ':w <bar> %bd <bar> e# <bar> bd# <CR>', opts)

-- Pick Buffer
vim.keymap.set('n', '<space>bp', ':BufferLinePick<CR>', opts)
