# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # LinePlot
using Colors: RGBA

window1 = Window(title="LinePlot")
closenotify = Condition()
app = Application(windows=[window1], title="App", closenotify=closenotify)

using Random
Random.seed!()

values = rand(10)
lineplot1 = LinePlot(label="lineplot1", values=values, scale=(min=0, max=1), frame=(width=150, height=80))
put!(window1, lineplot1)

values = rand(0:100, 10)
lineplot2 = LinePlot(label="lineplot2", values=values, scale=(min=0, max=100), color=RGBA(0.5, 0.5, 0.8, 1), frame=(width=150, height=80))
put!(window1, lineplot2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
