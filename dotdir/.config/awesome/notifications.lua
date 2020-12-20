local commons = require('commons')

local prev = { title = "" }

local notifs = {
    ['Disconnected'] = {
        icon = ConfigPath..'/icons/disconnect.svg'
    },

    ['Connection Established'] = {
        icon = ConfigPath..'/icons/connect.svg'
    },

    ['Volume'] = {
        position = "top_middle",
        timeout = 1,
        width = 100
    },

    ['Volume Text'] = {
        position = "top_middle",
        timeout = 1,
        width = 200
    },

    ['Tag Layout'] = {
        position = "top_middle",
        timeout = 1,
    },

    ['Keyboard Layout'] = {
        position = "top_middle",
        timeout = 1,
    }
}

naughty.connect_signal("request::display", function(n)
    -- Setup Arguments
    if notifs[n.title] then
        for k, v in pairs(notifs[n.title]) do n[k] = v end
    end

    if not n.icon then
        n.icon = ConfigPath..'/icons/info.svg'
    end

    -- n.message = n.title
    if n.title == prev.title then
        prev = commons.unique_notif(n, prev)
        if prev ~= n then return end
    else prev = n end

    -- Draw New Widget
    local wicon, msg
    if n.icon then wicon = {
            widget = wibox.container.background,
            bg     = n.border_color,
            {
                widget = wibox.container.margin,
                margins = beautiful.notification_margin,
                {
                    align = "center",
                    widget = naughty.widget.icon
                }
            }
        }
    end

    if n.message ~= "" then msg = {
            id     = "background_role",
            widget = naughty.container.background,
            forced_width = n.width,
            {
                widget  = wibox.container.margin,
                margins = beautiful.notification_margin,
                {
                    widget = wibox.container.constraint,
                    strategy = "max",
                    width = 500,
                    {
                        align = "center",
                        wrap  = "word",
                        widget = naughty.widget.message,
                    }
                }
            }
        }
    end

    naughty.layout.box {
        notification = n,
        type = "notification",
        position = n.position,
        widget_template = {
                widget = wibox.layout.fixed.horizontal,
                wicon,
                msg
        }
    }

end)

