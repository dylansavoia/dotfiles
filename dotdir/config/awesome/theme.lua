local x = xresources.get_current_theme()
local theme = {}
--------------------------------------------
--            User Options                --
--------------------------------------------
local fontbase = "{{font}} "
local monospace = "{{monospace}} "
local bkg,     fg,     accent
local bkg_alt, fg_alt, urgent, low

bkg       = "{{bkg}}"
bkg_alt   = "{{bkg_alt}}"
fg        = "{{fg}}"
fg_alt    = "{{fg_alt}}"
accent    = "{{accent1}}"
accent_fg = "{{accent1_fg}}"
urgent    = "{{urgent}}"
low       = "{{accent2}}"

theme.wibar_width = 3
--------------------------------------------
--                Theme                   --
--------------------------------------------
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

theme.font                 = fontbase
theme.monospace            = monospace
theme.taglist_font         = fontbase.."12"

theme.taglist_bg_focus     = accent_fg
theme.taglist_bg_occupied  = accent
theme.taglist_bg_urgent    = accent

theme.wibar_bg      = "#000000"

theme.bg_normal     = bkg
theme.bg_focus      = accent
theme.bg_urgent     = urgent
theme.bg_minimize   = low

theme.fg_normal     = fg
theme.fg_focus      = fg_alt
theme.fg_urgent     = fg_alt
theme.fg_minimize   = fg

theme.titlebar_bg_normal = bkg
-- theme.titlebar_bg_focus  = "#FFFFFFBB"
theme.titlebar_bg_focus  = "#999999FF"

theme.useless_gap   = dpi(10)
theme.border_width  = dpi(7)
theme.border_focus  = bkg
theme.border_normal = bkg
theme.border_marked = low

theme.hotkeys_font              = monospace.."16"
theme.hotkeys_description_font  = monospace.."13"

theme.systray_icon_spacing = dpi(20)
theme.bg_systray = bkg

-- You can use your own layout icons like this:
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"

theme.wallpaper = ConfigPath.."/wallpaper.jpg"
theme.icon_theme = nil

---------------------------------------------------------
--                    Notifications                    --
---------------------------------------------------------
theme.notification_font    = fontbase.."14"
theme.notification_bg      = bkg_alt
theme.notification_margin  = dpi(20)
theme.notification_spacing = dpi(10)
theme.notification_border_color = bkg_alt
theme.notification_icon_size = dpi(30)
-- theme.notification_shape = function (cr, w, h)
--   gears.shape.rounded_rect(cr, w, h, 50)
-- end

naughty.config.defaults.border_width = 0
naughty.config.defaults.position = "top_right"
naughty.config.defaults.timeout = 3
naughty.config.presets.critical.bg = theme.bg_normal
naughty.config.presets.normal.border_color = accent
naughty.config.presets.critical.border_color = urgent
naughty.config.presets.low.border_color = low
-- naughty.config.presets.normal.icon = ConfigPath..'/icons/info.svg'
naughty.config.presets.critical.icon = ConfigPath..'/icons/error.svg'
naughty.config.presets.low.icon = ConfigPath..'/icons/warning.svg'

return theme
