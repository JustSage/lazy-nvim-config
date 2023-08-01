return {
  -- File navigation & fuzzy finder
  {
    "ThePrimeagen/harpoon",
    config = function()
      require("harpoon").setup({})
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        manual_mode = true,
        show_hidden = true,
      })
    end,
  },
}
