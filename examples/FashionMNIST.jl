using Revise, Jive
using Flux.Data # FashionMNIST

function fashion_label(label::Int)::String
    [
    "👕   T-shirt/top",
    "👖   Trouser",
    "🏂   Pullover",
    "👗   Dress",
    "🧥   Coat",
    "👡   Sandal",
    "👔   Shirt",
    "👟   Sneaker",
    "👜   Bag",
    "👢   Ankle boot",
    ][label+1]
end

images = FashionMNIST.images(:test)
labels = FashionMNIST.labels(:test)
# using UnicodePlots: spy
# (println ∘ spy)(images[1])

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Spy

window1 = Window(title="Fashion MNIST", frame=(width=500,height=200))
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=(width=630, height=400), closenotify=closenotify)

img = images[1]
preprocess(img) = vec(Float64.(img))

spy1 = Spy(A=reshape(preprocess(img),28,28), label=fashion_label(labels[1]), frame=(width=100, height=100))
put!(window1, spy1)

trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end
watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
