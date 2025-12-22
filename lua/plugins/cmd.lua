return {
  {
    vim.api.nvim_create_user_command("Hello", function()
      vim.notify("Hello Wolrd!!!", vim.log.levels.INFO)
    end, {
      desc = "print hello Wolrd",
      nargs = "?",
      complete = function()
        return { "qhb", "qhb1" }
      end,
    }),
    -- 功能二
  },
}
