-- Needed in signals.lua > manage
IS_SLAVE     = true
IS_PICOM_DIM = true

local commons = require('commons')
local hotkeys = require('awful.hotkeys_popup')

local keymapping =  {}
local mouse_buttons = {}

-- Prepend All Descriptions with:
local dsep = '\t' 

-- For directions
local dirmap  = {down=1, up=-1, left=-1, right=1}
local sizemap = {down=1, up=0,  left=0,  right=1}

-- For Dashboard
local prev_mouse_coords = nil
-------------------------------------------------------------------------------
--                                 Functions                                 --
-------------------------------------------------------------------------------
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

local curr_tags = {}
local function toggle_show_all()
    if #root.tags() == 1 then return end
    show_all = true
    for _, t in ipairs(awful.screen.focused().tags) do
        if not t.selected then 
            show_all = false
            break
        end
    end

    if not show_all then
        for s in screen do
            curr_tags[s.index]= {
                s.selected_tag,
                s.tags[1].layout
            }
            if s.is_landscape then
                s.tags[1].layout = awful.layout.suit.fair.horizontal
            else s.tags[1].layout = awful.layout.suit.fair end
        end
        awful.tag.viewmore(root.tags())
        show_all = true
    else
        if not client.focus then client.focus = client.get()[1] end
        local c = client.focus

        for _, t in ipairs(awful.screen.focused().tags) do
            if #t:clients() == 0 then t:delete() end
        end

        for k, v in pairs(curr_tags) do
            screen[k].tags[1].layout = v[2]
            if k == awful.screen.focused().index then
                c.first_tag:view_only()
            else v[1]:view_only() end
        end

        show_all = false
    end
end

local function idx_tag(idx, client)
    local scr = awful.screen.focused()
    local tag = scr.selected_tag

    if client then
        local target = create_find_tag(tag.index+idx, scr.index)
        -- tag.name = commons.icons["default"]
        client:move_to_tag(target)
    end

    -- if tag.index + idx < 1 or
    --    tag.index + idx > #scr.tags
    -- then return end

    awful.tag.viewidx(idx)
    awful.screen.focus(awful.screen.focused())
    commons.remove_empty_tag(tag)
end

local function focuswap_or_move(d, c)
    -- d = 'up' OR 'down'; c = client to swap
    local scr, tag, dmap, smap
    local clientg, screeng
    local cpos, csize, ssize, smap
    local movement, out_boundaries, out_tag

    scr = awful.screen.focused()
    dmap = dirmap[d]
    tag = scr.selected_tag

    movement = (d == 'left' or d == 'right')
    out_tag = tag.index + dmap < 1 or tag.index + dmap > #scr.tags
    full_client = false

    if client.focus then
        clientg = client.focus:geometry()
        screeng = scr.workarea
        smap = sizemap[d]

        if movement then
            cpos = clientg.x - screeng.x
            spos  = screeng.x
            csize = clientg.width
            ssize = screeng.width
        else
            cpos = clientg.y - screeng.y
            spos  = screeng.y
            csize = clientg.height
            ssize = screeng.height
        end

        out_boundaries = cpos * dmap + smap * csize + 50 > ssize * smap
    end


    if (out_boundaries or not client.focus) and (c or not out_tag) and movement ~= scr.is_horizontal then
        idx_tag(dmap, c)
    else
        if c then
            if out_boundaries then
                -- Translated Point
                tp = spos + ssize * smap + dmap * 50
                for s in screen do
                    if movement then
                        s2pos  = s.workarea.x
                        s2size = s.workarea.width
                    else
                        s2pos  = s.workarea.y
                        s2size = s.workarea.height
                    end
                    if tp > s2pos and tp < s2pos + s2size then
                        c:move_to_tag(s.selected_tag)
                        awful.screen.focus(s)
                        return
                   end
                end
            else
                awful.client.swap.bydirection(d, c, true)
                gears.timer.weak_start_new(0.1, function()
                    if c then mouse.coords({ x = c.x + c.width/2, y = c.y + c.height/2 }) end
                end)
            end
        else
            if movement then awful.client.focus.global_bydirection(d, c, true)
            else awful.client.focus.bydirection(d, c, true) end
        end
    end
end

local function resize_wrapper(d)
    local movement = (d == 'left' or d == 'right')
    local a
    local scr = awful.screen.focused()
    local tag = scr.selected_tag
    local w, h, is_landscape

    local clientg, screeng
    local cpos, csize, ssize
    clientg = client.focus:geometry()
    screeng = scr.workarea

    w = scr.geometry.width
    h = scr.geometry.height
    is_landscape = w > h

    if movement then
        cpos = clientg.x - screeng.x
        csize = clientg.width
        ssize = screeng.width
    else
        cpos = clientg.y - screeng.y
        csize = clientg.height
        ssize = screeng.height
    end

    -- Safety control to not degenerate the size
    -- to zero. For some reason this causes pc to freeze.
    if is_landscape == movement then
        a = 0.05 * dirmap[d]
        if tag.master_width_factor + a < 0.1 then return end
        awful.tag.incmwfact(a)
    else
        a = 0.10
        if cpos + dirmap[d] * 50 < 0 or
           cpos + csize + dirmap[d] * 50 > ssize then
           a = a * -1.0
       end
        awful.client.incwfact(a)
    end

end

local function toggle_sticky(c)
    c.sticky = not c.sticky
    c.ontop = not c.ontop
    commons.set_client_border(c)
end


local function change_layout(idx)
    awful.layout.inc(idx)

    local layout = awful.screen.focused().selected_tag.layout.name
    naughty.notification({
        title = "Tag Layout",
        message = "",
        icon = ConfigPath..'/icons/layouts/'..layout..'w.png'
    })
end

-------------------------------------------------------------------------------
--                                 Keymapping                                --
-------------------------------------------------------------------------------
keymapping.global = gears.table.join(
    ---- Client Manipulation: Select
    awful.key({ Modkey, }, "j",
        function () focuswap_or_move('down', nil) end,
        {description = dsep.."Focus Direction", group = "Client"}
    ),
    awful.key({ Modkey, }, "k",
        function () focuswap_or_move('up', nil) end,
        {description = dsep.."Focus Direction", group = "Client"}
    ),
    awful.key({ Modkey, }, "h",
        function () focuswap_or_move('left', nil) end,
        {description = dsep.."Focus Direction", group = "Client"}
    ),
    awful.key({ Modkey, }, "l",
        function () focuswap_or_move('right', nil) end,
        {description = dsep.."Focus Direction", group = "Client"}
    ),

    ---- Client Manipulation: Swap
    awful.key({ Modkey, "Shift" }, "j",
        function () focuswap_or_move("down", client.focus) end,
        {description = dsep.."Swap Down", group = "Client"}
    ),
    awful.key({ Modkey, "Shift" }, "k", function () focuswap_or_move("up", client.focus) end,
        {description = dsep.."Swap Up", group = "Client"}
    ),
    awful.key({ Modkey, "Shift" }, "h", function () focuswap_or_move("left", client.focus) end,
        {description = dsep.."Swap Left", group = "Client"}
    ),
    awful.key({ Modkey, "Shift" }, "l", function () focuswap_or_move("right", client.focus) end,
        {description = dsep.."Swap Right", group = "Client"}
    ),

    -- Layout manipulation
    ---- Layout: Show All Tags
    awful.key({ Modkey, "Shift" }, "Return", toggle_show_all,
        {description = dsep.."Show All Tags", group = "Tag"}
    ),

    ---- Layout: New Tag
    awful.key({ Modkey, }, "e", function ()
        if not client.focus then return end
        local t = commons.create_tag()
        t:view_only()
    end,
        {description = dsep.."Show All Tags", group = "Tag"}
    ),

    awful.key({ Modkey, }, "b", function (c)
            local bkg_t = awful.tag.find_by_name(nil, commons.icons.bkg)
            if not bkg_t then return end
            bkg_t:view_only()
            awful.screen.focus(bkg_t.screen)
        end,
        {description = dsep.."Show Bkg Tag", group = "Client"}
    ),

    ---- Layout: Switch Between Tags
    awful.key({ Modkey, }, "Tab", function () idx_tag(1) end,
        {description = dsep.."Next Tag", group = "Tag"}
    ),
    awful.key({ Modkey, "Shift"}, "Tab", function () idx_tag(-1) end,
        {description = dsep.."Prev. Tag", group = "Tag"}
    ),

    ---- Layout: Gaps
    awful.key({ Modkey, "Shift" }, "g", function () 
        awful.screen.focused().selected_tag.gap = beautiful.useless_gap
    end,
        {description = dsep.."Show Gaps", group = "Layout"}
    ),
    awful.key({ Modkey, }, "g", function ()
        local scr = awful.screen.focused() 
        if scr.selected_tag.gap == 1 then scr.selected_tag.gap = beautiful.useless_gap
        else scr.selected_tag.gap = 1 end
    end,
        {description = dsep.."Hide Gaps", group = "Layout"}
    ),

    ---- Layout: Change Layout
    awful.key({ Modkey,           }, "m", function ()
        change_layout(1)
    end,
        {description = dsep.."Select Next Layout", group = "Layout"}
    ),

    ---- Layout: Resize Layout
    awful.key({ Modkey, "Mod1" }, "l",     function () resize_wrapper('right') end,
        {description = dsep.."+/- Master Width Horizontal", group = "Layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "h",     function () resize_wrapper('left') end,
        {description = dsep.."+/- Master Width Horizontal", group = "Layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "j",     function () resize_wrapper('down') end,
        {description = dsep.."+/- Master Width Vertical", group = "Layout"}
    ),
    awful.key({ Modkey, "Mod1" }, "k",     function () resize_wrapper('up') end,
        {description = dsep.."+/- Master Width Vertical", group = "Layout"}
    ),


    -- Standard Programs
    awful.key({ Modkey, }, "space", function ()
        IS_SLAVE = false
        awful.spawn.with_shell('laser')
    end,
        {description = dsep.."Open Launcher", group = "Applications"}
    ),
    awful.key({ Modkey, "Shift" }, "space", function ()
        IS_SLAVE = true
        awful.spawn.with_shell('laser')
    end,
        {description = dsep.."Open Launcher", group = "Applications"}
    ),
    awful.key({ Modkey, }, "Return", function () 
        IS_SLAVE = true
        awful.spawn(Terminal)
    end,
        {description = dsep.."Show All Windows", group = "Applications"}
    ),


    -- Audio
    awful.key({ Modkey, }, "F9",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume -10") end,
        {description = dsep.."+/- Volume", group = "System"}
    ),
    awful.key({ Modkey, }, "F10",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume +10") end,
        {description = dsep.."+/- Volume", group = "System"}
    ),
    awful.key({ Modkey, }, "F11",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume toggle") end,
        {description = dsep.."Mute/Unmute", group = "System"}
    ),
    awful.key({ Modkey, }, "F12",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume switch") end,
        {description = dsep.."Change Source", group = "System"}
    ),
    awful.key({}, "XF86AudioLowerVolume",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume -10") end,
        {description = dsep.."+/- Volume", group = "System"}
    ),
    awful.key({}, "XF86AudioRaiseVolume",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume +10") end,
        {description = dsep.."+/- Volume", group = "System"}
    ),
    awful.key({}, "XF86AudioMute",
        function () awful.spawn.with_shell(ScriptsPath.."/set_volume toggle") end,
        {description = dsep.."Mute/Unmute", group = "System"}
    ),


    -- Screen
    awful.key({ Modkey, }, "F6",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness +50") end,
        {description = dsep.."+/- Brightness", group = "System"}
    ),
    awful.key({ Modkey, }, "F5",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness -50") end,
        {description = dsep.."+/- Brightness", group = "System"}
    ),
    awful.key({}, "XF86MonBrightnessUp",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness +100") end,
        {description = dsep.."+/- Brightness", group = "System"}
    ),
    awful.key({}, "XF86MonBrightnessDown",
        function () awful.spawn.with_shell(ScriptsPath.."/set_brightness -100") end,
        {description = dsep.."+/- Brightness", group = "System"}
    ),
    awful.key({ Modkey, }, "i",
        function ()
            beautiful.init(ConfigPath.."/theme.lua")
        end,
        {description = dsep.."+/- Brightness", group = "System"}
    ),

    -- Other
    awful.key({Modkey}, "p",
        function () awful.spawn.with_shell(ScriptsPath.."/server_pw.sh", function () end) end,
        {description = dsep.."User+PW", group = "System"}
    ),
    awful.key({Modkey, "Mod1" }, "p",
        function () awful.spawn.with_shell(ScriptsPath.."/server_pw.sh true", function () end) end,
        {description = dsep.."PW Only", group = "System"}
    ),
    awful.key({ Modkey, "Shift" }, "r",
        function ()
            commons.save_state()
            awesome.restart()
        end,
        {description = dsep.."Reload Configuration", group = "Awesome"}
    ),
    awful.key({ Modkey, "Shift"   }, "q", awesome.quit,
        {description = dsep.."Quit", group = "Awesome"}
    ),
    awful.key({ Modkey, "Shift"   }, "/", hotkeys.show_help,
        {description = dsep.."Show Mappings", group = "Awesome"}
    ),
    awful.key({ Modkey, }, "Escape", function () 
        awful.tag.history.restore()
        awful.screen.focus(awful.screen.focused())
    end,
        {description = dsep.."Previous Tag", group = "Tag"}
    ),
    awful.key({Modkey}, "s", function ()
            local arg
            if IS_PICOM_DIM then arg = "0" else arg = "0.5" end
            IS_PICOM_DIM = not IS_PICOM_DIM
            awful.spawn.with_shell(ScriptsPath.."/set_picom inactive-dim "..arg)
        end,
        {description = dsep.."Set Picom Inactive Dim", group = "System"}
    ),
    awful.key({ Modkey, }, "d", function ()
        local d = Dashboard
        d.visible = not(d.visible)
        if d.visible then
            prev_mouse_coords = mouse.coords()
            mouse.coords({ x = d.x + d.width/2, y = d.y + d.height/2 })
        else mouse.coords(prev_mouse_coords) end
    end,
        {description = "Show Dashboard", group = "Tag"}
    ),

    ---- Screen OCR
    awful.key({ Modkey, }, "F1",
        function () awful.spawn.with_shell(ScriptsPath.."/screenshot") end,
        {description = dsep.."Screenshot", group = "Applications"}
    ),
    awful.key({ Modkey, "Shift"}, "F1",
        function () awful.spawn.with_shell(ScriptsPath.."/screenshot --ocr") end,
        {description = dsep.."Image To Text (OCR)", group = "Applications"}
    )

)


keymapping.client = gears.table.join(
    -- Client Manipulation
    awful.key({ Modkey, }, "q", function (c) c:kill() end,
        {description = dsep.."Close Window", group = "Client"}
    ),
    awful.key({ Modkey, }, "f", function(c)
        c.floating = not c.floating

        if c.floating then
            local scr = awful.screen.focused()
            c.width  = scr.workarea.width / 2
            c.height = scr.workarea.height / 2
            awful.placement.centered(c)
        end
    end,
        {description = dsep.."Toggle Floating", group = "Client"}
    ),

    awful.key({ Modkey, "Shift"}, "p", function(c)
        local scr  = awful.screen.focused()
        local t    = scr.selected_tag
        local ntag = commons.create_tag(scr, true)
        ntag:clients(t:clients())
        ntag.master_width_factor = t.master_width_factor
        ntag:view_only()
        awful.screen.focus(t.screen)
        t:delete()
    end,
        {description = dsep.."Make First Tag", group = "Client"}
    ),

    -- awful.key({ Modkey, }, "s", function(c) toggle_sticky(c) end,
    --     {description = dsep.."Toggle Sticky", group = "Client"}
    -- ),

    awful.key({ Modkey, "Shift" }, "b", function (c)
            commons.move_to_bkg(c)
        end,
        {description = dsep.."Move To Bkg. Tag", group = "Client"}
    ),

    awful.key({ Modkey, "Shift" }, "e", function (c)
            local prevt = c.first_tag
            if #prevt:clients() == 1 then return end

            local t = commons.create_tag()
            c:move_to_tag(t)
            -- prevt.name = commons.icons['default']
            t:view_only()
            awful.screen.focus(t.screen)
        end,
        {description = dsep.."Move To New Tag", group = "Client"}
    ),

    awful.key({ Modkey, "Shift" }, "m", function (c)
            awful.spawn.easy_async("win_code.sh",
            function (out)
                for _, c2 in ipairs(client.get()) do
                    if c2.window == tonumber(out) then
                        t = c2.first_tag
                        c:move_to_tag(t)
                        commons.remove_empty_tag(prevtag)
                        t:view_only()
                        awful.screen.focus(t.screen)
                        return
                    end
                end
            end)
        end,
        {description = dsep.."Move Next To Client", group = "Client"}
    ),

    awful.key({ Modkey, }, "n", function (c)
            awful.client.focus.byidx(1, c)
        end,
        {description = dsep.."Focus Next Window", group = "Client"}
    ),
    awful.key({ Modkey, "Shift"}, "n", function (c)
            awful.client.focus.byidx(-1, c)
        end,
        {description = dsep.."Focus Prev. Window", group = "Client"}
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

            if tag ~= prevtag then commons.remove_empty_tag(prevtag) end
            awful.screen.focus(tag.screen)
        end,
        {description = dsep.."Show Tag N.", group = "Tag"})
    )

    keymapping.client = gears.table.join(keymapping.client,
        -- Move client to tag.
        awful.key({ Modkey, "Shift" }, "#" .. i + 9,
        function (c)
            local prevtag = c.first_tag
            local tag = create_find_tag(i)
            -- prevtag.name = commons.icons["default"]
            c:move_to_tag(tag)
            commons.remove_empty_tag(prevtag)
            tag:view_only()
            awful.screen.focus(tag.screen)
        end,
        {description = dsep.."Move To Tag N.", group = "Tag"})
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
