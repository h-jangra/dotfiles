vim.keymap.set("i", "{", "{};<Left><Left>", { buffer = true })

vim.keymap.set("n", "<leader>c", "<cmd>FloatermNew --autoclose=0 g++ % -o /tmp/%:r && /tmp/%:r<cr>",
  { desc = "Run cpp file" }, { buffer = true })

