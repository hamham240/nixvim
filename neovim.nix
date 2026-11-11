{ ... }:
{
  colorschemes.monokai-pro.enable = true;

  globals = {
    mapleader = " ";
  };

  opts = {
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    clipboard = "unnamedplus";
    conceallevel = 2;
    smartindent = false;
    autoindent = false;
    undofile = true;
    number = true;
    mouse = "";
    shell.__raw = "vim.uv.os_get_passwd().shell";
  };

  keymaps = [
    {
      mode = "n";
      key = ";";
      action = ":";
    }
    {
      mode = "n";
      key = "<leader>/";
      action = "gcc";
      options = {
        remap = true;
        desc = "Toggle comment on line";
      };
    }
    {
      mode = "v";
      key = "<leader>/";
      action = "gc";
      options = {
        remap = true;
        desc = "Toggle comment on selection";
      };
    }
    {
      mode = "n";
      key = "<leader>h";
      action = "<cmd>ClangdSwitchSourceHeader<CR>";
      options.desc = "Switch to header/source";
    }
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Move to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Move to upper window";
    }
    {
      mode = "n";
      key = "<C-n>";
      action = "<cmd>Neotree toggle<CR>";
      options.desc = "Toggle file tree";
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }
    {
      mode = "n";
      key = "<leader>xx";
      action = "<cmd>Trouble diagnostics toggle<CR>";
      options.desc = "Toggle diagnostics panel";
    }
    {
      mode = "n";
      key = "<leader>xX";
      action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      options.desc = "Toggle diagnostics panel (current buffer)";
    }
  ];

  plugins.lsp = {
    enable = true;
    keymaps = {
      lspBuf = {
        gd = {
          action = "definition";
          desc = "Go to definition";
        };
        gD = {
          action = "declaration";
          desc = "Go to declaration";
        };
      };
    };
    servers = {
      clangd.enable = true;
      pyright.enable = true;
      nixd = {
        enable = true;
        settings.nixd = {
          nixpkgs.expr = "import <nixpkgs> {}";
          options.nixos.expr = "(builtins.getFlake \"/home/mjaved/.nixos\").nixosConfigurations.mjaved-nixos.options";
          options.home-manager.expr = "(builtins.getFlake \"/home/mjaved/.nixos\").homeConfigurations.mjaved.options";
        };
      };
    };
  };
  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp = {
    enable = true;
    settings.sources = [
      { name = "nvim_lsp"; }
      { name = "buffer"; }
      { name = "path"; }
      { name = "luasnip"; }
    ];
    settings.mapping = {
      "<C-Space>" = "cmp.mapping.complete()";
      "<CR>" = "cmp.mapping.confirm({ select = true })";
      "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
      "<C-e>" = "cmp.mapping.abort()";
    };
    settings.performance.fetching_timeout = 1500;
  };
  plugins.luasnip.enable = true;
  plugins.treesitter = {
    enable = true;
    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
  plugins.web-devicons.enable = true;

  plugins.telescope = {
    enable = true;
    settings.defaults = {
    };
    extensions.file-browser = {
      enable = true;
      settings = {
        initial_mode = "normal";
        hijack_netrw = true;
      };
    };
    keymaps = {
      "tf" = "find_files";
      "tl" = "live_grep";
      "tb" = "buffers";
      "tr" = "resume";
      "tg" = "git_status";
      "fb" = "file_browser";
    };
  };
  plugins.navic = {
    enable = true;
    settings.lsp.auto_attach = true;
  };

  plugins.treesitter-context.enable = true;

  plugins.lualine = {
    enable = true;
    settings.sections = {
      lualine_b = [
        "branch"
        "diff"
      ];
      lualine_c = [
        "filename"
        {
          __unkeyed-1 = "diagnostics";
          sources = [ "nvim_diagnostic" ];
          always_visible = true;
        }
        {
          # Message of the most severe diagnostic on the cursor's line
          __unkeyed-1.__raw = ''
            function()
              local diags = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
              if #diags == 0 then return "" end
              table.sort(diags, function(a, b) return a.severity < b.severity end)
              return (diags[1].message:gsub("\n.*", ""))
            end
          '';
        }
      ];
      lualine_x = [
        {
          # Each attached server with its stage: the short title of its current
          # work (e.g. "rust-analyzer: Indexing 45%") or a check mark once it has
          # no work in progress. Skips the per-file messages that flashed by.
          __unkeyed-1.__raw = ''
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then return "" end
              local parts = {}
              for _, c in ipairs(clients) do
                local stage = "✓"
                for _, task in pairs((_G.lsp_stage or {})[c.id] or {}) do
                  stage = task.title .. (task.pct and (" " .. task.pct .. "%%") or "")
                  break
                end
                table.insert(parts, c.name .. ": " .. stage)
              end
              return " " .. table.concat(parts, "  ")
            end
          '';
        }
        "encoding"
        "fileformat"
        "filetype"
      ];
    };
    settings.winbar = {
      lualine_c = [
        {
          __unkeyed-1.__raw = "function() return require('nvim-navic').get_location() end";
          cond.__raw = "function() return require('nvim-navic').is_available() end";
        }
      ];
    };
  };

  # Redraw the statusline as LSP progress messages arrive
  autoCmd = [
    {
      # Track the current stage of each server's work, per progress token
      event = "LspProgress";
      callback.__raw = ''
        function(ev)
          local id, token = ev.data.client_id, ev.data.params.token
          local v = ev.data.params.value
          if type(v) ~= "table" then return end
          _G.lsp_stage = _G.lsp_stage or {}
          local tasks = _G.lsp_stage[id] or {}
          _G.lsp_stage[id] = tasks
          if v.kind == "end" then
            tasks[token] = nil
          elseif v.kind == "begin" then
            tasks[token] = { title = v.title or "Working", pct = v.percentage }
          elseif tasks[token] then
            tasks[token].pct = v.percentage or tasks[token].pct
          end
          require("lualine").refresh()
        end
      '';
    }
    {
      # Forget a server's work when it stops
      event = "LspDetach";
      callback.__raw = "function(ev) if _G.lsp_stage then _G.lsp_stage[ev.data.client_id] = nil end end";
    }
  ];

  plugins.gitsigns.enable = true;
  plugins.comment.enable = true;
  plugins.nvim-autopairs.enable = true;
  plugins.illuminate.enable = true;
  plugins.trouble.enable = true;
  plugins.rustaceanvim = {
    enable = true;
    settings.server.default_settings.rust-analyzer.cargo.targetDir = true;
    settings.server.on_attach.__raw = ''
      function(_, bufnr)
        -- Local docs: rustdoc pages in target/doc (built with `cargo doc`), found
        -- by item name. Pages under 1KB are rustdoc re-export redirect stubs.
        local function local_docs(word)
          local root = vim.fs.root(bufnr, "Cargo.toml")
          if not root then return {} end
          local pages = {}
          for _, depth in ipairs({ "*", "*/*", "*/*/*" }) do
            vim.list_extend(pages, vim.fn.glob(root .. "/target/doc/" .. depth .. "/*." .. word .. ".html", false, true))
          end
          return vim.tbl_filter(function(p) return vim.fn.getfsize(p) > 1024 end, pages)
        end
        local function remote_docs() vim.cmd.RustLsp("openDocs") end

        vim.keymap.set("n", "<leader>K", function()
          local pages = local_docs(vim.fn.expand("<cword>"))
          if #pages == 0 then
            remote_docs()
          elseif #pages == 1 then
            vim.ui.open(pages[1])
          else
            vim.ui.select(pages, { prompt = "Local docs" }, function(p) if p then vim.ui.open(p) end end)
          end
        end, { buffer = bufnr, desc = "Open local docs (fallback: docs.rs)" })
        vim.keymap.set("n", "<leader>gK", remote_docs,
          { buffer = bufnr, desc = "Open docs.rs for symbol under cursor" })
      end
    '';
  };
  dependencies.rust-analyzer.enable = false;
  plugins.clangd-extensions.enable = true;
  plugins.diffview.enable = true;
  plugins.toggleterm = {
    enable = true;
    settings = {
      open_mapping = "[[<C-t>]]";
      direction = "horizontal";
      size = 15;
    };
  };
  plugins.neo-tree = {
    enable = true;
    settings = {
      close_if_last_window = true;
      filesystem = {
        follow_current_file.enabled = true;
        use_libuv_file_watcher = true;
        filtered_items.hide_dotfiles = false;
      };
    };
  };
}
