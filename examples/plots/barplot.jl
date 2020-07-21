# [deps]
# Poptart v0.3.1
# Revise
# Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop

frame = (width=500, height=600)
window1 = Window(title="BarPlot", frame=frame)
app = Application(windows=[window1], title="App", frame=frame)

values = rand(11)
barplot1 = BarPlot(values=values, captions=string.(1:11), label="rand(11)", frame=(width=300, height=120))
push!(window1.items, barplot1)

values = rand(0:100, 11)
barplot2 = BarPlot(values=values, scale=(min_x=0, max_x=100), captions=string.(1:11), label="rand(0:100, 11)", frame=(width=300, height=120))
push!(window1.items, barplot2)

values = -1.0:0.2:1.0
barplot3 = BarPlot(values=values, captions=string.(1:11), label="-1.0:0.2:1.0", frame=(width=300, height=120))
push!(window1.items, barplot3)

values = -100:20:100
barplot4 = BarPlot(values=values, scale=(min_x=-100, max_x=100), captions=string.(1:11), label="-100:20:100", frame=(width=300, height=120))
push!(window1.items, barplot4)

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
