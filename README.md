# PoptartExamples.jl

[Poptart.jl](https://github.com/wookay/Poptart.jl)
  - GUI programming in Julia based on [CImGui.jl](https://github.com/Gnimuc/CImGui.jl)


  - 🖼  see [examples](https://github.com/wookay/PoptartExamples.jl/tree/master/examples)


### PackageCompiler

 * Highly recommended that to run Julia with the precompiled sysimage of the packages by [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl)

```
# Flux#zygote

using PackageCompiler
packages = (:Flux, :Zygote, :UnicodePlots, :Jive, :Colors, :Images, :GLFW, :CImGui)
blacklist = [:Distributed]
PackageCompiler.compile_incremental(packages..., blacklist=blacklist)
```

* on unix system
```
$ alias j=julia -J ~/.julia/dev/PackageCompiler/sysimg/sys.dylib
$ j
```

* on windows
```
$ doskey j=julia -J C:\\julia\\dev\\PackageCompiler\\sysimg\\sys.dll $*
$ j 
```
