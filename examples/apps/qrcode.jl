# [deps]
# QRCode
#     https://github.com/jiegillet/QRCode.jl

using QRCode # qrcode
using Poptart
using .Poptart.Desktop # Application Window put!
using .Poptart.Controls # Spy

frame = (width=350, height=350)
window1 = Window(title="QR Code", frame=frame)
closenotify = Condition()
app = Application(windows=[window1], title="App", closenotify=closenotify, frame=frame)

qr = qrcode("Hello world!")
spy1 = Spy(A=qr, label="", frame=(width=300, height=300))
put!(window1, spy1)

Base.JLOptions().isinteractive==0 && wait(closenotify)
