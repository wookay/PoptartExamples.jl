# [deps]
# Poptart v0.3.1
# QRCode
#     https://github.com/jiegillet/QRCode.jl

using QRCode # qrcode
using Poptart.Desktop # Application Window

window1 = Window(title="QR Code")
app = Application(windows=[window1])

qr = qrcode("Hello world!")
spy1 = Spy(A=qr, frame=(width=200, height=200))
push!(window1.items, spy1)

Desktop.exit_on_esc() = true
Base.JLOptions().isinteractive==0 && wait(app.closenotify)
