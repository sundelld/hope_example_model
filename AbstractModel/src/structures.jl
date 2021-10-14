#abstract type AbstractProcess end

struct Node#{T<:AbstractProcess}
    db_entry::Any
    name::String
    resource_name::String
    commodity::Bool
    cost::Vector{Float64}
    state::Bool
    processes::Vector{Any}
    function Node(db_entry, name, resource_name, commodity, cost, state)
        return new(db_entry, name, resource_name, commodity, cost, state, [])
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
    resource::Any
    sources::Vector{Node}
    sinks::Vector{Node}
    function Process(db_entry, type, online, eff, load_min, load_max, capacity, VOM_cost, ramp_up, ramp_down, resource)
        return new(db_entry, type, online, eff, load_min, load_max, capacity, VOM_cost, ramp_up, ramp_down, resource, [], [])
    end
end

struct Demand
    demands::Vector{Tuple{Node, Vector{Float64}}}
    function Demand()
        return new([])
    end
end