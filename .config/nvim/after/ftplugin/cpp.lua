vim.keymap.set("i", "{", "{};<Left><Left>", { buffer = true })

vim.keymap.set("n", "<leader>c", "<cmd>FloatermNew --autoclose=0 g++ % -o /tmp/%:r && /tmp/%:r<cr>",
  { desc = "Run cpp file" }, { buffer = true })

require("snippet").add("cpp", {
  {
    trigger = "main",
    body = "#include <iostream>\nusing namespace std;\n\nint main() {\n\t${1}\n\treturn 0;\n}\n$0",
  },
  {
    trigger = "cls",
    body = "class ${1:Name} {\npublic:\n\t${1:Name}() = default;\n\t~${1:Name}() = default;\nprivate:\n\t$0\n};\n",
  },
})
