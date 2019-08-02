# [deps]
# CatmullRom.jl
#     https://github.com/JeffreySarnoff/CatmullRom.jl

using Poptart.Desktop # Application Windows put!
using Poptart.Controls # Canvas
using Poptart.Drawings # Polyline stroke
using Colors: RGBA
using CatmullRom # catmullrom

canvas = Canvas()
window1 = Windows.Window(items=[canvas], title="CatmullRom", frame=(x=0, y=0, width=550, height=400))
closenotify = Condition()
Application(windows=[window1], title="App", frame=(width=550, height=400), closenotify=closenotify)

strokeColor = RGBA(0, 0.7, 0, 1)
romColor    = RGBA(0.8, 0.8, 0.2, 1)

fx(t) = cospi(t)
fy(t) = sinpi(t)
xs = [fx(t) for t=range(0.0, stop=2.0, length=17)]
ys = [fy(t) for t=range(0.0, stop=2.0, length=17)]
points = collect(zip(xs, ys))

cxs, cys = catmullrom(points, 16)
rom_points = collect(zip(cxs, cys))

transform(point) = translate(scale(point, 200), 100)

polyline1 = Polyline(points=transform.(points), color=strokeColor, thickness=9)
put!(canvas, stroke(polyline1))

polyline2 = Polyline(points=transform.(rom_points), color=romColor, thickness=9)
put!(canvas, stroke(polyline2))

Base.JLOptions().isinteractive==0 && wait(closenotify)
