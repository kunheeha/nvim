require("config.keymaps")
require("config.lazy")
local f = io.open(os.getenv("HOME") .. "/.config/theme/current")
local mode = f and f:read("*l") or "light"
if f then f:close() end
require("config.colors").set(mode == "dark" and "rose-pine" or "zenbones")
require("config.options")
require("config.tmux_vim_nav")
require("config.autocorrect")
require("config.copy_path")
