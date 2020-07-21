# [deps]
# Poptart v0.3
# Revise
# Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop
using SparseArrays # sprandn

frame = (width=600, height=800)
window1 = Window(title="Spy", frame=frame)
app = Application(windows=[window1], title="App", frame=frame)

A = sprandn(50, 120, .05)
spy1 = Spy(A=A, label="sprandn(50, 120, .05)", frame=(width=300, height=200))
push!(window1.items, spy1)

A = sprandn(10, 10, 0.1)
spy2 = Spy(A=A, label="sprandn(10, 10, 0.1)", frame=(width=100, height=100))
push!(window1.items, spy2)

A = sprandn(120, 50, .05)
spy3 = Spy(A=A, label="sprandn(120, 50, .05)", frame=(width=200, height=300))
push!(window1.items, spy3)

A = rand(28, 28)
spy4 = Spy(A=A, label= "rand(28, 28)", frame=(width=200, height=200))
push!(window1.items, spy4)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
