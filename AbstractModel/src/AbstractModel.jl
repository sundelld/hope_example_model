using SpineInterface
using JuMP
using Cbc

include("structures.jl")

# Basic settings
model = JuMP.Model(Cbc.Optimizer)
set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)

# import input data, assuming data is in .\data\
input_data_url = "sqlite:///C:\\Users\\dsdennis\\HOPE\\Predicer\\input_data\\input_data.sqlite"
using_spinedb(input_data_url)

# Dates For indices use 1:n_dates
dates = map(x -> x[1], collect(price(commodity=commodity(:elec))))
n_dates = length(dates)

processes = []
nodes = []
stochastics = [1]
temporals = dates
directions = [-1, 1]

for n in node()
    push!(nodes, Node(n, string(n), string(commodity_node(node=n)[1]), !Bool(balance(node=n)), collect(map(x -> x[2], price(commodity=commodity_node(node=n)[1]))), Bool(balance(node=n))))
end

for uname in unit()
    p = Process(uname, string(uname), eff(unit=uname), min_load(unit=uname), max_load(unit=uname), capacity(unit=uname), VOM_cost(unit=uname))
    sources_and_sinks = input_node__unit__output_node(unit=uname)
    for n in nodes, s in sources_and_sinks
        if n.db_entry == map(x-> x[1], sources_and_sinks)[1]
            push!(p.sources, n)
        elseif n.db_entry == map(x -> x[2], sources_and_sinks)[1]
            push!(p.sinks, n)
        end
    end
    push!(processes, p)
end

for ntn in node__transfer__node()
    tobj = ntn[2]
    p_from = Process(tobj, string(tobj), 1.0 - losses(transfer_object=tobj), 0.0, 1.0, cap_from(transfer_object=tobj), 0)
    for n in nodes
        if n.db_entry == ntn[1]
            push!(p_from.sources, n)
        elseif n.db_entry == ntn[3]
            push!(p_from.sinks, n)
        end
    end
    p_to = Process(tobj, string(tobj), 1.0 - losses(transfer_object=tobj), 0.0, 1.0, cap_to(transfer_object=tobj), 0)
    for n in nodes
        if n.db_entry == ntn[3]
            push!(p_to.sources, n)
        elseif n.db_entry == ntn[1]
            push!(p_to.sinks, n)
        end
    end
    push!(processes, p_from)
    push!(processes, p_to)
end

demand = Demand()
for n in nodes
    flow_val = flow(node=n.db_entry)
        balance_val = balance(node=n.db_entry)
        if typeof(flow_val) != Nothing && balance_val != 0
            flow_val = map(x -> x[2], collect(flow_val))
            push!(demand.demands, (n, flow_val))
        end
end




# As per Topis contrbution to discussion:
@variable(model, node_state[nodes, stochastics, temporals], Bin)
#@variable(model, process_flow[processes, directions, nodes, stochastics, temporals])

@variable(model, node_slack[nodes, stochastics, temporals])

# Esas proposal 
@variable(model, process_flow[process, (source, sink), temporal])

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

# Translate results to human-readable format