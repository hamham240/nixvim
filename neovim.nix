{
  lib,
  enableObsidian ? false,
  ...
}:
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
  };

  keymaps = [
    {
      mode = "n";
      key = ";";
      action = ":";
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
      "fb" = "file_browser";
    };
  };
  plugins.obsidian = lib.mkIf enableObsidian {
    enable = true;
    settings = {
      legacy_commands = false;
      completion = {
        min_chars = 2;
        nvim_cmp = true;
      };
      new_notes_location = "current_dir";
      workspaces = [
        {
          name = "math";
          path = "~/obsidian";
        }
      ];
      callbacks = {
        enter_note.__raw = ''
          function(note)
            vim.keymap.set("n", "gd", require("obsidian.api").smart_action, {
              buffer = true,
              desc = "Follow link",
              expr = true;
            })
          end
        '';
      };
    };
  };

  plugins.navic = {
    enable = true;
    settings.lsp.auto_attach = true;
  };

  plugins.treesitter-context.enable = true;

  plugins.lualine = {
    enable = true;
    settings.winbar = {
      lualine_c = [
        {
          __unkeyed-1.__raw = "function() return require('nvim-navic').get_location() end";
          cond.__raw = "function() return require('nvim-navic').is_available() end";
        }
      ];
    };
  };

  plugins.gitsigns.enable = true;
  plugins.comment.enable = true;
  plugins.nvim-autopairs.enable = true;
  plugins.illuminate.enable = true;
  plugins.trouble.enable = true;
  plugins.rustaceanvim.enable = true;
  plugins.clangd-extensions.enable = true;
  plugins.diffview.enable = true;
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = true;
    filesystem = {
      followCurrentFile.enabled = true;
      useLibuvFileWatcher = true;
      filteredItems.hideDotfiles = false;
    };
  };
}
