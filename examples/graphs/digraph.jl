using Tutte.Graphs # WTGraph → ←  Node @nodes
using .Graphs: simpledigraph_nodes
using LightGraphs.SimpleGraphs: SimpleDiGraph

@nodes A B C D E
graph = WTGraph(union(A → C → D → E, C → E ← B))
g, nodes = simpledigraph_nodes(graph)

using Allographs.GPlot
plot = GPlot.gplot(g)

using Poptart.Controls # Canvas
using Poptart.Drawings # Line Polyline Curve TextBox stroke translate scale
using Colors: RGBA
using Compose: inch

canvas = Canvas()
transform(element) = translate(scale(element, 5inch.value), 200)

textColor = RGBA(0.8, 0.7, 0.8, 0.9)
for (i, n) in enumerate(plot.nodes)
    rect = ((n.center .- n.radius)..., (n.center .+ n.radius)...)
    node = nodes[i]
    textbox = TextBox(text=String(node.id), rect=rect, color=textColor) |> transform
    put!(canvas, textbox)
end

thickness = 6
strokeColor = RGBA(0.1, 0.7, 0.8, 1)
for points in plot.lines
    line = Line(points=points, thickness=thickness, color=strokeColor) |> transform
    put!(canvas, stroke(line))
end
for points in plot.arrows
    arrow = Polyline(points=points, thickness=thickness, color=strokeColor) |> transform
    put!(canvas, stroke(arrow))
end

using Poptart.Desktop # Window Application
width, height = 500, 500
window1 = Window(items=[canvas], title="SimpleDiGraph", frame=(x=10, y=10, width=width-20, height=height-20))
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=(width=width, height=height), closenotify=closenotify)
Base.JLOptions().isinteractive==0 && wait(closenotify)
