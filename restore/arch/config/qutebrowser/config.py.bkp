config.load_autoconfig()
###############################################################################
#                                   Variables                                 #
###############################################################################
bkg          = "{{bkg}}"
bkg_alt      = "{{bkg_alt}}"
fg           = "{{fg}}"
fg_alt       = "{{fg_alt}}"
accent1      = "{{accent1}}"
accent1_fg   = "{{accent1_fg}}"
accent2      = "{{accent2}}"
accent2_fg   = "{{accent2_fg}}"
accent3      = "{{accent3}}"
accent3_fg   = "{{accent3_fg}}"
urgent       = "{{urgent}}"
urgent_fg    = "{{urgent_fg}}"
warning      = "{{warning}}"
warning_fg   = "{{warning_fg}}"
fontbase     = "{{font}}"
smallfont    = "16px " + fontbase
font         = "20px " + fontbase
monospace    = "{{monospace}}"
download_dir = "{{download_dir}}"
terminal     = "alacritty"

###############################################################################
#                                   Bindings                                  #
###############################################################################
config.unbind("d")
config.unbind("D")
config.unbind("go")
config.unbind("<shift-esc>", mode='passthrough')

config.bind("gy", "open https://youtube.com")
config.bind("gs", "open https://dylansavoia.sytes.net/Main/Apps/TextEdit/index.php?f=%2FHome")
config.bind("gS", "open https://dylansavoia.sytes.net/Main")
config.bind("gog", "open https://google.com")
config.bind("gof", "spawn --detach firefox {url}")

config.bind("<Ctrl-P>", "completion-item-focus prev", mode='command')
config.bind("<Ctrl-N>", "completion-item-focus next", mode='command')
config.bind("<Ctrl-P>", "mode-enter passthrough")
config.bind("<Ctrl-P>", "mode-leave", mode="passthrough")
config.bind("<Ctrl-P>", "fake-key <Up>",   mode="insert")
config.bind("<Ctrl-N>", "fake-key <Down>", mode="insert")
config.bind("<esc>", "fake-key <esc>")
config.bind("gn", "set-cmd-text -s :tab-give")

# Buffers
config.bind("<space>,", "set-cmd-text -s :buffer")
config.bind("<space>bb", "set-cmd-text -s :buffer")

# Downloads
config.bind("<space>dO", "spawn launcher 0 " + download_dir)
config.bind("<space>do", "download-open launcher 0 ")
config.bind("<space>dc", "download-cancel")
config.bind("<space>dd", "download-delete")

# Tabs
config.bind("<space>tw", f"config-cycle -t tabs.tabs_are_windows true false;; config-cycle -t colors.statusbar.normal.bg {bkg} {bkg_alt}")

# Config
config.bind("<space>ce", "config-edit")
config.bind("<space>cs", "config-source")
config.bind("<space>h", "help")

# Misc
config.bind("<Ctrl-E>", "click-element id show_md;; cmd-later 100 click-element id text", mode="normal")
config.bind("<Ctrl-L>",  "spawn --userscript qute-pass", mode="insert")
config.bind(";d", "hint all download")
config.bind(";i", "hint inputs")
config.bind(";a", "hint")
config.bind("to", "tab-only")
config.bind("ZZ", "close")
config.bind("f", "hint links")
# config.bind("<Ctrl-R>", "config-cycle -t colors.webpage.darkmode.enabled false true;; restart" )

###############################################################################
#                                     MISC                                    #
###############################################################################
c.url.searchengines = {
    "DEFAULT": "https://www.ecosia.org/search?q={}",
    "you": "https://www.youtube.com/results?search_query={}",
    "gog": "https://www.google.com/search?q={}"
}
c.url.start_pages  = \
c.url.default_page = "https://www.ecosia.org/"

c.editor.command = [terminal, "-e", "nvim", "-f", "{file}", "-c", "normal {line}G{column0}l"]
c.hints.auto_follow = "full-match"
c.hints.mode = "number"
c.keyhint.blacklist = ["*"]
c.new_instance_open_target = 'window'
c.scrolling.bar = 'never'
c.scrolling.smooth = True
c.tabs.tabs_are_windows = True
c.window.title_format = '{current_title} - QB'
c.zoom.default = {{qbZoom}}

c.tabs.show = "never"
c.tabs.last_close = "close"

c.statusbar.widgets = []
c.statusbar.show = 'always'
c.content.pdfjs = False
c.content.notifications.enabled = True
c.content.notifications.presenter = 'libnotify'
c.content.blocking.method = 'adblock'

c.prompt.radius = 1

c.completion.height = "25%"
c.completion.show = "always"
c.completion.shrink = True
c.completion.scrollbar.width = 0
c.input.insert_mode.leave_on_load = False

c.downloads.position = "bottom"
c.downloads.location.prompt = False
c.downloads.location.directory = download_dir
c.downloads.remove_finished = 10000

c.fileselect.handler = "external"
c.fileselect.folder.command         = ['alacritty', '--class', 'vifm,vifm', '-e', 'vifm', '--choose-dir', '{}']
c.fileselect.single_file.command    = ['alacritty', '--class', 'vifm,vifm', '-e', 'vifm', '--choose-files', '{}']
c.fileselect.multiple_files.command = ['alacritty', '--class', 'vifm,vifm', '-e', 'vifm', '--choose-files', '{}']
###############################################################################
#                                    Colors                                   #
###############################################################################
c.colors.tabs.even.bg = bkg
c.colors.tabs.bar.bg = bkg
c.colors.tabs.odd.bg = bkg
c.colors.tabs.selected.even.bg = accent1
c.colors.tabs.selected.odd.bg = accent1

c.colors.completion.fg = fg
c.colors.completion.odd.bg = bkg
c.colors.completion.even.bg = bkg
c.colors.completion.category.bg = accent1
c.colors.completion.category.border.top = accent1
c.colors.completion.item.selected.fg = fg_alt
c.colors.completion.item.selected.bg = bkg_alt
c.colors.completion.item.selected.border.bottom = accent1
c.colors.completion.item.selected.border.top = accent1
c.colors.completion.item.selected.match.fg = accent3_fg
c.colors.completion.match.fg = accent2_fg

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
c.colors.statusbar.normal.fg = bkg
c.colors.statusbar.insert.fg = accent1
c.colors.statusbar.insert.bg = accent1
c.colors.statusbar.passthrough.fg = accent2
c.colors.statusbar.passthrough.bg = accent2
c.colors.statusbar.caret.fg = accent3
c.colors.statusbar.caret.bg = accent3
c.colors.statusbar.command.fg = bkg
c.colors.statusbar.command.bg = bkg

c.colors.statusbar.progress.bg = accent1
c.colors.statusbar.url.fg = accent1_fg
c.colors.statusbar.url.hover.fg = accent2_fg
c.colors.statusbar.url.success.https.fg = accent1_fg
c.colors.statusbar.url.success.http.fg = accent1_fg
c.colors.statusbar.url.warn.fg = warning_fg
c.colors.statusbar.url.error.fg = urgent_fg

c.colors.contextmenu.menu.bg = bkg
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.fg = accent1_fg
c.colors.contextmenu.disabled.fg = bkg_alt

c.colors.prompts.bg = bkg
c.colors.prompts.fg = fg
c.colors.messages.info.border = accent1

c.colors.hints.fg = accent1_fg
c.colors.hints.bg = bkg
c.colors.hints.match.fg = accent1
c.hints.border = "0px solid " + accent1

c.colors.webpage.bg = bkg
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.webpage.darkmode.policy.images = 'smart'
c.colors.webpage.darkmode.threshold.background = 205
c.colors.webpage.darkmode.threshold.foreground = 150
c.content.user_stylesheets = '~/.config/qutebrowser/custom.css'

###############################################################################
#                                    Fonts                                    #
###############################################################################
c.fonts.statusbar = "2px " + fontbase
c.fonts.prompts = font
c.fonts.downloads = font
c.fonts.keyhint = font
c.fonts.hints = "bold " + font
c.fonts.completion.category = '24px Zilla Slab'
c.fonts.completion.entry = font
c.fonts.web.family.sans_serif = fontbase
c.fonts.web.family.serif = fontbase
c.fonts.web.family.standard = fontbase
c.fonts.web.family.fixed = monospace

###############################################################################
#                                   Dismissed                                 #
###############################################################################

# config.unbind("m")
# config.unbind("`")
# chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
# for ch in chars:
#     config.bind("m" + ch, "set-mark " + ch)
#     config.bind("'" + ch, "jump-mark " + ch)
