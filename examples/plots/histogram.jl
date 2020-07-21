# [deps]
# Poptart, Revise, Jive

using Revise, Jive # revise watch

using Poptart
using .Poptart.Desktop

window1 = Window(title="Histogram")
app = Application(windows=[window1], title="App")

using Random
Random.seed!()

values = rand(10)
plot1 = Histogram(values=values, label="histogram1", scale=(min=0, max=1.0), frame=(width=150, height=100))
push!(window1.items, plot1)

values = rand(0:100, 10)
plot2 = Histogram(values=values, label="histogram2", scale=(min=0, max=100), frame=(width=150, height=100))
push!(window1.items, plot2)


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
