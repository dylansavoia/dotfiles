local commons = require('commons')

local keymapping =  {}
local mouse_buttons = {}
local show_all = false
local curr_tags = {}

-- For directions
local dirmap  = {down=1, up=-1, left=-1, right=1}
local sizemap = {down=1, up=0, left=0, right=1}

-------------------------------------------------------------------------------
--                                 Functions                                 --
-------------------------------------------------------------------------------
local function remove_empty_tag(tag)
    if not tag then
        tag = awful.screen.focused().selected_tag
        if not tag then return end
    end

    if #tag:clients() == 0 and
       #tag.screen.tags > 1
    then tag:delete() end
end

local function create_find_tag(i, scrnum)
    -- This function assures a tag to be found:
    -- If it exists returns that one
    -- otherwise we create it on the fly
    local maxtags, tagnum, scr

    -- No more than 5 (arbitrary chosen)
    maxtags = math.min(10/screen.count(), 5)

    -- If no info given, always attempt
    -- to create a new tag
    -- (setting i to the max value for that screen)
    if not i then i = maxtags * awful.screen.focused().index end

    -- If scrnum not given, find it from i
    if not scrnum then scrnum = math.ceil(i/maxtags) end
    scrnum = math.min(scrnum, screen.count())
    scr = screen[scrnum]

    -- If index too large, simply mod
    tagnum = ((i-1)%maxtags)+1

    -- Check whether new tag is requested
    if tagnum > #scr.tags then
        -- A new tag is requested but the current
        -- one is already empty: use that one
        if #scr.selected_tag:clients() == 0 then
            tag = scr.selected_tag
        else tag = commons.create_tag(scr, i < 1) end
    else tag = scr.tags[tagnum] end

    return tag
end

local function toggle_show_all()
    if not show_all then
        for s in screen do
            table.insert(curr_tags, s.selected_tag)
        end
        awful.tag.viewmore(root.tags())
        show_all = true
    else
        ct = client.focus.first_tag
        awful.tag.viewnone()
        for i = 1, #curr_tags do
            curr_tags[i]:view_only()
        end
        if ct then
            ct:view_only()
        end
        show_all = false
    end
end

local function idx_tag(idx, client)
    local scr = awful.screen.focused()
    local tag = scr.selected_tag

    if client then
        local target = create_find_tag(tag.index+idx, scr.index)
        tag.name = commons.icons["default"]
        client:move_to_tag(target)
    end

    -- if tag.index + idx < 1 or
    --    tag.index + idx > #scr.tags
    -- then return end

    awful.tag.viewidx(idx)
    awful.screen.focus(awful.screen.focused())
    remove_empty_tag(tag)
end

local function focuswap_or_move(d, c)
    -- d = 'up' OR 'down'; c = client to swap
    local scr, tag, dmap, smap
    scr = awful.screen.focused()
    dmap = dirmap[d]
    tag = scr.selected_tag

    local orientation, movement, out_boundaries, out_tag
    orientation = scr.geometry.width > scr.geometry.height
    movement = (d == 'left' or d == 'right')
    out_tag = tag.index + dmap < 1 or tag.index + dmap > #scr.tags
    full_client = false

    if client.focus then
        local clientg, screeng
        local cpos, csize, ssize, smap
        clientg = client.focus:geometry()
        screeng = scr.workarea
        smap = sizemap[d]

        if movement then
            cpos = clientg.x - screeng.x
            csize = clientg.width
            ssize = screeng.width
        else
            cpos = clientg.y - screeng.y
            csize = clientg.height
            ssize = screeng.height
        end

        out_boundaries = cpos * dmap + smap * csize + 50 > ssize * smap
    end

    if not client.focus or
       out_boundaries and (c or not out_tag) and movement ~= orientation then
        idx_tag(dirmap[d], c)
    else
        if c then awful.client.swap.bydirection(d, c, true)
        else
            if movement then awful.client.focus.global_bydirection(d, c, true)
            else awful.client.focus.bydirection(d, c, true) end
        end
    end
end

local function incmw_wrapper(a)
    -- Safety control to not degenerate the size
    -- to zero. For some reason this causes pc to freeze.
    local tag = awful.screen.focused().selected_tag
    if tag.master_width_factor + a < 0.1 then return end
    awful.tag.incmwfact(a, tag)
end

-------------------------------------------------------------------------------
--                                 Keymapping                                --
-------------------------------------------------------------------------------
keymapping.global = gears.table.join(
    ---- Client Manipulation: Select
    awful.key({ Modkey, }, "j",
        function () focuswap_or_move('down', nil) end,
        {description = "focus down", group = "client"}
    ),
    awful.key({ Modkey, }, "k",
        function () focuswap_or_move('up', nil) end,
        {description = "focus up", group = "client"}
    ),
    awful.key({ Modkey, }, "h",
        function () focuswap_or_move('left', nil) end,
        {description = "focus left", group = "client"}
    ),
    awful.key({ Modkey, }, "l",
        function () focuswap_or_move('right', nil) end,
        {description = "focus right", group = "client"}
    ),

    ---- Client Manipulation: Swap
    awful.key({ Modkey, "Shift" }, "j",
        function () focuswap_or_move("down", client.focus) end,
        {description = "swap down", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "k", function () focuswap_or_move("up", client.focus) end,
        {description = "swap up", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "h", function () focuswap_or_move("left", client.focus) end,
        {description = "swap left", group = "client"}
    ),
    awful.key({ Modkey, "Shift" }, "l", function () focuswap_or_move("right", client.focus) end,
        {description = "swap right", group = "client"}
    ),

    -- Layout manipulation
    ---- Layout: Show All Tags
    awful.key({ Modkey, "Shift"   }, "Return", toggle_show_all,
        {description = "show all tags", group = "awesome"}
    ),

    ---- Layout: Switch Between Tags
    awful.key({ Modkey, }, "Tab", function () idx_tag(1) end,
        {description = "go next", group = "client"}
    ),
    awful.key({ Modkey, "Shift"}, "Tab", function () idx_tag(-1) end,
        {description = "go back", group = "client"}
    ),

    ---- Layout: Change Layout
    awful.key({ Modkey,           }, "m", function () awful.layout.inc(1) end,
        {description = "select next", group = "layout"}
    ),
    awful.key({ Modkey, "Shift"   }, "M", function () awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}
    ),

    ---- Layout: Resize Layout
    awful.key({ Modkey, "Mod1" }, "l",     function () incmw_wrapper( 0.10) end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "h",     function () incmw_wrapper(-0.10) end,
        {description = "decrease master width factor", group = "layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "j",     function () incmw_wrapper( 0.10) end,
        {description = "increase master width factor", group = "layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "k",     function () incmw_wrapper(-0.10) end,
        {description = "decrease master width factor", group = "layout"}
    ),


    -- Standard Programs
    awful.key({ Modkey,           }, "space", function () awful.spawn.with_shell('laser') end,
        {description = "open Launcher", group = "launcher"}
    ),
    -- awful.key({ Modkey, }, "Return", function () awful.spawn.with_shell('rofi -show window') end,
    --     {description = "Show Windows", group = "launcher"}
    -- ),
    awful.key({ Modkey, }, "Return", function () awful.spawn(Terminal) end,
        {description = "Show Windows", group = "launcher"}
    ),
    awful.key({ Modkey, "Shift" }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}
    ),
    awful.key({ Modkey, "Shift"   }, "q", awesome.quit,
        {description = "quit awesome", group = "awesome"}
    ),


    -- Audio
    awful.key({ Modkey, }, "F9",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume -10") end,
        {description = "Decrease Vol.", group = "awesome"}
    ),
    awful.key({ Modkey, }, "F10",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume +10") end,
        {description = "Increase Vol.", group = "awesome"}
    ),
    awful.key({ Modkey, }, "F11",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume toggle") end,
        {description = "Toggle Audio", group = "awesome"}
    ),
    awful.key({ Modkey, }, "F12",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume switch") end,
        {description = "Change Source", group = "awesome"}
    ),


    -- Screen
    awful.key({ Modkey, }, "F6",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness +25") end,
        {description = "Increase Light", group = "awesome"}
    ),
    awful.key({ Modkey, }, "F5",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness -25") end,
        {description = "Decrease Light", group = "awesome"}
    ),

    -- Other
    awful.key({ Modkey, }, "Escape", awful.tag.history.restore,
        {description = "go back", group = "tag"}
    ),

    ---- Screen OCR
    awful.key({ Modkey, }, "F1",
        function () awful.spawn.with_shell(ScriptsPath.."/screen") end,
        {description = "OCR", group = "awesome"}
    ),
    awful.key({ Modkey, "Shift"}, "F1",
        function () awful.spawn.with_shell(ScriptsPath.."/screen --ocr") end,
        {description = "OCR", group = "awesome"}
    ),

    ---- Debug Info
    awful.key({ Modkey, }, "/", function ()
        naughty.notification({
            title = "Debug Info",
            message = tostring(awful.screen.focused()).."\n"..tostring(client.focus)
        })
        end,
        {description = "Debug Info", group = "tag"}
    )

)


keymapping.client = gears.table.join(
    -- Client Manipulation
    awful.key({ Modkey, }, "q", function (c) c:kill() end,
        {description = "close", group = "client"}
    ),
    awful.key({ Modkey, }, "f", function(c) c.floating = not c.floating end,
        {description = "toggle floating", group = "client"}
    ),

    awful.key({ Modkey, }, "n",
        function (c)
            awful.client.focus.byidx(1, c)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ Modkey, }, "N",
        function (c)
            awful.client.focus.byidx(-1, c)
        end,
        {description = "focus previous by index", group = "client"}
    )
)


-- Bind all key numbers to tags.
for i = 1, 10 do
    keymapping.global = gears.table.join(keymapping.global,
        -- View tag only.
        awful.key({ Modkey }, "#" .. i + 9,
        function ()
            local prevtag = awful.screen.focused().selected_tag
            local tag = create_find_tag(i)
            tag:view_only()

            if tag ~= prevtag then remove_empty_tag(prevtag) end
            awful.screen.focus(tag.screen)
        end,
        {description = "view tag #"..i, group = "tag"})
    )

    keymapping.client = gears.table.join(keymapping.client,
        -- Move client to tag.
        awful.key({ Modkey, "Shift" }, "#" .. i + 9,
        function (c)
            local prevtag = c.first_tag
            local tag = create_find_tag(i)
            prevtag.name = commons.icons["default"]
            c:move_to_tag(tag)
            remove_empty_tag(prevtag)
            tag:view_only()
            awful.screen.focus(tag.screen)
        end,
        {description = "move focused client to tag #"..i, group = "tag"})
    )
end

-------------------------------------------------------------------------------
--                               Mouse Buttons                               --
--           These are relative to a client so they must be exposed          --
-------------------------------------------------------------------------------
mouse_buttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ Modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ Modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(keymapping.global)

return {
    keymapping = keymapping,
    mouse_buttons = mouse_buttons
}
