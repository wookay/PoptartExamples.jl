# [deps]
# Poptart v0.3.1
# Revise
# Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop
using Colors: RGBA

window1 = Window(title="LinePlot")
app = Application(windows=[window1], title="App")

using Random
Random.seed!()

values = rand(10)
lineplot1 = LinePlot(label="lineplot1", values=values, scale=(min=0, max=1), frame=(width=150, height=80))
push!(window1.items, lineplot1)

values = rand(0:100, 10)
lineplot2 = LinePlot(label="lineplot2", values=values, scale=(min=0, max=100), color=RGBA(0.5, 0.5, 0.8, 1), frame=(width=150, height=80))
push!(window1.items, lineplot2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(app.closenotify)
