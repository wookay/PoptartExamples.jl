# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop # Application Window put! FontAtlas
using .Poptart.Controls # MenuBar Menu MenuItem
using CImGui

frame = (width=500, height=600)
window1 = Window(title="Styles", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

btn1 = Button(title="Light")
btn2 = Button(title="Dark")
btn3 = Button(title="Classic")
put!(window1, btn1, btn2, btn3)

didClick(btn1) do event
    CImGui.StyleColorsLight()
end

didClick(btn2) do event
    CImGui.StyleColorsDark()
end

didClick(btn3) do event
    CImGui.StyleColorsClassic()
end

FontAtlas.add_font_bundle()

Mouse.leftClick(btn2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
