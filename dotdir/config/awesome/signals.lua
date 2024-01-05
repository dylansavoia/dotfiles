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
    -- client.focus = t:clients()[nc]
    -- client.focus = awful.client.getmaster

    if nc > 1 then
        for _, c in ipairs(t:clients()) do
            TEMP = tostring(c).."\n"
            if c ~= awful.client.getmaster() then
                client.focus = c
                candidate = true
                break
            end
        end
    else
        client.focus = t:clients()[1]
    end


    -- naughty.notification({
    --     title = "TEMP",
    --     preset = naughty.config.presets.critical,
    --     message = TEMP.."\n\n"..tostring(awful.client.getmaster())
    -- })

    if nc == 0 then
        t.name = commons.icons["empty"]
    end
end)


client.connect_signal("manage", function (c)
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

local mouse_timer = nil
client.connect_signal("focus", function(c)
    if mouse.current_client ~= c then
        if mouse_timer then mouse_timer:stop() end
        mouse_timer = gears.timer.weak_start_new(0.1, function()
            if c then
                mouse.coords({ x = c.x + (c.width or 1) /2, y = c.y + (c.height or 1)/2 })
            end
        end)
    end
    -- commons.set_client_border(c)

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

------------------------------------------------
--                   Tags                     --
------------------------------------------------
-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    local prevt = awful.screen.focused().selected_tag
    commons.remove_empty_tag(prevt)
    c:jump_to()
end)

------------------------------------------------
--                  Screen                    --
------------------------------------------------
screen.connect_signal("request::wallpaper", screen_utils.set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    w = s.geometry.width
    h = s.geometry.height

    s.is_landscape = w > h
    s.is_horizontal = true  

    screen_utils.add_sidebar(s)
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

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

awesome.connect_signal("startup", function()
    if file_exists(StateFile) then
        commons.load_state()
    else
        for s in screen do
            commons.create_tag(s):view_only()
        end
    end
end)
