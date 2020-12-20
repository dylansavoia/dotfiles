local screen_utils = require('screen_utils')
local commons = require('commons')

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
    local nc = #t:clients()
    client.focus = t:clients()[nc]

    if nc == 0 then
        t.name = commons.icons["empty"]
    end
end)


client.connect_signal("manage", function (c)
    local dirs = {"bottom"}
    local titlebar = {
        bg_normal = beautiful.bg_normal,
        bg_focus = '#FFFFFFAA',
        size = dpi(2),
    }
    for _, d in ipairs(dirs) do
        titlebar.position = d
        awful.titlebar(c, titlebar):setup({
            widget = wibox.container.background,
        })
    end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    -- IS_SLAVE: user-defined. Set in controls.lua
    if IS_SLAVE then awful.client.setslave(c) end
end)


client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)


client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    local t = awful.screen.focused().selected_tag
    if t.name ~= commons.icons.bkg then
        local ico = commons.icons[c.class]
        if not ico then ico = commons.icons["default"] end
        t.name = ico
    end

    -- Dashboard
    Dashboard.screen = c.screen
    awful.placement.top_left(Dashboard, {
        honor_workarea = true,
        honor_padding = true,
        margins = beautiful.useless_gap,
    })
    Dashboard.systray.screen = c.screen
    local layouts = Dashboard.layoutboxes.children

    for _, v in pairs(layouts) do v.visible = false end
    layouts[c.screen.index].visible = true
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

------------------------------------------------
--                   Tags                     --
------------------------------------------------
-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    if c.first_tag.name == commons.icons.bkg then return end
    local prevt = awful.screen.focused().selected_tag
    commons.remove_empty_tag(prevt)
    c:jump_to()
end)

------------------------------------------------
--                  Screen                    --
------------------------------------------------
screen.connect_signal("request::wallpaper", screen_utils.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    s.is_horizontal = true  -- s.geometry.width > s.geometry.height
    screen_utils.add_sidebar(s)
    commons.create_tag(s):view_only()
end)

------------------------------------------------
--                  Other                     --
------------------------------------------------
local keyboards = gears.string.split(awesome.xkb_get_group_names():sub(1, 8), "+")

awesome.connect_signal("xkb::group_changed", function ()
    naughty.notification({
        title = "Keyboard Layout",
        icon  = ConfigPath..'/icons/keyboard.svg',
        -- message = awesome.xkb_get_group_names(),
        message = keyboards[awesome.xkb_get_layout_group() + 2]:upper()
    })
end)
