# [deps]
# Poptart v0.3
# Revise
# Jive

using Revise, Jive # revise watch
using Poptart
using .Poptart.Desktop # Application Window

frame = (width=500, height=600)
window1 = Window(title="Group", frame=frame)
app = Application(windows=[window1], title="App", frame=frame)

btn = Button(title="train", frame=(width=80, height=30))
slider = Slider(label="repeated", range=1:10000, value=100)
push!(window1.items, Group(items=[btn, SameLine(), slider]))


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
