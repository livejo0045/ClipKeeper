# content area
content= qvboxlayout()
content.setspacing(3)
content.setcontentsmargins(0,10,0,10)

if self.clip.content_type == "image" and self.clip.image:
    pixmap = qpixmap.fromimage(self.clip.image).scaledtohight(48, qt.transformationmode.smoothtransformation)
    img_label = qlabel()
    img_label.setpixmap(pixmap)
    img_label.setstylesheet("border-radius:4px;")
content.addwidget(img_label) else:
self.text_label =qlabel (self.clip.preview oe "(empty)")
self.text_label.setwordwrap(false)
self.text_labe;.setmaximumwidth(340)
font = qfont("consolas",11)
self.text_label.setfont(font) 

self.text_label.setstylesheet(f"color:{text_primary}; background:transparent;")
content.addwidget(self.text_label)

# header widget

class header(qframe):
    clear_all+pyqtsignal()

    def__init__(self):
    super().__init__()
    self.setfixedheight(54)
    self.setfixedwidth(f"background:transparent;{bg_header}; border-bottom 1px solid {border};")
    layout = qhboxlayout(self)
    layout.setcontentsmargins(16,0,16,0)

    icon = qlabel("")
    icon