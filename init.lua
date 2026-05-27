--[[
 ╔═══════════════════════════════════════════════════════════════════════╗
 ║           NASA HACKING GROUP – ENTERPRISE NEØVIM IDE (K.I.S.S.)      ║
 ║                                                                       ║
 ║  • One file – no setup, no config, no tears.                         ║
 ║  • First launch installs all plugins with a beautiful Apple‑like     ║
 ║    progress screen.                                                   ║
 ║  • Then shows a VS Code‑style welcome page: Open Folder, New File…   ║
 ║  • Press <Space> and a Siri‑smart cheat sheet appears.               ║
 ║  • More powerful than VS Code, simpler than Scratch.                 ║
 ║                                                                       ║
 ╚═══════════════════════════════════════════════════════════════════════╝
]]--

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.updatetime = 300
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.shortmess:append({ I = true })

function _G.OpenFolder()
  local path = vim.fn.input("📂 Open folder: ", vim.fn.getcwd() .. "/", "dir")
  if path ~= "" then
    vim.cmd("cd " .. vim.fn.fnameescape(path))
    vim.cmd("NvimTreeOpen")
  end
end

function _G.CloneRepo()
  local url = vim.fn.input("⬇️  Git clone URL: ")
  if url ~= "" then
    local dir = vim.fn.input("Clone into directory: ", vim.fn.getcwd() .. "/", "dir")
    if dir ~= "" then
      vim.fn.system({ "git", "clone", url, dir })
      vim.cmd("cd " .. vim.fn.fnameescape(dir))
      vim.cmd("NvimTreeOpen")
    end
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function()
      require("catppuccin").setup({ flavour = "mocha" })
      vim.cmd.colorscheme "catppuccin-mocha"
    end,
  },

  {
    "goolord/alpha-nvim", event = "VimEnter",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "                                                     ",
        "     ███╗   ██╗ █████╗ ███████╗ █████╗               ",
        "     ████╗  ██║██╔══██╗██╔════╝██╔══██╗              ",
        "     ██╔██╗ ██║███████║███████╗███████║              ",
        "     ██║╚██╗██║██╔══██║╚════██║██╔══██║              ",
        "     ██║ ╚████║██║  ██║███████║██║  ██║              ",
        "     ╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝              ",
        "                                                     ",
        "          H4CK THE PLANET! WITH NASA 🚀              ",
        "      Press [SPACE] to see the smart cheat sheet    ",
        "                                                     ",
      }
      dashboard.section.buttons.val = {
        dashboard.button("o", "📂  Open Folder",     ":lua OpenFolder()<CR>"),
        dashboard.button("n", "📄  New File",        ":ene | startinsert<CR>"),
        dashboard.button("r", "🕒  Recent Files",    ":Telescope oldfiles<CR>"),
        dashboard.button("g", "⬇️  Clone Repository", ":lua CloneRepo()<CR>"),
        dashboard.button("c", "⚙️  Open Config",     ":e ~/.config/nvim/init.lua<CR>"),
        dashboard.button("q", "❌  Quit",            ":qa<CR>"),
      }
      alpha.setup(dashboard.opts)
    end,
  },

  -- 🌳 Treesitter – fault‑tolerant
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      vim.schedule(function()
        local ok, ts = pcall(require, "nvim-treesitter.configs")
        if not ok then
          vim.notify(
            "🌳 Treesitter is not installed yet. Run :Lazy sync to install it.",
            vim.log.levels.WARN
          )
          return
        end
        ts.setup({
          ensure_installed = {
            "lua","python","javascript","typescript","c","cpp","rust",
            "bash","json","yaml","markdown","markdown_inline","vim","vimdoc","query",
            "go","java","html","css","dockerfile","sql","latex","make","toml",
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        })
      end)
    end,
  },

  { "williamboman/mason.nvim", build = ":MasonUpdate", cmd = "Mason", config = true },
  { "williamboman/mason-lspconfig.nvim", dependencies = { "mason.nvim" } },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim", "nvim-cmp" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, opts)
        vim.keymap.set("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<CR>", opts)
        vim.keymap.set("n", "<leader>lw", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)
      end

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "clangd", "bashls", "ts_ls",
          "html", "cssls", "jsonls", "yamlls", "gopls",
          "rust_analyzer", "jdtls", "marksman", "vimls",
          "tailwindcss", "prismals", "dockerls", "sqlls",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup({
              on_attach = on_attach,
              capabilities = capabilities,
            })
          end,
        },
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets",
    },
    event = "InsertEnter",
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" }, { name = "path" } }
        ),
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Search text" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Open buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",  desc = "Help" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>",   desc = "Recent files" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>",    desc = "All shortcuts" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = { i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" } },
        },
      })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<cr>",     desc = "Toggle file tree" },
      { "<leader>e", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal in tree" },
    },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "BufReadPost",
    config = function() require("lualine").setup({ options = { theme = "catppuccin" } }) end,
  },

  {
    "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "]h", "<cmd>Gitsigns next_hunk<CR>", { desc = "Next change" })
      vim.keymap.set("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Previous change" })
      vim.keymap.set("n", "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame line" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview change" })
      vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Undo change" })
      vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Stage change" })
    end,
  },

  {
    "folke/which-key.nvim", event = "VeryLazy",
    config = function()
      require("which-key").setup()
      require("which-key").add({
        { "<leader>?", group = "Show this cheat sheet" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP (Smart Code)" },
        { "<leader>d", group = "Debug" },
        { "<leader>x", group = "Diagnostics" },
        { "<leader>t", group = "Toggle" },
      })
      vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end,
        { desc = "Cheat Sheet" })
    end,
  },

  { "windwp/nvim-autopairs", event = "InsertEnter", config = function() require("nvim-autopairs").setup() end },
  { "numToStr/Comment.nvim", keys = { "gc", "gb" }, config = function() require("Comment").setup() end },

  {
    "lukas-reineke/indent-blankline.nvim", main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    config = function() require("ibl").setup() end,
  },

  {
    "folke/trouble.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",    desc = "All errors" },
      { "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", desc = "Workspace errors" },
      { "<leader>xd", "<cmd>Trouble document_diagnostics<cr>",  desc = "Current file errors" },
      { "<leader>xl", "<cmd>Trouble loclist<cr>",              desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble quickfix<cr>",              desc = "Quickfix" },
    },
    config = true,
  },

  {
    "akinsho/toggleterm.nvim", version = "*",
    keys = { { "<C-\\>", "<cmd>ToggleTerm<CR>", desc = "Floating terminal" } },
    config = function()
      require("toggleterm").setup({ direction = "float", float_opts = { border = "curved" } })
    end,
  },

  {
    "kylechui/nvim-surround", version = "*",
    keys = { "ys", "ds", "cs" },
    config = function() require("nvim-surround").setup() end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text", "williamboman/mason.nvim", "jay-babu/mason-nvim-dap.nvim" },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,          desc = "Continue" },
      { "<leader>do", function() require("dap").step_over() end,         desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end,         desc = "Step Into" },
      { "<leader>du", function() require("dap").step_out() end,          desc = "Step Out" },
      { "<leader>dr", function() require("dap").repl.open() end,         desc = "Debug Console" },
      { "<leader>dl", function() require("dap").run_last() end,          desc = "Run Last" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      require("nvim-dap-virtual-text").setup()
      require("mason-nvim-dap").setup({
        automatic_installation = true,
        ensure_installed = { "debugpy", "codelldb" },
      })
      dap.adapters.python = { type = "executable", command = "python3", args = { "-m", "debugpy.adapter" } }
      dap.configurations.python = { { type = "python", request = "launch", name = "Launch file", program = "${file}", pythonPath = function() return "python3" end } }
      dap.adapters.codelldb = { type = "server", port = "${port}", executable = { command = vim.fn.stdpath("data") .. "/mason/bin/codelldb", args = { "--port", "${port}" } } }
      dap.configurations.cpp = { { name = "Launch file", type = "codelldb", request = "launch", program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end, cwd = "${workspaceFolder}" } }
      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },
}

-- Keymaps
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Down window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Up window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right window" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase width" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Leave terminal" })
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>x", ":wq<CR>", { desc = "Save & Quit" })
vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<Esc>", ":noh<CR>", { desc = "Clear highlights" })

require("lazy").setup(plugins, {
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
  ui = {
    border = "rounded",
    title = "🚀 NASA IDE Setup",
    title_pos = "center",
    size = { width = 0.5, height = 0.3 },
  },
  performance = {
    rtp = { disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        pcall(function() require("which-key").show({ global = false }) end)
      end, 500)
    end
  end,
})
