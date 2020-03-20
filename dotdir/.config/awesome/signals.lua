local screen_utils = require('screen_utils')
local commons = require('commons')

function printtb (t)
    local msg = ""
    for k in pairs(t) do
        msg = msg..tostring(t[k]).."\n"
    end
    naughty.notify({
        title = "debug",
        text = msg
    })
end
------------------------------------------------
--                  Errors                    --
------------------------------------------------
if awesome.startup_errors then
    naughty.notification({
        preset = naughty.config.presets.critical,
        title = "Startup Error",
        message = awesome.startup_errors
    })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notification({
            preset = naughty.config.presets.critical,
            title = "Runtime Error",
            message = tostring(err)
        })

        in_error = false
    end)
end

------------------------------------------------
--                  Client                    --
------------------------------------------------
client.connect_signal("unmanage", function (c)
    local t = awful.screen.focused().selected_tag
    awful.screen.focus(awful.screen.focused())

    if #t:clients() == 0 then
        t.name = commons.icons["empty"]
    end
end)


client.connect_signal("manage", function (c)
    local titlebar = {
        bg_normal = beautiful.bg_normal,
        bg_focus = beautiful.bg_focus,
        size = dpi(3),
        position = "bottom",
    }
    awful.titlebar(c, titlebar):setup({
        widget = wibox.container.background,
    })

    local ttop = titlebar
    ttop.position = "top"
    awful.titlebar(c, ttop):setup({
        widget = wibox.container.background,
    })

    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 8)
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)


client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)


client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus

    local ico = commons.icons[c.instance]
    if not ico then ico = commons.icons["default"] end
    awful.screen.focused().selected_tag.name = ico
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- client.connect_signal("request::titlebars", function (c)
-- end)

------------------------------------------------
--                  Screen                    --
------------------------------------------------
screen.connect_signal("property::geometry", screen_utils.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    screen_utils.set_wallpaper(s)
    screen_utils.add_sidebar(s)
end)


------------------------------------------------
--              Notifications                 --
------------------------------------------------
local volnotif
naughty.connect_signal("request::display", function(n)
    if n.title == "Volume" then
        n.title = ""
        n.width = 275
        n.timeout = 1
        -- n.position = "bottom_middle"
        volnotif = commons.unique_notif(n, volnotif)
        if volnotif ~= n then return end
    end

    local wicon
    if n.icon then wicon = {
            align = "center",
            widget = naughty.widget.icon
        }
    end

    naughty.layout.box {
        notification = n,
        type = "notification",
        position = n.position,
        widget_template = {
            widget   = wibox.container.constraint,
            strategy = "max",
            width = dpi(0),
            {
                id     = "background_role",
                widget = naughty.container.background,
                forced_width = n.width,
                {
                    widget  = wibox.container.margin,
                    margins = beautiful.notification_margin,
                    {
                        widget = wibox.layout.fixed.vertical,
                        spacing = dpi(20),
                        wicon,
                        {
                            align = "center",
                            widget = naughty.widget.message,
                        },
                    }
                }
            }
        }
    }

end)
