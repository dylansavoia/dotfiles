import re
reg = re.compile("#[A-Fa-f0-9]{6,8}")

with open("/home/dylansavoia/.Xresources") as f:
    colors = reg.findall(f.read())

bkg = colors[0]
bkg_alt = colors[1]
accent = colors[4]
accent_alt = colors[5]

config.unbind("m")
config.unbind("`")
config.unbind("go")

config.bind("gy", "open https://youtube.com")
config.bind("gs", "open https://dylansavoia.sytes.net/Main")
    
config.bind("<Ctrl-P>", "enter-mode passthrough")
config.bind("<Ctrl-P>", "leave-mode", mode="passthrough")
config.bind("b", "set-cmd-text -s :buffer")
config.bind("gof", "spawn firefox {url}")
config.bind("gn", "tab-give")

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

c.hints.auto_follow = "full-match"
c.hints.mode = "number"
c.keyhint.blacklist = ["*"]

c.tabs.min_width = -1
c.tabs.max_width = 250
c.tabs.padding = {'top': 5, 'bottom': 5, 'right': 7, 'left': 7}
c.tabs.last_close = "startpage"
c.tabs.title.format = "{title}"
c.tabs.indicator.width = 0

c.completion.height = "35%"
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 10

c.statusbar.widgets = ["keypress", "progress", "url", "scroll"]
c.content.pdfjs = True

c.prompt.radius = 1

c.colors.tabs.even.bg = bkg
c.colors.tabs.bar.bg = bkg
c.colors.tabs.odd.bg = bkg
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.selected.odd.bg = accent

c.colors.completion.odd.bg = bkg
c.colors.completion.even.bg = bkg
c.colors.completion.category.bg = accent
c.colors.completion.category.border.top = accent
c.colors.completion.category.border.bottom = accent
c.colors.completion.item.selected.bg = bkg_alt
c.colors.completion.item.selected.fg = "white"
c.colors.completion.item.selected.border.bottom = bkg_alt
c.colors.completion.item.selected.border.top = bkg_alt
c.colors.completion.match.fg = accent_alt

c.colors.downloads.start.bg = bkg
c.colors.downloads.stop.bg = bkg
c.colors.downloads.error.bg = bkg
c.colors.downloads.system.bg = "none"
c.colors.downloads.start.fg = "#ffffff"
c.colors.downloads.stop.fg = accent_alt
c.colors.downloads.error.fg = "#d799aa"

c.colors.prompts.border = "0px"
c.colors.downloads.bar.bg = bkg

c.colors.statusbar.normal.bg = bkg
c.colors.statusbar.insert.bg = accent
c.colors.statusbar.progress.bg = accent
c.colors.statusbar.url.success.https.fg = accent_alt

c.colors.hints.fg = accent_alt
c.colors.hints.bg = bkg
c.colors.hints.match.fg = accent
c.hints.border = "1px solid " + accent_alt

c.fonts.tabs = "13px SFNS Display"
c.fonts.statusbar = "13px SFNS Display"
c.fonts.prompts = "14px SFNS Display"
c.fonts.downloads = "14px SFNS Display"
c.fonts.keyhint = "14px SFNS Display"
c.fonts.hints = "bold 14px SFNS Display Thin"
c.fonts.completion.category = "14px SFNS Display"
c.fonts.completion.entry = "14px SFNS Display"

c.scrolling.smooth = True

c.editor.command = ["st", "-e",  "nvim", "{file}", "-c", "normal {line}G{column0}l"]
