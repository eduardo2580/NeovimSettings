# Super Simple Neovim

A zero-fuss Neovim config for humans. Copy one file, restart, done.

---

## Installation

**Linux / Mac**
```bash
cp init.lua ~/.config/nvim/init.lua
```

**Windows**
```
%USERPROFILE%\AppData\Local\nvim\init.lua
```

Restart Neovim. Plugins install themselves — no extra steps.

---

## Shortcuts

All the essentials, no Vim muscle memory required.

| Key | Action |
|-----|--------|
| `Alt + t` | Open / close file tree |
| `Alt + f` | Find files |
| `Alt + g` | Search text inside files |
| `Alt + s` | Save file |
| `Alt + q` | Close window |
| `F12` | Open / close terminal |
| `Space` | Show all shortcuts |

You can also click around with your mouse.

---

## What's Included

| Feature | Plugin |
|---------|--------|
| Color theme | tokyonight-night |
| File tree | neo-tree |
| Fuzzy finder | Telescope |
| Syntax highlighting | Treesitter |
| Language servers (LSP) | mason + nvim-lspconfig |
| Autocompletion | nvim-cmp + LuaSnip |
| Git change indicators | gitsigns |
| Floating terminal | toggleterm |
| Shortcut help menu | which-key |
| Auto-close brackets | nvim-autopairs |
| Toggle comments | Comment.nvim |
| Indent guides | indent-blankline |

---

## Language Support

LSP and syntax highlighting are pre-configured for:

Lua · Python · JavaScript / TypeScript · C / C++ · Rust · Go · Bash · JSON · YAML · Markdown

Additional languages can be added via `:Mason`.

---

## LSP Keymaps

These activate automatically when a language server attaches.

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `K` | Hover documentation |
| `Space lr` | Rename symbol |
| `Space la` | Code actions |
| `Space lf` | Format file |

---

## Git Keymaps

| Key | Action |
|-----|--------|
| `]h` | Next change |
| `[h` | Previous change |
| `Space gb` | Blame current line |

---

## Terminal

Press `F12` to open a floating terminal. Press `F12` or `Esc` to close it.

To send the current line (or a visual selection) to the terminal:

```
Space + tr
```

---

## Other Useful Keymaps

| Key | Action |
|-----|--------|
| `Space w` | Save file |
| `Space q` | Close window |
| `Space x` | Save and close |
| `Space bd` | Close buffer |
| `Space tm` | Toggle mouse on/off |
| `Esc` | Clear search highlights |
| `Alt + Arrow` | Move between split windows |
| `Space fb` | List open buffers |
| `Space fo` | Recent files |
| `Space fk` | Browse all keymaps |

---

## Requirements

- Neovim 0.9 or later
- Git (for plugin installation)
- A [Nerd Font](https://www.nerdfonts.com) is optional — the config works without one

---

## Customization

Everything lives in a single file (`init.lua`). To change things:

- **Theme** — swap `tokyonight-night` for any other tokyonight variant (`tokyonight-moon`, `tokyonight-storm`, `tokyonight-day`)
- **Tab width** — change `tabstop` and `shiftwidth` (default: 2)
- **Languages** — add entries to `ensure_installed` in the Treesitter and mason-lspconfig blocks
- **Plugins** — add any lazy.nvim-compatible plugin to the `plugins` table
