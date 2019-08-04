# [deps]
# UMAP
#     https://github.com/dillondaudert/UMAP.jl

using UMAP # UMAP_
using SparseArrays # sprand
using Poptart.Desktop # Application Window put!
using Poptart.Controls # Spy ScatterPlot

window1 = Window(title="UMAP")
closenotify = Condition()
app = Application(windows=[window1], closenotify=closenotify)

A = sprand(100, 100, 0.001)
umap = UMAP_(A)
spy1 = Spy(A=umap.graph, label="umap.graph", frame=(width=150, height=150))
put!(window1, spy1)

x = [umap.embedding[1,j] for j in 1:size(umap.embedding)[2]]
y = [umap.embedding[2,j] for j in 1:size(umap.embedding)[2]]
plot1 = ScatterPlot(label="umap.embedding", x=x, y=y, frame=(width=150, height=150))
put!(window1, plot1)

Base.JLOptions().isinteractive==0 && wait(closenotify)
