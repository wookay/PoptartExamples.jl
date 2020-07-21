# [deps]
# Poptart v0.3
# Revise
# Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop
using Colors # RGBA

frame = (width=500, height=600)
window1 = Window(title="MultiLinePlot", frame=frame)
app = Application(windows=[window1], title="App", frame=frame)

lineplots = LinePlot[]
for (values, label, color) in [
        (rand(10), "lineplot1", RGBA(0.5, 0.5, 0.8, 1)),
        (rand(10), "lineplot2", RGBA(0.2, 0.4, 0.8, 1)),
    ]
    push!(lineplots, LinePlot(values=values, label=label, color=color))
end
multi1 = MultiLinePlot(items=lineplots, label="multi1")
push!(window1.items, multi1)

lineplots = LinePlot[]
for (values, label, color) in [
        (rand(0:100, 10), "lineplot1", RGBA(0.5, 0.5, 0.8, 1)),
        (rand(0:100, 10), "lineplot2", RGBA(0.2, 0.4, 0.8, 1)),
        (rand(0:100, 10), "lineplot3", RGBA(0.3, 0.5, 0.3, 1)),
    ]
    push!(lineplots, LinePlot(values=values, label=label, color=color))
end
multi2 = MultiLinePlot(items=lineplots, label="multi2", scale=(min=0, max=100))
push!(window1.items, multi2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
