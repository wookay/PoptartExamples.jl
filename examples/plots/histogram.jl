# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Histogram
using Colors: RGBA

window1 = Window(title="Histogram")
closenotify = Condition()
app = Application(windows=[window1], title="App", closenotify=closenotify)

using Random
Random.seed!()

values = rand(10)
plot1 = Histogram(values=values, label="histogram1", scale=(min=0, max=1.0), frame=(width=150, height=100))
put!(window1, plot1)

values = rand(0:100, 10)
plot2 = Histogram(values=values, label="histogram2", scale=(min=0, max=100), frame=(width=150, height=100))
put!(window1, plot2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
