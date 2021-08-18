#---------------------------------------------------------
# # [ImagePhantoms overview](@id 1-overview)
#---------------------------------------------------------

# This page explains the Julia package
# [`ImagePhantoms`](https://github.com/JuliaImageRecon/ImagePhantoms.jl).

# ### Setup

# Packages needed here.

using ImagePhantoms
using ImageGeoms: ImageGeom, axesf
using MIRTjim: jim, prompt
using UnitfulRecipes
using Unitful: mm
#using Plots: scatter, plot!, default; default(markerstrokecolor=:auto)

# The following line is helpful when running this example.jl file as a script;
# this way it will prompt user to hit a key after each figure is displayed.

isinteractive() ? jim(:prompt, true) : prompt(:draw);

# ### Overview

# When developing image reconstruction methods,
# it can be helpful to simulate data (e.g., sinograms)
# using software-defined images called phantoms.

# The simplest method here is to make a Shepp-Logan phantom image
# similar its use in other packages.

image = shepp_logan(256) # CT version by default
jim(image, "SheppLogan", clim=(0.9, 1.1), yflip=false)


# ### Sinograms and spectra

# Often for image reconstruction algorithm development,
# we need not only the phantom image, but also its sinogram and spectrum.
# We start with the vector of ellipses that defines the phantom,
# using a typical field of view (FOV) of 200mm for a head:

objects = shepp_logan(SheppLoganToft(); fovs=(200mm,200mm))


# From that collection we can compute images, sinograms and spectra.
# It is convenient (but not required)
# to use `ImageGeoms` to help with the sampling.

ig = ImageGeom(dims=(200,256), deltas=(1mm,1mm))
image = phantom(axes(ig)..., objects)
jim(axes(ig)..., image, xlabel="x", ylabel="y", title="SheppLoganToft")


# Here is the sinogram corresponding to this phantom,
# computed analytically from the ellipse parameters:

r = LinRange(-100mm,100mm,401)
ϕ = deg2rad.(0:180)
sino = radon(r, ϕ, objects)
jim(r, ϕ, sino, title="Sinogram", yflip=false, aspect_ratio=:none)


# Here is the 2D spectrum (Fourier transform) of this phantom,
# computed analytically from the ellipse parameters:

kspace = spectrum(axesf(ig)..., objects)
jim(axesf(ig)..., log10.(abs.(kspace/(1mm)^2)), xlabel="ν₁", ylabel="ν₂", title="log10|Spectrum|")
