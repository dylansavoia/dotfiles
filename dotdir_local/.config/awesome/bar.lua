local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

-- Widgets
local systray_item = wibox.widget.systray()
systray_item:set_horizontal(false)

local systray = wibox.widget {
    widget = wibox.container.margin,
    top = dpi(7),
    bottom = dpi(7),
    {
        widget = systray_item
    }
}

local keyboard = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(2),
    {
        widget = awful.widget.keyboardlayout(),
        align  = 'center',
    }
}

local clock = wibox.widget {
    widget = wibox.container.background,
    bg = beautiful.bg_focus,
    {
        widget = wibox.layout.fixed.vertical,
        {
            widget = wibox.container.margin,
            top = dpi(5),
            bottom = dpi(5),
            {
                widget = wibox.widget.textclock("%H\n%M"),
                align  = 'center',
            }
        },
        {
            widget = wibox.container.margin,
            top = dpi(2),
            bottom = dpi(5),
            {
                widget = wibox.widget.textclock("%d\n%b"),
                align  = 'center',
            }
        }
    }
}

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ Modkey }, 1, function(t)
                              if client.focus then
                                  client.focus:move_to_tag(t)
                              end
                          end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ Modkey }, 3, function(t)
                              if client.focus then
                                  client.focus:toggle_tag(t)
                              end
                          end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)


local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        gears.wallpaper.maximized(wallpaper, s)
    end
end

-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    local min_layout = {
        awful.layout.suit.max,
    }

    -- Each screen has its own tag table.
    for i = 1, 2 do
        awful.tag.add("", {
            layout = awful.layout.suit.tile,
            layouts = min_layout,
            screen = s,
        })
    end

    awful.tag.add("", {
        layout = awful.layout.suit.tile,
        layouts = min_layout,
        screen = s,
    })

    awful.tag.add("", {
        layout = awful.layout.suit.fair,
        layouts = min_layout,
        screen = s,
    })

    awful.tag.add("", {
        layout = awful.layout.suit.floating,
        layouts = min_layout,
        screen = s,
    })

    s.tags[1]:view_only()

    -- Create a taglist widget
    s.tagscol = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout = wibox.layout.fixed.vertical,
        widget_template = {
            widget = wibox.container.background,
            id = "background_role",
            {
                widget = wibox.container.margin,
                margins = dpi(8),
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                    align  = 'center',
                }
            }

        }
    }

    -- Create the wibox
    s.statusbar = awful.wibar({
        width = bar_width,
        position = "left", screen = s
    })

    s.statusbar:setup {
        layout = wibox.layout.align.vertical,
        -- Left
        {
            layout = wibox.layout.fixed.vertical,
            clock,
        },
        { -- Center
            layout = wibox.layout.align.vertical,
            expand = 'outside',
            nil, s.tagscol, nil,
        },
        { -- Right
            layout = wibox.container.margin,
            margins = dpi(3),
            {
                layout = wibox.layout.fixed.vertical,
                keyboard,
                systray,
                awful.widget.layoutbox(s)
            }
        },
    }

end)
