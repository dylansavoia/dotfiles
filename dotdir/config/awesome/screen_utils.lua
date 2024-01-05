local commons = require('commons')
local pkg_fn = {}

function pkg_fn.set_wallpaper(s, wp)
    if not wp then wp = beautiful.wallpaper end
    if not wp then return end
    gears.wallpaper.maximized(wp, s)
    -- gears.wallpaper.set('#000000', s)
end

local function apply_margin(w, size, orientation)
    if orientation then
        w.left = size
        w.right = size
    else
        w.top = size
        w.bottom = size
    end
end


function pkg_fn.add_sidebar(s)
    local fixed, barpos
    if s.is_horizontal then
        fixed = wibox.layout.fixed.vertical
        barpos = 'left'
    else
        fixed = wibox.layout.fixed.horizontal
        barpos = 'bottom'
    end

    local tl_bkg = {
        id     = 'background_role',
        widget = wibox.widget.background,
    }

    if s.is_horizontal then
        tl_bkg.forced_height = dpi(75)
    else tl_bkg.forced_width = dpi(75) end

    local taglist_template = {
        widget = wibox.container.margin,
        tl_bkg
    }

    if s.is_horizontal then
        taglist_template.bottom = dpi(5)
    else taglist_template.right = dpi(5) end

    -- Create a taglist widget
    s.tagscol = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        layout  = fixed,
        widget_template = taglist_template
    }

    local bardata = {
        position = barpos,
        screen = s,
        widget = s.tagscol,
    }


    if s.is_horizontal then bardata.width = beautiful.wibar_width
    else bardata.height = beautiful.wibar_width end

    s.statusbar = awful.wibar(bardata)
end

return pkg_fn
