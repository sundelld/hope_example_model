#abstract type AbstractProcess end

struct Node#{T<:AbstractProcess}
    db_entry::Any
    name::String
    resource_name::String
    cost::Vector{Float64}
    is_commodity::Bool
    is_CF::Bool
    has_state::Bool
    processes::Vector{Any}
    function Node(db_entry, name, resource_name, cost, is_commodity, is_CF, has_state)
        return new(db_entry, name, resource_name, cost, is_commodity, is_CF, has_state, [])
    end
end

struct Process
    db_entry::Any
    type::String
    online::Bool
    eff::Float64
    load_min::Float64
    load_max::Float64
    capacity::Float64
    VOM_cost::Float64
    ramp_up::Float64
    ramp_down::Float64
    sources::Vector{Node}
    sinks::Vector{Node}
    function Process(db_entry, type, online, eff, load_min, load_max, capacity, VOM_cost, ramp_up, ramp_down)
        return new(db_entry, type, online, eff, load_min, load_max, capacity, VOM_cost, ramp_up, ramp_down, [], [])
    end
end

struct Demand
    demands::Vector{Tuple{Node, Vector{Float64}}}
    function Demand()
        return new([])
    end
end


# Should this layer be more generic. Instead of having ramp up/down, have a 
# parameter called "temporal limitations", or smthing. It could be a tuple
# showing the ramp up/down, or whatever the user wants to. 
# Basically limit the number of parameters in the struct, while maintaining the
# possibility to have many parameters as constraints

# Maybe also implement other limiting factors in a flexible way. These factors
# could be min/max load, capacities, connection with other processes, etc. 

# Each potential limiting factor could be a vector of limitations, so that a process could have
# a vector containing both the information for ramp and minimum shtdown/online time under
# temporal limitations

# limitations = [value, constraint operator(<, <=, =, >=, >), limiting factor(process or time rule?)]

# eff could be a separate value found in all 


# Flow min/max value
# dFlow/dt up/down with amount of time as well as size. Two types (ramp, minimum shtdown/online)
# Connection with other processes (CHP)
# Efficiency/losses
# costs
# sources and sinks
# Online/ofline/aintenance limitations