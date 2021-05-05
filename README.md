# hope_example_model

Clone this repository onto your computer.

A julia version of >=1.6 is required

Start Julia

Check your current working directory using the `pwd()` function. Navigate to the repository directory on your computer using `cd("")`, containing the "project.toml" file
```
julia> pwd()
"C:\\....\\HOPE"

julia> cd("example_model\\")

julia> pwd()
"C:\\....\\HOPE\\example_model"
```

To access the built-in package manager in Julia, type `]`.
Type `activate .` to activate the project environment.
Type `instantiate` to download and install the requirements. This may take a while


```
(@v1.6) pkg> activate .
(SimpleModel) pkg>
(SimpleModel) pkg> instantiate
```

Use backspace to exit the package manager

To run any of the models, use the `include()` function
```
include("LP_model.jl")
include("MIP_model.jl")
include("Flexible.jl")
```
