-- Signal function to execute when a new client appears.
local icons = {}
icons["xst"] = ""
icons["xst-256color"] = ""
icons["nvim"] = ""
icons["vifm"] = ""
icons["Zathura"] = ""

client.connect_signal("unmanage", function (c)
    local t = awful.screen.focused().selected_tag
    if t.index ~= 3 then t.name = "" end
end)

client.connect_signal("manage", function (c)

    -- naughty.notify({
    --     title = "Icon",
    --     text = c.class
    -- })

    local t = awful.screen.focused().selected_tag
    if t.index ~= 3 then
        local ico = icons[c.class]
        if ico then t.name = ico end
    end

    c.shape = function(cr, w, h)
        gears.shape.rounded_rect(cr, w, h, 5)
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
    c.border_color = beautiful.border_focus

    local t = awful.screen.focused().selected_tag
    if t.index ~= 3 then
        local ico = icons[c.class]
        if ico then t.name = ico end
    end

    -- naughty.notify({
    --     title = "Icon",
    --     text = c.class
    -- })
end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
