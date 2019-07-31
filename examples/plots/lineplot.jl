using Test
using Poptart.Desktop # Application Window put!
using Poptart.Controls # LinePlot
using Colors: RGBA

frame = (width=200, height=200)
window1 = Window(title="A", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

using Random
Random.seed!()

values = rand(10)
plot3 = LinePlot(label="LinePlot", values=values, scale=(min=0, max=1), frame=(width=150, height=80))
put!(window1, plot3)

Base.JLOptions().isinteractive==0 && wait(closenotify)
