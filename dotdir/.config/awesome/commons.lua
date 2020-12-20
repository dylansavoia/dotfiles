local pkg_fn = {}

pkg_fn.icons = {
    ["xterm-256color"] = "",
    Zathura = "",
    nvim = "",
    vifm = "",
    qutebrowser = "",
    firefox = "",
    empty = "",
    default = "",
    bkg = ""
}

function pkg_fn.create_tag(scr, front)
    local default_layout, min_layout
    local tag, min

    if not scr then scr = awful.screen.focused() end

    w = scr.geometry.width
    h = scr.geometry.height
    is_landscape = w > h

    min_layout = {
        awful.layout.suit.max,
    }

    if is_landscape then
        default_layout = awful.layout.suit.tile.right
        table.insert(min_layout, awful.layout.suit.fair)
    else
        default_layout = awful.layout.suit.tile.bottom
        table.insert(min_layout, awful.layout.suit.fair.horizontal)
    end

    local tag_prop = {
        layout = default_layout,
        layouts = min_layout,
        screen = scr,
        master_width_factor = 0.70,
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

return pkg_fn
