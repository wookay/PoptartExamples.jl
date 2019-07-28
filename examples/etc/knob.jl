# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Knob
using CImGui

frame = (width=500, height=600)
window1 = Window(title="Group", frame=frame, flags=CImGui.ImGuiWindowFlags_NoMove)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

knob1 = Knob(label="knob", value=5, range=0:10)
put!(window1, knob1)

didClick(knob1) do event
    @info :didClick (event, knob1.value)
end


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
