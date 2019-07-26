# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Group

frame = (width=500, height=600)
window1 = Window(title="Group", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

btn = Button(title="train", frame=(width=80, height=30))
slider = Slider(label="repeated", range=1:10000, value=100)
put!(window1, Group(items=[btn, SameLine(), slider]))


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
