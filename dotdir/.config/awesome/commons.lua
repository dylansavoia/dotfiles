local pkg_fn = {}

pkg_fn.icons = {
    ["xterm-256color"] = "",
    ["org.pwmt.zathura"] = "",
    emacs = "",
    qutebrowser = "",
    empty = "",
    default = ""
}

function pkg_fn.create_tag(scr, front)
    local default_layout, min_layout
    local tag, min

    w = scr.geometry.width
    h = scr.geometry.height
    is_landscape = w > h

    min_layout = {
        awful.layout.suit.max,
    }

    if is_landscape then default_layout = awful.layout.suit.tile
    else default_layout = awful.layout.suit.tile.bottom end

    local tag_prop = {
        layout = default_layout,
        layouts = min_layout,
        screen = scr,
    }

    if front then tag_prop.index = 1 end
    tag = awful.tag.add(pkg_fn.icons.empty, tag_prop)

    return tag
end


return pkg_fn
