# [deps]
# Poptart v0.3
# TestImages

using Poptart.Desktop
using Poptart.Drawings # ImageBox
using TestImages: testimage

frame = (width=500, height=550)
canvas = Canvas()
window1 = Window(items=[canvas], title="ImageBox", frame=frame)
app = Application(windows=[window1], title="App", frame=frame)

img = testimage("cameraman.tif")
box1 = ImageBox(image=img)
push!(canvas.items, box1)

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
