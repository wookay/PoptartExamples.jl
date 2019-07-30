# Poptart v0.2.2

# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # MenuBar Menu MenuItem Separator
using CImGui

frame = (width=500, height=600)
window1 = Window(title="MenuBar", frame=frame, flags=CImGui.ImGuiWindowFlags_MenuBar)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

menu = Menu(title="Examples", items=[
    MenuItem(title="Main menu bar"),
    Separator(),
    MenuItem(title="Close"),
])
put!(window1, MenuBar(menus=[menu]))

put!(window1, Button(title="Button"))

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
