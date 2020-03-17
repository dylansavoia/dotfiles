-- Signal function to execute when a new client appears.
local screen_utils = require('screen_utils')
local commons = require('commons')

client.connect_signal("unmanage", function (c)
    local t = awful.screen.focused().selected_tag
    awful.screen.focus(awful.screen.focused())

    if #t:clients() == 0 then
        t.name = commons.icons["empty"]
    end
end)

client.connect_signal("manage", function (c)
    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 8)
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c)
    -- awful.screen.focus(c.screen)
    c.border_color = beautiful.border_focus

    local ico = commons.icons[c.instance]
    if not ico then ico = commons.icons["default"] end
    awful.screen.focused().selected_tag.name = ico
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", screen_utils.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    screen_utils.set_wallpaper(s)
    screen_utils.add_sidebar(s)
end)



-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Startup Error",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Runtime Error",
            text = tostring(err)
        })

        in_error = false
    end)
end

