# [deps]
# Flux#zygote, Poptart, Revise, Jive

using Revise, Jive

const fashion_labels = [
    "T-shirt/top", # 👕
    "Trouser",     # 👖
    "Pullover",    # 🏂
    "Dress",       # 👗
    "Coat",        # 🧥
    "Sandal",      # 👡
    "Shirt",       # 👔
    "Sneaker",     # 👟
    "Bag",         # 👜
    "Ankle boot",  # 👢
]

function fashion_label(label::Int)::String
    fashion_labels[label+1]
end

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Spy BarPlot

frame = (width=500, height=400)
window1 = Window(title="Fashion MNIST", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

spy1 = Spy(A=fill(0, (28, 28)), label="", frame=(width=100, height=100))
put!(window1, spy1)

barplot1 = BarPlot(captions=fashion_labels, values=fill(0, 10))
put!(window1, barplot1)

btn_getdata = Button(title="getdata", frame=(width=80, height=30))
put!(window1, btn_getdata)

btn_evaluate = Button(title="evaluate", frame=(width=80, height=30))
put!(window1, btn_evaluate)

println("loading train data")

using Flux
using .Flux.Data: FashionMNIST

trainimages = FashionMNIST.images()
trainlabels = FashionMNIST.labels()

# code from https://github.com/JuliaComputing/ODSC2019/blob/master/01-Flux-digits.ipynb

preprocess(img) = vec(Float64.(img))
function create_batch(r)
    xs = preprocess.(trainimages[r])
    ys = Flux.onehot.(trainlabels[r], Ref(0:9))
    return (Flux.batch(xs), Flux.batch(ys))
end

batchsize = 50 # 5000
trainbatch = create_batch(1:batchsize)
testbatch = create_batch(batchsize+1:2batchsize)

n_inputs = 28^2 # 84
n_outputs = 10 # length(unique(trainlabels))

model = Chain(Dense(n_inputs, n_outputs, identity), softmax)
L(x,y) = Flux.crossentropy(model(x), y)
opt = Descent()

mutable struct Item
    nth
    img
end

item = Item(nothing, nothing)

println("loading test data")

testimages = FashionMNIST.images(:test)
testlabels = FashionMNIST.labels(:test)

function getdata()
    global item
    nth = rand(1:length(testimages))
    item.nth = nth
    item.img = Float64.(testimages[nth])
    spy1.A = item.img
    spy1.label = ""
    barplot1.values = fill(0, 10)
    barplot1.label = ""
end

function evaluate()
    global item
    nth = item.nth
    img = item.img

    label = testlabels[nth]
    spy1.label = fashion_label(label)

    data = model(vec(img))
    barplot1.values = data
    (maxval, index) = findmax(data)
    if (index - 1) == label
        barplot1.label = string("correct", "\n", maxval)
    else
        barplot1.label = string("Error", "\n", data[label+ 1])
    end
end

didClick(btn_getdata) do event
    getdata()
end

didClick(btn_evaluate) do event
    evaluate()
end

getdata()

using Printf
function show_loss()
    train_loss = L(trainbatch...)
    test_loss  = L(testbatch...)
    @printf("train loss = %.3f, test loss = %.3f\n", train_loss, test_loss)
    item.img !== nothing && evaluate()
end
Flux.train!(L, params(model), Iterators.repeated(trainbatch, 200), opt; cb = Flux.throttle(show_loss, 1))


trigger = function (path)
    printstyled("changed ", color=:cyan)
    println(path)
    revise()
end

watch(trigger, @__DIR__, sources=[pathof(Poptart)])
trigger("")

Base.JLOptions().isinteractive==0 && wait(closenotify)
