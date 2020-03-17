local x = xresources.get_current_theme()
local theme = {}
--------------------------------------------
--            User Options                --
--------------------------------------------
local fontbase = "Noto Sans "
local bkg,     fg,     accent
local bkg_alt, fg_alt, urgent, acc2

bkg       = "{{bkg}}"
bkg_alt   = "{{bkg_alt}}"
fg        = "{{fg}}"
fg_alt    = "{{fg_alt}}"
accent    = "{{accent1}}"
urgent    = "{{urgent}}"
acc2      = "{{accent2}}"

theme.wibar_width   = 50
--------------------------------------------
--                Theme                   --
--------------------------------------------
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

theme.font                 = fontbase.."8"
theme.taglist_font         = fontbase.."10"
theme.taglist_bg_occupied  = bkg_alt

theme.bg_normal     = bkg
theme.bg_focus      = accent
theme.bg_urgent     = urgent
theme.bg_minimize   = acc2

theme.fg_normal     = fg
theme.fg_focus      = fg_alt
theme.fg_urgent     = fg_alt
theme.fg_minimize   = fg

theme.useless_gap   = dpi(5)
theme.border_width  = dpi(1.5)
theme.border_focus  = accent
theme.border_normal = bkg
theme.border_marked = acc2

theme.systray_icon_spacing = dpi(10)

-- You can use your own layout icons like this:
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"

theme.wallpaper = ConfigPath.."/wallpaper.jpg"
theme.icon_theme = nil

---------------------------------------------------------
--                    Notifications                    --
---------------------------------------------------------
theme.notification_font    = fontbase.."12"
theme.notification_margin  = dpi(10)
theme.notification_border_color = bkg_alt
theme.notification_icon_size = dpi(50)
theme.notification_shape = function (cr, w, h)
  gears.shape.rounded_rect(cr, w, h, 50)
end

naughty.config.padding = dpi(20)
naughty.config.spacing = dpi(15)
naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = dpi(2)
naughty.config.defaults.position = "bottom_right"

naughty.config.presets.normal.icon = ConfigPath.."/icons/info.svg"
naughty.config.presets.low.icon = ConfigPath.."/icons/warning.svg"
naughty.config.presets.critical.icon = ConfigPath.."/icons/error.svg"
naughty.config.presets.critical.bg = bkg
naughty.config.presets.critical.border_color = urgent

return theme
