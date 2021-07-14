module ImagePhantoms

const RealU = Number # Union{Real, Unitful.Length}

# core:
include("shape.jl")
include("object.jl")

# shapes:
include("ellipse.jl")

end # module
