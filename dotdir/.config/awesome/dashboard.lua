local main_fixed = wibox.layout.fixed.vertical()

local mrg = dpi(20)
local icon_size = dpi(45)

local datetime = wibox.widget {
    widget = wibox.container.background,
    bg     = beautiful.bg_focus,
    {
        widget = wibox.container.margin,
        margins = mrg,
        {
            widget = wibox.layout.align.horizontal,
            expand = 'none',
            nil, {
                widget = wibox.layout.fixed.horizontal,
                spacing = dpi(20),
                {
                    widget = wibox.widget.textclock,
                    format = '%H:%M',
                    font   = beautiful.monospace.."34",
                },
                {
                    widget = wibox.widget.textclock,
                    format = '%a,\n%d %b',
                    font   = beautiful.monospace.."13",
                    align  = 'left'
                }
            }, nil
        }
    }
}

local systray = wibox.widget.systray()

local layoutboxes = wibox.layout.fixed.horizontal()
for s in screen do
    layoutboxes:add(awful.widget.layoutbox(s))
end

local tray = wibox.widget {
    widget = wibox.container.margin,
    margins = dpi(30),
    {
        widget = wibox.layout.align.horizontal,
        expand = 'none',
        nil,
        {
            widget = wibox.layout.fixed.horizontal,
            spacing = beautiful.systray_icon_spacing,
            {
                widget = wibox.container.margin,
                margins = dpi(10),
                layoutboxes
            },
            {
                widget = systray,
                base_size = icon_size
            }
        },
        nil
    }
}

main_fixed:add(datetime)
main_fixed:add(tray)

Dashboard = wibox {
    visible = false,
    ontop = true,
    type = "notification",
    screen = screen.primary,
    widget = main_fixed,
    width = 500,
    height = 250,
}

Dashboard.systray = systray
Dashboard.layoutboxes = layoutboxes
