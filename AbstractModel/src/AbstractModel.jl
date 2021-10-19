using SpineInterface
using JuMP
using Cbc

include("structures.jl")

# Basic settings
model = JuMP.Model(Cbc.Optimizer)
set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)

import_data = true
if import_data
    # import input data, assuming data is in .\data\
    input_data_url = #"sqlite:///C:    ....       \\Predicer\\input_data\\input_data.sqlite"
    using_spinedb(input_data_url)

    # Dates For indices use 1:n_dates
    dates = map(x -> x[1], collect(price(resource=resource(:elec))))
    n_dates = length(dates)

    processes = []
    nodes = []
    stochastics = [1]
    temporals = dates
    directions = [-1, 1]

    for n in node()
        push!(nodes, Node(n, string(n), string(resource_node(node=n)[1]), collect(map(x -> x[2], price(resource=resource_node(node=n)[1]))), !Bool(is_commodity(resource=resource_node(node=n)[1])), !Bool(is_CF(node=n)), Bool(has_balance(node=n))))
    end

    for pname in process()
        p = Process(pname, string(pname), online(process=pname), eff(process=pname), min_load(process=pname), max_load(process=pname), capacity(process=pname), VOM_cost(process=pname), ramp_up(process=pname), ramp_down(process=pname))
        sources_and_sinks = input_node__process__output_node(process=pname)
        for n in nodes, s in sources_and_sinks
            if n.db_entry == map(x-> x[1], sources_and_sinks)[1]
                push!(p.sources, n)
            elseif n.db_entry == map(x -> x[2], sources_and_sinks)[1]
                push!(p.sinks, n)
            end
        end
        push!(processes, p)
    end

    demand = Demand()
    for n in nodes
        flow_val = flow(node=n.db_entry)
        balance_val = has_balance(node=n.db_entry)
        if typeof(flow_val) != Nothing && balance_val != 0
            flow_val = map(x -> x[2], collect(flow_val))
            push!(demand.demands, (n, flow_val))
        end
    end
elseif !import_data
    r = include(".\\create_input_data.jl")()
    dates = r[1]
    nodes = r[2]
    processes = r[3]
    demand = r[4]
end


# As per Topis contrbution to discussion:
@variable(model, node_state[nodes, stochastics, temporals], Bin)
#@variable(model, process_flow[processes, directions, nodes, stochastics, temporals])

@variable(model, node_slack[nodes, stochastics, temporals])
#= 
# Esas proposal 
@variable(model, process_flow[p in process, (so in p.sources, si in p.sinks), temporal])

# Connections are basically a simple process with a efficiency of 1 (?). No need to implement?

# Node balance constraints
for n in nodes, t in temporals
    if n.balance
        #sum of process flows in and out from a node should be equal

        @constraint(model, )
    end
end

# process flow balance constraints
    # ensure that the flows from/in to a process (?) are at equilibrium.
    # In that case also need to model exhaust/wast heat/energy as one additional flow
    # OR, just have flow_in * eff = flow_out

# node_slack constraints. Actually not needed, since the cost could be set as absolute?

# Get input data into abstract format

    #Into node / process struct format
    #Functions for each type of "special plant", such as CHP or wind, etc
    # This means, that the abstract format data can be converted into a JuMP model easily

# Translate abstract format into JuMP

    # How to do this?
    # Processes as variables, and nodes as constraints?

# Run JuMP model

# Translate results to human-readable format =#