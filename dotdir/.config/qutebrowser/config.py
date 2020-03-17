bkg         = "{{bkg}}"
bkg_alt     = "{{bkg_alt}}"
fg          = "{{fg}}"
fg_alt      = "{{fg_alt}}"
accent1     = "{{accent1}}"
accent1_fg = "{{accent1_fg}}"
accent2     = "{{accent2}}"
accent2_fg = "{{accent2_fg}}"
accent3     = "{{accent3}}"
accent3_fg = "{{accent3_fg}}"
urgent      = "{{urgent}}"
warning     = "{{warning}}"
warning_fg =  "{{warning_fg}}"
fontbase    = "{{font}}"
font        = "18px " + fontbase
monospace   = "{{monospace}}"

###############################################################################
#                                   Bindings                                  #
###############################################################################
config.unbind("m")
config.unbind("`")
config.unbind("go")

config.bind("gy", "open https://youtube.com")
config.bind("gs", "open https://dylansavoia.sytes.net/Main")
config.bind("gog", "open https://google.com")

config.bind("<Ctrl-P>", "completion-item-focus prev", mode='command')
config.bind("<Ctrl-N>", "completion-item-focus next", mode='command')
config.bind("<Ctrl-P>", "enter-mode passthrough")
config.bind("<Ctrl-P>", "leave-mode", mode="passthrough")
config.bind("b", "set-cmd-text -s :buffer")
config.bind("gof", "spawn firefox {url}")
config.bind("gn", "set-cmd-text -s :tab-give")

config.bind(";d", "hint all download")
config.bind(";i", "hint inputs")

chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
for ch in chars:
    config.bind("m" + ch, "set-mark " + ch)
    config.bind("'" + ch, "jump-mark " + ch)

config.unbind("gd")
config.bind("gdo", "download-open zathura")
config.bind("gdc", "download-clear")
config.bind("gdC", "download-cancel")
config.bind("gdd", "download-delete")
config.bind("to", "tab-only")
config.bind("ZZ", "close")

###############################################################################
#                                     MISC                                    #
###############################################################################
c.hints.auto_follow = "full-match"
c.hints.mode = "number"
c.keyhint.blacklist = ["*"]
c.scrolling.smooth = True
c.editor.command = ["emacsclient", "-c", "+{line}:{column0}", "{file}"]
c.zoom.default = 125

c.tabs.show = "never"
c.tabs.last_close = "startpage"

c.statusbar.widgets = ["keypress", "progress", "scroll", "tabs"]
c.content.pdfjs = True
c.content.notifications = False

c.prompt.radius = 1

c.completion.height = "20%"
c.completion.show = "always"
c.completion.shrink = True
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 7
c.input.insert_mode.leave_on_load = False

c.downloads.position = "bottom"
c.downloads.location.prompt = False
c.downloads.location.directory = "{{download_dir}}"
c.downloads.remove_finished = 5000

###############################################################################
#                                    Colors                                   #
###############################################################################
c.colors.completion.scrollbar.bg = bkg_alt
c.colors.completion.scrollbar.fg = accent1

c.colors.tabs.even.bg = bkg
c.colors.tabs.bar.bg = bkg
c.colors.tabs.odd.bg = bkg
c.colors.tabs.selected.even.bg = accent1
c.colors.tabs.selected.odd.bg = accent1

c.colors.completion.fg = bkg_alt
c.colors.completion.odd.bg = bkg
c.colors.completion.even.bg = bkg
c.colors.completion.category.bg = accent1
c.colors.completion.category.border.top = accent1
c.colors.completion.item.selected.fg = fg_alt
c.colors.completion.item.selected.bg = bkg
c.colors.completion.item.selected.border.bottom = accent1_fg
c.colors.completion.item.selected.border.top = accent1_fg
c.colors.completion.item.selected.match.fg = accent2_fg
c.colors.completion.match.fg = accent1_fg

c.colors.downloads.start.bg = bkg
c.colors.downloads.stop.bg = bkg
c.colors.downloads.error.bg = bkg
c.colors.downloads.system.bg = "none"
c.colors.downloads.start.fg = fg_alt
c.colors.downloads.stop.fg = accent1_fg
c.colors.downloads.error.fg = urgent

c.colors.prompts.border = "0px"
c.colors.downloads.bar.bg = bkg
c.colors.messages.error.bg = urgent
c.colors.messages.error.border = urgent
c.colors.messages.warning.bg = warning
c.colors.messages.warning.border = warning

c.colors.statusbar.normal.bg = bkg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bkg
c.colors.statusbar.insert.bg = accent1
c.colors.statusbar.progress.bg = accent1
c.colors.statusbar.url.success.https.fg = accent1_fg
c.colors.statusbar.url.success.http.fg = accent1_fg
c.colors.statusbar.url.warn.fg = warning_fg
c.colors.statusbar.url.fg = accent1

c.colors.prompts.bg = bkg
c.colors.prompts.fg = fg
c.colors.messages.info.border = accent1
c.colors.statusbar.passthrough.bg = accent2
c.colors.statusbar.caret.bg = accent3

c.colors.hints.fg = accent1_fg
c.colors.hints.bg = bkg
c.colors.hints.match.fg = accent1
c.hints.border = "1px solid " + accent1

###############################################################################
#                                    Fonts                                    #
###############################################################################
c.fonts.tabs = font
c.fonts.statusbar = font
c.fonts.prompts = font
c.fonts.downloads = font
c.fonts.keyhint = font
c.fonts.hints = "bold " + font
c.fonts.completion.category = font
c.fonts.completion.entry = font
c.fonts.web.family.sans_serif = fontbase
c.fonts.web.family.serif = fontbase
c.fonts.web.family.standard = fontbase
c.fonts.web.family.fixed = monospace
