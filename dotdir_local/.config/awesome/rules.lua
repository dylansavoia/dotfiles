-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = Keys.client,
        buttons = Buttons.client,
        size_hints_honor = false,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen
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

    { 
        rule_any = { class = {"qutebrowser", "firefox"} },
        properties = { tag = "", switchtotag = true }
    }

}

