-- print("Config nvim")

local core_conf_files = {
    "globals.lua",
	"options.lua",
	"autocommands.lua",
	"mappings.lua"
}

for _,name in ipairs(core_conf_files) do
	local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
	local source_cmd = "source" .. path
	vim.cmd(source_cmd)
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        config = function()
            require('which-key').setup()
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
        end,
    },
    { 'numToStr/Comment.nvim', opts = {}},
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end
            },
            {'nvim-telescope/telescope-ui-select.nvim' },
            {'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup{
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')
            pcall(require('telescope').load_extension, 'find_files')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.spell_suggest, { desc = '[S]earch current [W]ord' })
            vim.keymap.set('n', '<leader>sg', builtin.grep_string, { desc = '[S]earch by [G]rep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat' })
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
            vim.keymap.set('n', '<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = '[/] Fuzzily search in current buffer' })
            vim.keymap.set('n', '<leader>s/', function ()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open files'
                }
            end)
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            --{'j-hui/fidget.nvim', opts = {
            --    lsp = {
            --        progress_ringbuf_size = 0,
            --        log_handler = false,
            --    },
            --},
    	    --},
            {'folke/neodev.nvim', opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('pearl-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, {buffer = event.buf, desc = 'LSP: ' .. desc})
                    end

		            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
		            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
		            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
		            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
		            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
		            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
		            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
		            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
		            map('K', vim.lsp.buf.hover, 'Hover Documentation')
		            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
		            map('<leader>lsh', vim.lsp.buf.signature_help, '[S]ignature [H]elp')


		            local client = vim.lsp.get_client_by_id(event.data.client_id)
		            if client and client.server_capabilities.documentHighlightProvider then
		                vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
		                })
		                vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
		                })
		            end
                end,
                })
		    local capabilities = vim.lsp.protocol.make_client_capabilities()
		    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

		    local servers = {
		        clangd = {},
		        pyright = {},
		        cmake = {},
		        bashls = {},
		        lua_ls = {
                    settings = {
                        Lua = {
                            completion = {callSnippet = 'Replace',},
                        },
                    },
		        },
		    }
            require('mason').setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {'stylua', 'prettier'})
            require('mason-tool-installer').setup { ensure_installed = ensure_installed }
            require('mason-lspconfig').setup {
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            }
        end,
    },
    { -- Autocomplete
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            {'L3MON4D3/LuaSnip', build = 'make install_jsregexp'},
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'rafamadriz/friendly-snippets'
        },
        config = function()
            local cmp = require 'cmp'
            local luasnip = require 'luasnip'
            local select_opts = {behavior = cmp.SelectBehavior.Select}
            -- require('luasnip.loaders.from_vscode').lazy_load()
            require('luasnip.loaders.from_vscode').lazy_load({paths = {"~/.config/nvim/my_snippets/"}})
            -- require('luasnip.loaders.from_lua').load({path = "~/.config/nvim/LuaSnip/"})

            luasnip.config.setup {}
            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                windows = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                formatting = {
                    fields = {'abbr', 'menu' ,'kind'},
                    expandable_indicator = false,
                    format = function (entry, item)
                        local menu_icon = {
                            nvim_lsp = '[LSP]',
                            lua_snip = '[LuaSnip]',
                            buffer = '[Buffer]',
                            path = '[PATH]'
                        }
                        local icons = {
                            Variable = "",
                            Snippet = "<>",
                            Text = "abc",
                            Function = "ƒ",
                            Field = "⌘",
                            Property = '',
                            Class = '◫',
                            Keyword = '◇',
                            Constant = '◁',
                            Struct = '◎',
                            Method = "  ",
                        }
                        item.menu = menu_icon[entry.source.name]
                        item.kind = (icons[item.kind] or "Foo") .. " " .. item.kind
                        return item
                    end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert {
                    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
                    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
                    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-y>'] = cmp.mapping.confirm ({ select = true }),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false}),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumable() then
                            luasnip.expand_or_jump()
                        end
                    end, {'i', 's' }),
                    --['<C-h>'] = cmp.mapping(function()
                    --    if luasnip.locally_jumable(-1) then
                    --        luasnip.jump(-1)
                    --    end
                    --end, {'i', 's' }),
                },
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer', keyword_length = 5, max_item_count = 10 },
                },
            }
        end
    },
    {
        'preservim/tagbar',
        config = function()
            vim.keymap.set('n', '<F8>', '<cmd>TagbarToggle<CR>', { desc = "Open tagbar" })
        end
    },
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true,
         -- use opts = {} for passing setup options
        -- this is equalent to setup({}) function
        opts = {
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            disable_in_macro = true,  -- disable when recording or executing a macro
            disable_in_visualblock = false, -- disable when insert after visual block mode
            disable_in_replace_mode = true,
            ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
            enable_moveright = true,
            enable_afterquote = true,  -- add bracket pairs after quote
            enable_check_bracket_line = true,  --- check bracket in same line
            enable_bracket_in_quote = true, --
            enable_abbr = false, -- trigger abbreviation
            break_undo = true, -- switch for basic rule break undo sequence
            check_ts = false,
            map_cr = true,
            map_bs = true,  -- map the <BS> key
            map_c_h = false,  -- Map the <C-h> key to delete a pair
            map_c_w = false, -- map <c-w> to delete a pair if possible
        }
    },
    {
        'stevearc/aerial.nvim',
        opts = {
            layout = {
                width = vim.g.left_sidebar_width,
                default_direction = 'left',
            },
        },
        -- Optional dependencies
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            { "<leader>cs", "<cmd>AerialToggle<cr>", desc = "Aerial Symbols"}
        },
    },
    --{ "rafamadriz/friendly-snippets" },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                icon_enabled = false,
                theme = 'tokyonight',
                component_separators = '|',
                section_separators = '',
            }
        },
    },
    {
        'folke/tokyonight.nvim',
        priority = 1000,
        init = function()
            vim.cmd.colorscheme 'tokyonight-storm'
            vim.cmd.hi 'Comment gui=none'
        end,
        config = function()
		    require("tokyonight").setup({
                style = "moon",
                light_style = "day",
                transparent = false,
                terminal_color = true,
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark",
                    floats = "dark",
                },
                sidebars = {"qf", "help"},
                day_brightness = 0.3,
                hide_inactive_statusline = false,
                dim_inactive = false,
                lualine_bold = false,
                on_colors = function(colors)
                    colors.hint = colors.green
                    colors.error = "#ff0000"
                end,
                on_highlights = function()
                end,
		    })
	    end
    },
    {
        'nvim-treesitter/nvim-treesitter', build = ':TSUpdate',
        opts = {
            ensure_installed = { 'bash', 'c', 'html','lua', 'markdown','vim', 'vimdoc', 'cpp', 'python'},
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = {}
            },
            indent = {enable = true, disable = {} }
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)
        end
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
                highlight = {duration = 0},
                move_cursor = "begin",
            })
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        opts = {
            filetypes = { "*" },
            user_default_options = {
                RGB = true, -- #RGB hex codes
                RRGGBB = true, -- #RRGGBB hex codes
                names = true, -- "Name" codes like Blue or blue
                RRGGBBAA = false, -- #RRGGBBAA hex codes
                AARRGGBB = false, -- 0xAARRGGBB hex codes
                rgb_fn = false, -- CSS rgb() and rgba() functions
                hsl_fn = false, -- CSS hsl() and hsla() functions
                css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
                -- Available modes for `mode`: foreground, background,  virtualtext
                mode = "background", -- Set the display mode.
                -- Available methods are false / true / "normal" / "lsp" / "both"
                -- True is same as normal
                tailwind = false, -- Enable tailwind colors
                -- parsers can contain values used in |user_default_options|
                sass = { enable = false, parsers = { "css" }, }, -- Enable sass colors
                virtualtext = "■",
                -- update color values even if buffer is not focused
                -- example use: cmp_menu, cmp_docs
                always_update = false
            },
            -- all the sub-options of filetypes apply to buftypes
            buftypes = {"*", "!prompt", "!popup"},
        }
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
          "MunifTanjim/nui.nvim",
          -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    },
    {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre",
        opts = { open_cmd = "noswapfile vnew" },
        -- stylua: ignore
        keys = {
            { "<leader>S", function() require("spectre").toggle() end, desc = "Toggle Spectre"},
            { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
            { "<leader>sw", function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
            { "<leader>sp", function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },
        },
        config = function()
            require('spectre').setup({
                open_cmd = 'vnew',
                live_update = false,
                lnum_for_results = true,
                line_sep_start = '--------------------------------------------',
                result_padding = '|   ',
                line_sep       = '--------------------------------------------',
                highlight = {
                    ui = "String",
                    search = 'DiffChange',
                    replace = 'DiffDelete'
                },
                mapping = {
                    ['tab'] = {
                        map = '<Tab>',
                        cmd = "<cmd>lua require('spectre').tab()<cr>",
                        desc = 'next query'
                    }
                }
            })
        end
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts) require'lsp_signature'.setup(opts) end
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
              signs = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
              },
              signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
              numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
              linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
              word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
              watch_gitdir = {
                follow_files = true
              },
              auto_attach = true,
              attach_to_untracked = false,
              current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
              current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
              },
              current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
              sign_priority = 6,
              update_debounce = 100,
              status_formatter = nil, -- Use default
              max_file_length = 40000, -- Disable if file is longer than this (in lines)
              preview_config = {
                  -- Options passed to nvim_open_win
                  border = 'single',
                  style = 'minimal',
                  relative = 'cursor',
                  row = 0,
                  col = 1
              },
              yadm = {
                enable = false
              },
              on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                  opts = opts or {}
                  opts.buffer = bufnr
                  vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                  if vim.wo.diff then return ']c' end
                      vim.schedule(function() gs.next_hunk() end)
                  return '<Ignore>'
                end, {expr=true})

                map('n', '[c', function()
                  if vim.wo.diff then return '[c' end
                      vim.schedule(function() gs.prev_hunk() end)
                  return '<Ignore>'
                end, {expr=true})

                -- Actions
                map('n', '<leader>hs', gs.stage_hunk)
                map('n', '<leader>hr', gs.reset_hunk)
                map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
                map('n', '<leader>hS', gs.stage_buffer)
                map('n', '<leader>hu', gs.undo_stage_hunk)
                map('n', '<leader>hR', gs.reset_buffer)
                map('n', '<leader>hp', gs.preview_hunk)
                map('n', '<leader>hb', function() gs.blame_line{full=true} end)
                map('n', '<leader>tb', gs.toggle_current_line_blame)
                map('n', '<leader>hd', gs.diffthis)
                map('n', '<leader>hD', function() gs.diffthis('~') end)
                map('n', '<leader>td', gs.toggle_deleted)

                -- Text object
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
              end
            }
        end
    },
    --{
    --  'stevearc/conform.nvim',
    --  opts = {},
    --},
    {
        'gelguy/wilder.nvim'
    },
},
{
    ui = {
        icons = vim.g.have_nerd_font and {} or {
              cmd = '⌘',
              config = '🛠',
              event = '📅',
              ft = '📂',
              init = '⚙',
              keys = '🗝',
              plugin = '🔌',
              runtime = '💻',
              require = '🌙',
              source = '📄',
              start = '🚀',
              task = '📌',
              lazy = '💤 ',
        },
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
            },
        },
    },
}
)

--require("plugins")
--require('core/globals')
--require('core/options')
--require('core/mappings')
