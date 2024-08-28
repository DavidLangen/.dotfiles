return {
  -- add custom doki-theme
  { "doki-theme/doki-theme-vim" },

  -- Configure LazyVim to load doki-theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gray",
      guibg = "#35393b",
      background_colour = "#35393b",
    },
  },
  require("notify").setup({
    background_colour = "#35393b",
  }),
}
