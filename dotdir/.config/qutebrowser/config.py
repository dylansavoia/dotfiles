import re
reg = re.compile("#[A-Fa-f0-9]{6,8}")

with open("/home/dylansavoia/.Xresources") as f:
    colors = reg.findall(f.read())

bkg = colors[0]
bkg_alt = colors[1]
fg  = colors[14]
fg_alt = colors[15]
accent = colors[8]
accent_alt = colors[9]

config.unbind("m")
config.unbind("`")
config.unbind("go")

config.bind("gy", "open https://youtube.com")
config.bind("gs", "open https://dylansavoia.sytes.net/Main")
config.bind("gog", "open https://google.com")
    
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

c.hints.auto_follow = "full-match"
c.hints.mode = "number"
c.keyhint.blacklist = ["*"]

c.tabs.min_width = -1
c.tabs.max_width = 250
c.tabs.padding = {'top': 5, 'bottom': 5, 'right': 7, 'left': 7}
c.tabs.last_close = "startpage"
c.tabs.title.format = "{current_title}"
c.tabs.indicator.width = 0

c.statusbar.widgets = ["keypress", "progress", "url", "scroll"]
c.content.pdfjs = True

c.prompt.radius = 1

c.colors.tabs.even.bg = bkg
c.colors.tabs.bar.bg = bkg
c.colors.tabs.odd.bg = bkg
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.selected.odd.bg = accent

c.completion.height = "30%"
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 7

c.colors.completion.scrollbar.bg = bkg_alt
c.colors.completion.scrollbar.fg = accent

c.colors.completion.fg = bkg_alt
c.colors.completion.odd.bg = bkg
c.colors.completion.even.bg = bkg
c.colors.completion.category.bg = accent
c.colors.completion.category.border.top = accent
c.colors.completion.item.selected.fg = fg_alt
c.colors.completion.item.selected.bg = bkg
c.colors.completion.item.selected.border.bottom = accent_alt
c.colors.completion.item.selected.border.top = accent_alt
c.colors.completion.item.selected.match.fg = colors[11]
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
c.colors.statusbar.url.success.http.fg = accent_alt
c.colors.statusbar.url.warn.fg = colors[7]
c.colors.statusbar.url.fg = accent

c.colors.prompts.bg = bkg
c.colors.prompts.fg = fg
# c.colors.prompts.border = "1px solid " + accent_alt
c.colors.messages.info.border = accent
c.colors.statusbar.passthrough.bg = colors[8]
c.colors.statusbar.caret.bg = colors[10]

c.colors.hints.fg = accent_alt
c.colors.hints.bg = bkg
c.colors.hints.match.fg = accent
c.hints.border = "1px solid " + accent

c.fonts.tabs = "13px Hack"
c.fonts.statusbar = "13px Hack"
c.fonts.prompts = "14px Hack"
c.fonts.downloads = "14px Hack"
c.fonts.keyhint = "14px Hack"
c.fonts.hints = "bold 14px Hack"
c.fonts.completion.category = "14px Hack"
c.fonts.completion.entry = "14px Hack"

c.scrolling.smooth = True

c.editor.command = ["xst", "-e",  "nvim", "{file}", "-c", "normal {line}G{column0}l"]
