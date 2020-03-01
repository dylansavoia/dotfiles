beautiful   = require("beautiful")
naughty     = require("naughty")
menubar     = require("menubar")
wibox       = require("wibox")
gears       = require("gears")
awful       = require("awful")
gears       = require("gears")
awful       = require("awful")

awful.spawn.with_shell( os.getenv("HOME") .. "/.config/awesome/autostart.sh")

require("awful.autofocus")
require('errors')

-- Useful Globals {{{
require('config')
Keys = require('keys')
Buttons = require('mouse')
-- }}}

require('theme')
require('rules')
require('signals')
require('bar')
