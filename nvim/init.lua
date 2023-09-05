local opt = vim.opt
local g = vim.g





-- Setup fidget for displaying LSP messages
require("fidget").setup {
    text = {
        spinner = "dots"
    }
}



require("Comment").setup();
require("which-key").setup();


-- global options --
opt.incsearch = true -- Find the next match as we type the search
opt.hlsearch = true -- Hilight searches by default
opt.viminfo = "'100,f1" -- Save up to 100 marks, enable capital marks
opt.ignorecase = true -- Ignore case when searching...
opt.smartcase = true -- ...unless we type a capital
opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.termguicolors = true
opt.cursorline = true
opt.relativenumber = true
opt.number = true
-- opt.signcolumn = "yes:4"

vim.o.completeopt = 'menuone,noselect'

vim.g.mapleader = ' '

-- Color Scheme Settings
vim.cmd("syntax enable")
opt.background = "dark"
require("catppuccin").setup({
    flavour = "mocha", -- latte, frappe, macchiato, mocha
transparent_background =false,
    show_end_of_buffer = true, -- show the '~' characters after the end of buffers
    term_colors =false,
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        telescope = true,
        notify = false,
        mini = false,
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"

-- Movement keybinds
vim.cmd("inoremap jj <Esc>")
local opts = { noremap = true }
local legend = require('legendary')
legend.keymaps({
    { '<C-h>', '<C-w>h', description = 'Panes: Move left', opts = opts },
    { '<C-j>', '<C-w>j', description = 'Panes: Move down', opts = opts },
    { '<C-k>', '<C-w>k', description = 'Panes: Move up', opts = opts },
    { '<C-l>', '<C-w>l', description = 'Panes: Move right', opts = opts },
})


-- Treesitter
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil
    }
}


-- LSP Config
--
-- Setup lspconfig.
local nvim_lsp = require('lspconfig')
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    require('illuminate').on_attach(client)

    -- Mappings.
    local opts = { noremap = true, silent = true, buffer = true }
    require('legendary').keymaps({
        { 'gD', vim.lsp.buf.declaration, description = 'LSP: Go to declaration', opts = opts },
        { 'gd', vim.lsp.buf.definition, description = 'LSP: Go to definition', opts = opts },
        { 'K', vim.lsp.buf.hover, description = 'LSP: Hover', opts = opts },
        { 'gi', vim.lsp.buf.implementation, description = 'LSP: Go to implementation', opts = opts },
        { '<C-s>', vim.lsp.buf.signature_help, description = 'LSP: Signature help', mode = { 'n', 'i' }, opts = opts },
        { '<space>wa', vim.lsp.buf.add_workspace_folder, description = 'LSP: Add workspace folder', opts = opts },
        { '<space>wr', vim.lsp.buf.remove_workspace_folder, description = 'LSP: Remove workspace folder', opts = opts },
        { '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            description = 'LSP: List workspaces', opts = opts },
        { '<space>D', vim.lsp.buf.type_definition, description = 'LSP: Show type definition', opts = opts },
        { '<space>rn', vim.lsp.buf.rename, description = 'LSP: Rename', opts = opts },
        { '<space>ca', vim.lsp.buf.code_action, description = 'LSP: Code Action', opts = opts },
        { 'gr', vim.lsp.buf.references, description = 'LSP: Show references', opts = opts },
        { '<space>y', function() vim.diagnostic.open_float(0, { scope = "line" }) end,
            description = 'Diagnostics: Show window', opts = opts },
        { '[d', function() vim.diagnostic.goto_prev({ float = { border = "single" } }) end,
            description = 'Diagnostics: Previous', opts = opts },
        { ']d', function() vim.diagnostic.goto_next({ float = { border = "single" } }) end,
            description = 'Diagnostics: Next', opts = opts },
        { '<space>q', vim.diagnostic.setloclist, description = 'Diagnostic: Show location list', opts = opts },
        { '<space>ff', vim.lsp.buf.formatting, description = 'LSP: Format file', opts = opts },
        { ']u', function() require('illuminate').next_reference({ wrap = true }) end,
            description = "Illuminate: Next reference", opts = opts },
        { '[u', function() require('illuminate').next_reference({ reverse = true, wrap = true }) end,
            description = "Illuminate: Previous reference", opts = opts }
    })

    -- if client.server_capabilities.document_formatting then
    --     vim.cmd([[
    --         augroup LspFormatting
    --             autocmd! * <buffer>
    --             autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
    --         augroup END
    --         ]])
    -- end
end

local notify = require('notify')
vim.lsp.handlers['window/showMessage'] = function(_, result, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    local lvl = ({ 'ERROR', 'WARN', 'INFO', 'DEBUG' })[result.type]
    notify({ result.message }, lvl, {
        title = 'LSP | ' .. client.name,
        timeout = 10000,
        keep = function()
            return lvl == 'ERROR' or lvl == 'WARN'
        end,
    })
end

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Enable Language Servers
local function default_lsp_setup(module)
    nvim_lsp[module].setup {
        on_attach = on_attach,
        capabilities = capabilities
    }
end

default_lsp_setup('gopls')
default_lsp_setup('ccls')

-- Bash
default_lsp_setup('bashls')
-- Dart
default_lsp_setup('dartls')
-- Elixir
-- nvim_lsp.elixirls.setup {
-- --    cmd = { 'elixir-ls' },
--     -- Settings block is required, as there is no default set for elixir
--     settings = {
--         elixirLs = {
--             dialyzerEnabled = true,
--             dialyzerFormat = "dialyxir_long"
--         }
--     },
--     on_attach = on_attach,
--     capabilities = capabilities
-- }
-- Erlang
--default_lsp_setup('erlangls')
-- Haskell
default_lsp_setup('hls')
-- Java
-- nvim_lsp.java_language_server.setup {
--     cmd = { 'java-language-server' },
--     on_attach = on_attach,
--     capabilities = capabilities
-- }
-- Kotlin
--default_lsp_setup('kotlin_language_server')
-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            completion = {
                callSnippet = 'Replace'
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            }
        }
    },
    on_attach = on_attach,
    capabilities = capabilities
}
-- Nix
nvim_lsp.rnix.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Let statix format
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end
}
-- Python
default_lsp_setup('pyright')
-- Typescript
nvim_lsp.tsserver.setup {
    init_options = require("nvim-lsp-ts-utils").init_options,
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        -- Let eslint format
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
            enable_import_on_completion = true
        })
        ts_utils.setup_client(client)

        -- Mappings.
        local opts = { noremap = true, silent = true, buffer = true }
        require('legendary').keymaps({
            { 'gto', ':TSLspOrganize<CR>', description = 'LSP: Organize imports', opts = opts },
            { 'gtr', ':TSLspRenameFile<CR>', description = 'LSP: Rename file', opts = opts },
            { 'gti', ':TSLspImportAll<CR>', description = 'LSP: Import missing imports', opts = opts }
        })
    end,
    capabilities = capabilities
}
-- Web
-- ESLint
nvim_lsp.eslint.setup {
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        -- Run all eslint fixes on save
        vim.cmd([[
            augroup EslintOnSave
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> EslintFixAll
            augroup END
            ]])
    end,
    capabilities = capabilities
}
-- CSS
default_lsp_setup('cssls')
-- HTML
default_lsp_setup('html')
-- JSON
default_lsp_setup('jsonls')

-- NULL
require("null-ls").setup({
    sources = {
        -- Elixir
        --require("null-ls").builtins.diagnostics.credo,

        -- Nix
        require("null-ls").builtins.formatting.nixpkgs_fmt,
        require("null-ls").builtins.diagnostics.statix,
        require("null-ls").builtins.code_actions.statix,

        -- Python
        require("null-ls").builtins.formatting.black
    },
})



-- Autocompletion setup
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require('cmp')
local luasnip = require("luasnip")
require('nvim-autopairs').setup();
local lspkind = require('lspkind')

--cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noselect'
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            end
        end, { "i", "s" })
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        format = lspkind.cmp_format(),
    },
    experimental = {
        ghost_text = true;
    }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
   sources = cmp.config.sources({
       { name = 'path' }
   }, {
       { name = 'cmdline' }
   })
})
