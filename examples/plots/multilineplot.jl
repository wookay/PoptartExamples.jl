# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # LinePlot MultiLinePlot
using Colors # RGBA

frame = (width=500, height=600)
window1 = Window(title="MultiLinePlot", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

lineplots = LinePlot[]
for (values, label, color) in [
        (rand(10), "lineplot1", RGBA(0.8,0.1,0.8,1)),
        (rand(10), "lineplot2", RGBA(0.2,0.2,0.8,1)),
    ]
    push!(lineplots, LinePlot(values=values, label=label, color=color))
end
multi1 = MultiLinePlot(items=lineplots, label="multi1")
put!(window1, multi1)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
