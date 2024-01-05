local controls = require('controls')
local commons  = require('commons')

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
        properties = { floating = true, sticky = true }
    }
}
