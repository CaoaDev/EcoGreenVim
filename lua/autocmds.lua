-- Auto sync plugins on save of plugins.lua
vim.api.nvim_create_autocmd("BufWritePost", { pattern = "plugins.lua", command = "source <afile> | PackerSync" })
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end })
-- Disable diagnostics in node_modules (0 is current buffer only)
vim.api.nvim_create_autocmd("BufRead", { pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" })
vim.api.nvim_create_autocmd("BufNewFile", { pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" })
-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, { pattern = { "*.txt", "*.md", "*.tex" }, command = "setlocal spell" })
-- Attach specific keybindings in which-key for specific filetypes
vim.api.nvim_create_autocmd("BufEnter", { pattern = "*.md", callback = function() require('plugins.which-key').attach_markdown(0) end })
vim.api.nvim_create_autocmd("BufEnter", { pattern = { "*.ts", "*.tsx" }, callback = function() require('plugins.which-key').attach_typescript(0) end })
vim.api.nvim_create_autocmd("BufEnter", { pattern = { "package.json" }, callback = function() require('plugins.which-key').attach_npm(0) end })
vim.api.nvim_create_autocmd("BufEnter", { callback = function() if EcoVim.plugins.zen.enabled then require('plugins.which-key').attach_zen() end end })
-- Winbar (for nvim 0.8+)
if vim.fn.has('nvim-0.8') == 1 then
  vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost" }, {
    callback = function()
      local winbar_filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "TelescopePrompt"
      }

      if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
        vim.opt_local.winbar = nil
        return
      end

      local present, winbar = pcall(require, "winbar")
      if not present or type(winbar) == "boolean" then
        vim.opt_local.winbar = nil
        return
      end

      local value = winbar.gps()

      if value == nil then
        value = winbar.filename()
      end

      vim.opt_local.winbar = value
    end,
  })
end

