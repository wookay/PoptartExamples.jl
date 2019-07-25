# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # BarPlot

frame = (width=500, height=600)
window1 = Window(title="BarPlot", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

values = rand(11)
barplot1 = BarPlot(values=values, captions=string.(1:11), label="rand(11)", frame=(width=300, height=120))
put!(window1, barplot1)

values = rand(0:100, 11)
barplot2 = BarPlot(values=values, scale=(min_x=0, max_x=100), captions=string.(1:11), label="rand(0:100, 11)", frame=(width=300, height=120))
put!(window1, barplot2)

values = -1.0:0.2:1.0
barplot3 = BarPlot(values=values, captions=string.(1:11), label="-1.0:0.2:1.0", frame=(width=300, height=120))
put!(window1, barplot3)

values = -100:20:100
barplot4 = BarPlot(values=values, scale=(min_x=-100, max_x=100), captions=string.(1:11), label="-100:20:100", frame=(width=300, height=120))
put!(window1, barplot4)

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
