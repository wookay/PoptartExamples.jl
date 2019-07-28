using Poptart.Desktop # Application Windows put!
using .Desktop: throttle
using Poptart.Controls # Button Label Slider didClick
using CImGui

closenotify = Condition()
app = Application(closenotify=closenotify)

arr = rand(1)
thr = throttle(1) do # 1 seconds
    global arr
    arr = rand(10)
end

w = Window() do
    thr()
    CImGui.PlotLines("rand(10)", arr, length(arr))
end
push!(app.windows, w)

btn = Button(title="drag me") do
   if CImGui.IsItemActive()
       io = CImGui.GetIO()
       draw_list = CImGui.GetWindowDrawList()
       CImGui.PushClipRectFullScreen(draw_list)
       click_pos = CImGui.Get_MouseClickedPos(io, 0)
       CImGui.AddLine(draw_list, click_pos, io.MousePos, CImGui.GetColorU32(CImGui.ImGuiCol_Button), 5)
       CImGui.PopClipRect(draw_list)
   end
end
push!(w.items, btn)

Base.JLOptions().isinteractive==0 && wait(closenotify)
