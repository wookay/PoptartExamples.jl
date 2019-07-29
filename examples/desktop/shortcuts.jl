# [deps]
# Poptart

using Poptart.Desktop # Application Window put!
using Poptart.Controls # Label
using Poptart.Desktop.Shortcuts # didPress Shift Ctrl Alt Super Key Esc Enter Space Backspace

frame = (width=500, height=600)
window1 = Window(title="Group", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", frame=frame, closenotify=closenotify)

didPress(Super) do event
    @info :super event.pressed
end

didPress(Super + Alt) do event
    @info :super_alt event.pressed
end

didPress(Esc) do event
    @info :esc event.pressed
end

didPress(Enter) do event
    @info :enter event.pressed
end

didPress(Space) do event
    @info :space event.pressed
end

didPress(Backspace) do event
    @info :backspace event.pressed
end

didPress(Ctrl + Key('F')) do event
    @info :ctrl_F event.pressed
end

didPress(Shift + Alt + Key('1')) do event
    @info :shift_alt_1 event.pressed
end

label1 = Label(text=join(["super", "super_alt", "esc", "enter", "space", "backspace", "ctrl_F", "shift_alt_1"], '\n'))
put!(window1, label1)

Base.JLOptions().isinteractive==0 && wait(closenotify)
