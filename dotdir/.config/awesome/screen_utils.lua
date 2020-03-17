local commons = require('commons')
local pkg_fn = {}


function printtb (t)
    local msg = ""
    for k in pairs(t) do
        msg = msg..tostring(t[k]).."\n"
    end
    naughty.notify({
        title = "debug",
        text = msg
    })
end

local systray = wibox.widget.systray()
systray:set_horizontal(false)

-- Widgets
local taglist_template = {
    widget = wibox.container.margin,
    margins = dpi(5),
    {
        widget = wibox.container.background,
        shape  = gears.shape.circle,
        shape_clip = true,
        {
            widget = wibox.container.background,
            id = "background_role",
            {
                widget = wibox.container.margin,
                margins = dpi(8),
                {
                    id     = 'text_role',
                    widget = wibox.widget.textbox,
                    align  = 'center',
                }
            }
        }
    }
}

local taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

function pkg_fn.set_wallpaper(s, wp)
    if not wp then wp = beautiful.wallpaper end
    if not wp then return end
    gears.wallpaper.maximized(wp, s)
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


local function round_widget (cr, w, h, invert)
    gears.shape.rounded_rect(cr, w, h, 30)
    -- if w > h then
    --     if not invert then gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 30)
    --     else gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 30) end
    -- else
    --     if not invert then gears.shape.partially_rounded_rect(cr, w, h, false, false, true, true, 30)
    --     else gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 30) end
    -- end
end

local function create_clock_widget(horizontal)
    local clock, clock_inner, clock_text, clock_lower, clock_upper

    if horizontal then
        clock_text = wibox.layout.fixed.horizontal()
        clock_upper = wibox.widget.textclock(" %H : %M")
        clock_upper.font = "Noto Sans 14"
        clock_upper.forced_width = nil
        clock_lower = wibox.widget.textclock("%d %b")
        clock_lower.font = "Noto Sans 8"
    else
        clock_text = wibox.layout.fixed.vertical()
        clock_upper = wibox.widget.textclock("%H\n%M")
        clock_lower = wibox.widget.textclock("%d\n%b")
    end

    clock_text.spacing_widget = {
        align = 'center',
        font = 'Noto Sans 12',
        widget = wibox.widget.textbox("•"),
    }
    clock_text.spacing = dpi(20)
    clock_lower.align = 'center'
    clock_upper.align = 'center'

    clock_text:add(clock_upper)
    clock_text:add(clock_lower)

    clock_inner = wibox.container.margin(clock_text)
    clock = wibox.container.background(clock_inner)

    if horizontal then
        clock_inner.left   = dpi(12)
        clock_inner.right  = dpi(15)
    else
        clock_inner.top    = dpi(12)
        clock_inner.bottom = dpi(15)
    end

    clock:set_shape(function (cr, w, h) round_widget(cr, w, h) end)
    clock.bg = beautiful.bg_focus

    return clock
end

function pkg_fn.add_sidebar(s)
    local w, h, horizontal_bar
    w = s.geometry.width
    h = s.geometry.height
    horizontal_bar = not(w > h)

    local fixed, align
    local barpos
    if horizontal_bar then
        fixed = wibox.layout.fixed.horizontal
        align = wibox.layout.align.horizontal
        barpos = 'bottom'
    else
        fixed = wibox.layout.fixed.vertical
        align = wibox.layout.align.vertical
        barpos = 'left'
    end

    -- Each screen has its own tag table.
    commons.create_tag(s):view_only()

    -- Create a taglist widget
    s.tagscol = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
        layout  = fixed,
        widget_template = taglist_template
    }


    local keyboard = wibox.container.place()
    keyboard.widget = awful.widget.keyboardlayout()

    local layoutbox = awful.widget.layoutbox(s)


    local statusbar = align()

    local statlower, others_margin, others_bkg, others, systray_margin

    others = fixed(keyboard, layoutbox)
    others.spacing = beautiful.systray_icon_spacing

    others_margin = wibox.container.margin(others)
    others_margin.margins = dpi(12)
    apply_margin(others_margin, 25, horizontal_bar)
    others_bkg = wibox.container.background(others_margin)
    others_bkg.bg = beautiful.bg_focus
    others_bkg:set_shape(function (cr, w, h) round_widget(cr, w, h, true) end)

    systray_margin = wibox.container.margin(systray)
    systray_margin.margins = dpi(10)

    statlower = fixed(systray_margin, others_bkg)


    local statcenter = wibox.container.place(s.tagscol)
    if horizontal_bar then
        statcenter.halign = 'center'
        statcenter.content_fill_vertical = true
    else
        statcenter.valign = 'center'
        statcenter.content_fill_horizontal = true
    end

    statusbar.first = create_clock_widget(horizontal_bar)
    statusbar.second = statcenter
    statusbar.third = statlower

    local bardata = {
        position = barpos,
        screen = s,
        widget = statusbar
    }

    if horizontal_bar then bardata.height = beautiful.wibar_width
    else bardata.width = beautiful.wibar_width end

    -- Create the wibox
    s.statusbar = awful.wibar(bardata)

end

return pkg_fn
