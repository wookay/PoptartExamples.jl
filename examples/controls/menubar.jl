# [deps]
# Poptart v0.3.1
# Revise
# Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop
using CImGui

frame = (width=500, height=600)
window1 = Window(title="MenuBar", frame=frame, flags=CImGui.ImGuiWindowFlags_MenuBar)
app = Application(windows=[window1], title="App", frame=frame)

menu = Menu(title="Examples", items=[
    MenuItem(title="Main menu bar"),
    Separator(),
    MenuItem(title="Close"),
])
push!(window1.items, MenuBar(menus=[menu]))
push!(window1.items, Button(title="Button"))

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
