module SimpleModel
using JuMP
using Cbc

# Basic settings
#model = Model(Clp.Optimizer)
#set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)

function add_model()
    return JuMP.Model(Cbc.Optimizer)
end


end # module
