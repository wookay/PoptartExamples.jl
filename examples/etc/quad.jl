using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Canvas
using Poptart.Drawings # Line Rect Circle Triangle Arc Pie Curve Polyline Polygon stroke fill
using Colors: RGBA

canvas = Canvas()
window1 = Windows.Window(items=[canvas], title="Drawings", frame=(x=0, y=0, width=550, height=400))
closenotify = Condition()
Application(windows=[window1], title="App", frame=(width=550, height=400), closenotify=closenotify)

strokeColor = RGBA(0,0.7,0,1)
fillColor   = RGBA(0.1, 0.7,0.8,0.9)

quad1 = Quad(points=[(320, 75+80), (300,116+80), (340,116+120), (380, 116+80)], thickness=7.5, color=strokeColor)
quad2 = Quad(points=[(320, 75), (300,116), (340,116+40), (380, 116)], color=fillColor)

put!(canvas,
    stroke(quad1), fill(quad2)
)

Base.JLOptions().isinteractive==0 && wait(closenotify)
