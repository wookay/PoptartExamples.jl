# [deps]
# Flux#zygote
#     https://github.com/FluxML/Flux.jl/tree/zygote
# Poptart, CImGui, Revise, Jive

# code from https://github.com/JuliaComputing/ODSC2019/blob/master/01-Flux-digits.ipynb

module App

using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Spy BarPlot Slider Group SameLine
using CImGui
using Flux
using .Flux.Data: FashionMNIST
using Printf

const fashion_label_names = [
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
    fashion_label_names[label+1]
end

preprocess(img) = vec(Float64.(img))

function create_batch(trainimages, trainlabels, batchsize)
    xs = preprocess.(Iterators.take(trainimages, batchsize))
    ys = Flux.onehot.(Iterators.take(trainlabels, batchsize), Ref(0:9))
    return (Flux.batch(xs), Flux.batch(ys))
end

mutable struct Item
    img
    label
end

function fashion_images(set = :train)
    FashionMNIST.load()
    io = IOBuffer(read(set == :train ? FashionMNIST.TRAINIMAGES : FashionMNIST.TESTIMAGES))
    _, N, nrows, ncols = FashionMNIST.imageheader(io)
    (FashionMNIST.rawimage(io) for _ in 1:N)
end

function fashion_labels(set = :train)
    FashionMNIST.load()
    io = IOBuffer(read(set == :train ? FashionMNIST.TRAINLABELS : FashionMNIST.TESTLABELS))
    _, N = FashionMNIST.labelheader(io)
    (FashionMNIST.rawlabel(io) for _ = 1:N)
end

function main()
    frame = (width=500, height=400)
    window1 = Window(title="Fashion MNIST", frame=frame, flags=CImGui.ImGuiWindowFlags_NoMove)
    closenotify = Condition()
    app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

    spy1 = Spy(A=fill(0, (28, 28)), label="", frame=(width=100, height=100))
    barplot1 = BarPlot(captions=fashion_label_names, values=fill(0, 10))
    btn_getdata = Button(title="getdata", frame=(width=80, height=30))
    btn_evaluate = Button(title="evaluate", frame=(width=80, height=30))
    put!(window1, spy1, barplot1, btn_getdata, btn_evaluate)

    btn_train = Button(title="train", frame=(width=80, height=30))
    slider_repeated = Slider(label="repeated", range=1:10000, value=100)
    put!(window1, Group(items=[btn_train, SameLine(), slider_repeated]))

    n_inputs = 28^2 # 84
    n_outputs = 10 # length(unique(trainlabels))

    model = Chain(Dense(n_inputs, n_outputs, identity), softmax)
    L(x,y) = Flux.crossentropy(model(x), y)
    opt = Descent()

    item = Item(nothing, nothing)

    trainimages = fashion_images(:train)
    trainlabels = fashion_labels(:train)

    testimages = fashion_images(:test)
    testlabels = fashion_labels(:test)

    function getdata() # testimages, testlabels, item, spy1, barplot1
        img = first(Iterators.take(testimages, 1))
        label = first(Iterators.take(testlabels, 1))
        item.img = Float64.(img)
        item.label = label
        spy1.A = item.img
        spy1.label = ""
        barplot1.values = fill(0, 10)
        barplot1.label = ""
    end

    function train()
        batchsize = 50 # 5000
        trainbatch = create_batch(trainimages, trainlabels, batchsize)
        testbatch = create_batch(trainimages, trainlabels, batchsize)

        function show_loss() # L, trainbatch, testbatch, item
            train_loss = L(trainbatch...)
            test_loss  = L(testbatch...)
            @printf("train loss = %.3f, test loss = %.3f\n", train_loss, test_loss)
            item.img !== nothing && evaluate()
        end
        Flux.train!(L, params(model), Iterators.repeated(trainbatch, slider_repeated.value), opt; cb = Flux.throttle(show_loss, 1))
    end

    function evaluate() # item, spy1, barplot1
        spy1.label = fashion_label(item.label)
        data = model(vec(item.img))
        barplot1.values = data
        (maxval, index) = findmax(data)
        if (index - 1) == item.label
            barplot1.label = string("correct", "\n", maxval)
        else
            barplot1.label = string("Error", "\n", data[item.label+ 1])
        end
    end

    didClick(btn_getdata) do event
        getdata()
    end

    didClick(btn_evaluate) do event
        evaluate()
    end

    didClick(btn_train) do event
        train()
    end

    getdata()
    closenotify
end # main()

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    closenotify = main()
    Base.JLOptions().isinteractive==0 && wait(closenotify)
    return 0
end

end # module App

using .App: julia_main
julia_main(ARGS)
