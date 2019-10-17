local keys =  {}
local show_all = false

keys.global = gears.table.join(
    -- Client Manipulation
    awful.key({ Modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ Modkey,           }, "n",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ Modkey,           }, "N",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ Modkey, }, "f",  awful.client.floating.toggle,
              {description = "toggle floating", group = "client"}),

    -- Client Manipulation: Special: Browser Tag
    awful.key({ Modkey, }, "b",
        function ()
            local tag = awful.tag.find_by_name(awful.screen.focused(), "")
            tag:view_only()
        end,
        {description = "Go To Browser", group = "client"}
    ),
    awful.key({ Modkey, "Shift"}, "b",
        function ()
            local tag = awful.tag.find_by_name(awful.screen.focused(), "")
            client.focus:move_to_tag(tag)
            tag:view_only()
        end,
        {description = "Move To Browser", group = "client"}
    ),

    
    ---- Client Manipulation: Select
    awful.key({ Modkey,           }, "j",
        function () awful.client.focus.global_bydirection("down") end,
        {description = "focus down", group = "client"}
    ),
    awful.key({ Modkey,           }, "k",
        function () awful.client.focus.global_bydirection("up") end,
        {description = "focus up", group = "client"}
    ),
    awful.key({ Modkey,           }, "h",
        function () awful.client.focus.global_bydirection("left") end,
        {description = "focus left", group = "client"}
    ),
    awful.key({ Modkey,           }, "l",
        function () awful.client.focus.global_bydirection("right") end,
        {description = "focus right", group = "client"}
    ),

    ---- Client Manipulation: Swap
    awful.key({ Modkey, "Shift" }, "j",
        function () awful.tag.viewnext(awful.screen.focused()) end,
        {description = "swap down", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "k",
        function () awful.tag.viewprev(awful.screen.focused()) end,
        {description = "swap up", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "h",
        function () awful.client.swap.global_bydirection("left") end,
        {description = "swap left", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "l",
        function () awful.client.swap.global_bydirection("right") end,
        {description = "swap right", group = "client"}
    ),

    -- Layout manipulation
    awful.key({ Modkey, }, "Tab",
        function () awful.tag.history.restore(awful.screen.focused()) end,
        {description = "go back", group = "client"}),

    awful.key({ Modkey,           }, "m", function () awful.layout.inc( 1) end,
              {description = "select next", group = "layout"}),
    awful.key({ Modkey, "Shift"   }, "M", function () awful.layout.inc(-1) end,
              {description = "select previous", group = "layout"}),

    awful.key({ Modkey, "Mod1" }, "l",     function () awful.tag.incmwfact( 0.10) end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ Modkey, "Mod1" }, "h",     function () awful.tag.incmwfact(-0.10) end,
              {description = "decrease master width factor", group = "layout"}),


    -- Standard Programs
    awful.key({ Modkey,           }, "Return", function () awful.spawn(Terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ Modkey,           }, "space", function () awful.spawn.with_shell('laser') end,
              {description = "open Launcher", group = "launcher"}),
    awful.key({ Modkey, "Shift" }, "space", function () awful.spawn.with_shell('rofi -show window') end,
              {description = "Show Windows", group = "launcher"}),
    awful.key({ Modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ Modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Audio
    awful.key({ Modkey, }, "F8",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume -10%") end,
        {description = "Decrease Vol.", group = "awesome"}),
    awful.key({ Modkey, }, "F9",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume +10%") end,
        {description = "Increase Vol.", group = "awesome"}),
    awful.key({ Modkey, }, "F11",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume toggle") end,
        {description = "Toggle Audio", group = "awesome"}),
    awful.key({ Modkey, }, "F12",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume switch") end,
        {description = "Change Source", group = "awesome"}),

    -- Other
    ---- Screen OCR
    awful.key({ Modkey, }, "F2",
        function () awful.spawn.with_shell(ScriptsPath.."/screen") end,
        {description = "OCR", group = "awesome"}),
    ---- Show All Tags
    awful.key({ Modkey, "Shift"   }, "t",
        function ()
            if not show_all then
                awful.tag.viewmore(awful.screen.focused().tags)
                show_all = true
            else 
                -- awful.tag.viewnone()
                awful.tag.history.restore(awful.screen.focused())
                show_all = false
            end
        end,
        {description = "show all tags", group = "awesome"})

)

-- Bind all key numbers to tags.
for i = 1, 10 do
    keys.global = gears.table.join(keys.global,
        -- View tag only.
        awful.key({ Modkey }, "#" .. i + 9,
        function ()
              local tag = root.tags()[i]
              if tag then
                 tag:view_only()
              end
        end,
        {description = "view tag #"..i, group = "tag"}),

        -- Toggle tag display.
        awful.key({ Modkey, "Control" }, "#" .. i + 9,
        function ()
            local tag = root.tags()[i]
            if tag then
               awful.tag.viewtoggle(tag)
            end
        end,
        {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({ Modkey, "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = root.tags()[i]
                if tag then
                    client.focus:move_to_tag(tag)
                    tag:view_only()
                end
           end
        end,
        {description = "move focused client to tag #"..i, group = "tag"})

    )
end

keys.client = gears.table.join(
    awful.key({ Modkey, }, "w", function (c) c:kill() end,
              {description = "close", group = "client"})
)

-- Set keys
root.keys(keys.global)
return keys
