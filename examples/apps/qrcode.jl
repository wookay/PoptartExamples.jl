# [deps]
# QRCode
#     https://github.com/jiegillet/QRCode.jl

using QRCode # qrcode
using Poptart.Desktop # Application Window put!
using Poptart.Controls # Spy

window1 = Window(title="QR Code")
closenotify = Condition()
app = Application(windows=[window1], closenotify=closenotify)

qr = qrcode("Hello world!")
spy1 = Spy(A=qr, frame=(width=200, height=200))
put!(window1, spy1)

Base.JLOptions().isinteractive==0 && wait(closenotify)
