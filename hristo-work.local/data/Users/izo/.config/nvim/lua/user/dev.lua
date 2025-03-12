return {
  {
    dir = "~/code/quickfix_actually.nvim/", -- Your path
    name = "quickfix_actually",
    config = function ()
      require("quickfix_actually").setup()
    end
  }
}
