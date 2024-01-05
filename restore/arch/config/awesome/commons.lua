local pkg_fn = {}

pkg_fn.icons = {
    Zathura = "",
    nvim = "",
    vifm = "",
    qutebrowser = "",
    firefox = "",
    empty = "",
    default = "",
    bkg = ""
}

function pkg_fn.set_client_border(c)
    local titlebar, color
    -- titlebar = {position='bottom', size=dpi(5)}
    if c.sticky then color = beautiful.border_marked
    else color = beautiful.border_normal end
    -- titlebar.bg_focus = color
    c.border_color = color
    -- awful.titlebar(c, titlebar)
end

function pkg_fn.create_tag(scr, front)
    local default_layout, min_layout
    local tag, min
    local MWF

    if not scr then scr = awful.screen.focused() end
    min_layout = {}

    if scr.is_landscape then
        default_layout = awful.layout.suit.tile.right
        -- table.insert(min_layout, awful.layout.suit.fair.horizontal)
        -- table.insert(min_layout, require("vertical-layout"))
        MWF = 0.70
    else
        default_layout = awful.layout.suit.tile.bottom
        -- table.insert(min_layout, awful.layout.suit.fair)
        MWF = 0.35
    end

    local tag_prop = {
        layout = default_layout,
        layouts = min_layout,
        screen = scr,
        useless_gap = 1,
        master_width_factor = MWF,
    }

    if front then tag_prop.index = 1 end
    tag = awful.tag.add(pkg_fn.icons.empty, tag_prop)

    return tag
end

function pkg_fn.remove_empty_tag(tag)
    if not tag then
        tag = awful.screen.focused().selected_tag
        if not tag then return end
    end

    if #tag:clients() == 0 and
       #tag.screen.tags > 1
    then tag:delete() end
end

function pkg_fn.move_to_bkg(c)
    local bkg_t = awful.tag.find_by_name(nil, pkg_fn.icons.bkg)
    if not bkg_t then
        bkg_t = pkg_fn.create_tag(screen[screen.count()])
        bkg_t.name = pkg_fn.icons.bkg
        bkg_t.layout = bkg_t.layouts[2]
    end

    c:move_to_tag(bkg_t)
    local t = awful.screen.focused().selected_tag
    client.focus = t:clients()[#t:clients()]

end

function pkg_fn.unique_notif(args, n)
    if n and not n.is_expired then
        n.title = args.title or n.title
        n.message = args.message or n.message
        n.icon = args.icon or n.icon
        n.timeout = args.timeout or n.timeout
        n.width = args.width or n.width
    else
        n = args
    end
    return n
end

function pkg_fn.save_state()
    local T, C
    local is_selected

    T = {}
    C = {}
    for i, t in ipairs(root.tags()) do
        is_selected = t.selected and 1 or 0
        table.insert(T, {
            t.name,
            t.screen.index, t.gap,
            t.master_width_factor,
            is_selected
        })
    end

    for j, c in ipairs(client.get()) do
        C[c.window] = c.first_tag.index
    end

    table.save({T, C}, StateFile)
end

function pkg_fn.load_state()
    file = table.load(StateFile)
    os.remove(StateFile)

    local default_layout, min_layout
    local scr

    min_layout = {}
    T = file[1]
    C = file[2]

    for i, t in ipairs(T) do
        scr = screen[t[2]]
        if scr.is_landscape then
            default_layout = awful.layout.suit.tile.right
            table.insert(min_layout, awful.layout.suit.fair.horizontal)
        else
            default_layout = awful.layout.suit.tile.bottom
            table.insert(min_layout, awful.layout.suit.fair)
        end

        props = {
            layout = default_layout,
            layouts = min_layout,
            screen = scr,
            useless_gap = t[3],
            master_width_factor = t[4],
        }
        tag = awful.tag.add(t[1], props)
        if t[5] == 1 then tag:view_only() end
    end

    local tags = root.tags()
    for j, c in pairs(client.get()) do
        c:move_to_tag(tags[C[c.window]])
    end

    awful.screen.focus(tag.screen)
end

return pkg_fn
