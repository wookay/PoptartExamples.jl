# [deps]
# Flux#zygote
#     https://github.com/FluxML/Flux.jl/tree/zygote
# Poptart, CImGui, Revise, Jive

# code from https://github.com/JuliaComputing/ODSC2019/blob/master/01-Flux-digits.ipynb

module App

using Poptart
using .Poptart.Desktop
using CImGui
using Flux
using .Flux.Data: MNIST
using Printf

mnist_label(label::Int)::String = string(label)
mnist_label_names = mnist_label.(0:9)

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

function mnist_images(set = :train)
    MNIST.load()
    io = IOBuffer(read(set == :train ? MNIST.TRAINIMAGES : MNIST.TESTIMAGES))
    _, N, nrows, ncols = MNIST.imageheader(io)
    (MNIST.rawimage(io) for _ in 1:N)
end

function mnist_labels(set = :train)
    MNIST.load()
    io = IOBuffer(read(set == :train ? MNIST.TRAINLABELS : MNIST.TESTLABELS))
    _, N = MNIST.labelheader(io)
    (MNIST.rawlabel(io) for _ = 1:N)
end

function main()
    frame = (width=500, height=400)
    window1 = Window(title="MNIST", frame=frame, flags=CImGui.ImGuiWindowFlags_NoMove)
    app = Application(windows=[window1], title="App", frame=frame)

    spy1 = Spy(A=fill(0, (28, 28)), label="", frame=(width=100, height=100))
    barplot1 = BarPlot(captions=mnist_label_names, values=fill(0, 10))
    btn_getdata = Button(title="getdata", frame=(width=80, height=30))
    btn_evaluate = Button(title="evaluate", frame=(width=80, height=30))
    push!(window1.items, spy1, barplot1, btn_getdata, btn_evaluate)

    btn_train = Button(title="train", frame=(width=80, height=30))
    slider_repeated = Slider(label="repeated", range=1:10000, value=100)
    push!(window1.items, Group(items=[btn_train, SameLine(), slider_repeated]))

    n_inputs = 28^2 # 84
    n_outputs = 10 # length(unique(trainlabels))

    model = Chain(Dense(n_inputs, n_outputs, identity), softmax)
    L(x,y) = Flux.crossentropy(model(x), y)
    opt = Descent()

    item = Item(nothing, nothing)

    trainimages = mnist_images(:train)
    trainlabels = mnist_labels(:train)

    testimages = mnist_images(:test)
    testlabels = mnist_labels(:test)

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
        spy1.label = mnist_label(item.label)
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
    app
end # main()

Desktop.exit_on_esc() = true

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    app = main()
    Base.JLOptions().isinteractive==0 && wait(app.closenotify)
    return 0
end

end # module App

using .App: julia_main
julia_main(ARGS)
