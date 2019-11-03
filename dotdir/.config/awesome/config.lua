Modkey = "Mod4"
Terminal = os.getenv("TERMINAL") or "xterm"
Editor = os.getenv("EDITOR") or "nano"
ConfigPath = os.getenv("HOME").."/.config/awesome"
ScriptsPath = os.getenv("HOME").."/.local/scripts"

-- Themes define colours, icons, font and wallpapers.
beautiful.init(ConfigPath.."/theme.lua")

bar_width = 40

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.fair,
    awful.layout.suit.floating,
}

editor_cmd = Terminal .. " -e " .. Editor
