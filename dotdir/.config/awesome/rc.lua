beautiful   = require("beautiful")
naughty     = require("naughty")
menubar     = require("menubar")
wibox       = require("wibox")
gears       = require("gears")
awful       = require("awful")
gears       = require("gears")
awful       = require("awful")

require("awful.autofocus")
require('errors')

-- Useful Globals {{{
require('config')
Keys = require('keys')
Buttons = require('mouse')
-- }}}

require('bar')
require('rules')
require('signals')

awful.spawn.with_shell( os.getenv("HOME") .. "/.config/awesome/autostart.sh")
