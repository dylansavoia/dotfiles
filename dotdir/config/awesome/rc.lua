Modkey = "Mod4"
Terminal = os.getenv("TERMINAL") or "xterm"
Editor = os.getenv("EDITOR") or "nano"
ConfigPath = os.getenv("HOME").."/.config/awesome"
ScriptsPath = os.getenv("HOME").."/.local/scripts"
ThemesPath = require('gears.filesystem').get_themes_dir()

editor_cmd = Terminal .. " -e " .. Editor
----------------------------------------------------------------
--                         Imports                            --
----------------------------------------------------------------
beautiful   = require("beautiful")
naughty     = require("naughty")
menubar     = require("menubar")
wibox       = require("wibox")
gears       = require("gears")
awful       = require("awful")
gears       = require("gears")
awful       = require("awful")

xresources  = require("beautiful.xresources")
dpi         = xresources.apply_dpi
-- StateFile   = awful.util.get_cache_dir() .. "/state"
StateFile   = "./AwesomeWMState"

awful.spawn.with_shell(os.getenv("HOME").."/.config/awesome/autostart.sh")
beautiful.init(ConfigPath.."/theme.lua")

require('rules')
require('signals')
require('notifications')
require('dashboard')
require('table-serialization')
