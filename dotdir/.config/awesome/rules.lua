local controls = require('controls')

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = controls.keymapping.client,
        buttons = controls.mouse_buttons,
        size_hints_honor = false,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen + awful.placement.centered
     }
    },

    -- Floating clients.
    { 
        rule_any = {
            role = {
              "AlarmWindow",
              "ConfigManager",
              "pop-up",
            }
        },
        properties = { floating = true }
    },

}

-- ruled.notification.connect_signal('request::rules', function()
--     ruled.notification.append_rule {
--         rule       = { urgency = 'normal' },
--         properties = {
--           border_color = beautiful.bg_focus,
--           icon = ConfigPath.."/icons/info.svg"
--         }
--     }

--     ruled.notification.append_rule {
--         rule       = { urgency = 'low' },
--         properties = {
--           icon = ConfigPath.."/icons/warning.svg"
--         }
--     }

--     ruled.notification.append_rule {
--         rule       = { urgency = 'critical' },
--         properties = {
--           border_color = beautiful.bg_urgent,
--           icon = ConfigPath.."/icons/error.svg"
--         }
--     }
-- end)
