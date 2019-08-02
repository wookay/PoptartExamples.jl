# [deps]
# TestImages, Poptart

using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Canvas
using Poptart.Drawings # ImageBox
using TestImages: testimage

frame = frame=(width=500, height=550)
canvas = Canvas()
window1 = Windows.Window(items=[canvas], title="ImageBox", frame=frame)
closenotify = Condition()
Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

img = testimage("cameraman.tif")
box1 = ImageBox(image=img)
put!(canvas, box1)

Base.JLOptions().isinteractive==0 && wait(closenotify)
