require("config.keymaps")
require("config.lazy")
local f = io.open(os.getenv("HOME") .. "/.config/theme/current")
local mode = f and f:read("*l") or "light"
if f then f:close() end
local theme_map = { dark = "rose-pine", nord = "nord" }
require("config.colors").set(theme_map[mode] or "zenbones")
require("config.options")
require("config.tmux_vim_nav")
require("config.autocorrect")
require("config.copy_path")
