#= using Dates
using CSV
using JuMP
using DataFrames
using Cbc
using Plots =#
using SpineInterface
#
# t_start = Dates.now()
#
# # Include file
# include(".\\src\\SimpleModel.jl")
#
# # Basic solver/model settings
# model = SimpleModel.add_model()
# set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)
#
# # import input data, assuming data is in .\data\
# unit_data = CSV.read(".\\data\\unit_data.csv", DataFrame)
# price_data = CSV.read(".\\data\\price_data.csv", DataFrame)
# demand_data = CSV.read(".\\data\\demand_data.csv", DataFrame)
# supply_data = CSV.read(".\\data\\supply_data.csv", DataFrame)
# node_data = CSV.read(".\\data\\node_data.csv", DataFrame)
#
# dates = demand_data.date
# n_dates = length(dates);

using_spinedb("sqlite:///C:\\Users\\dsdennis\\HOPE\\Predicer\\input_data\\input_data.sqlite")
# Object classes
# commodity
# node
# transfer_object
# node

#relationship classes
# commodity__node__node
# commodity_node
# input_node__unit__output_node
# node__input_node
# node__output_node
# node__transfer__node
# node__node

# commodity()[2]
# commodity(:elec)

# commodity_node(commodity=commodity(:elec))

input_data = Dict();
input_data["node"] = node()
input_data["commodity"] = commodity()
input_data["unit"] = unit()
input_data["transfer_object"] = transfer_object()

#= 
mutable struct State
    value::Float64
    min_value::Float64
    max_value::Float64
end

struct Node
    commodity::String
    balance::Bool  # 3 options: No, strict balance per t (no storage), and storage balance
    state::State  # state for storage?
    processes::Vector{Any}
    cost::Float64
    flow::Vector{Float64} # Inflow (demand),which has to be matched if balance = True
end

struct Process
    source::Node
    sink::Node
    cost::Float64
    eff::Float64
    flow::Float64
    flow_min::Float64
    flow_max::Float64
end

nodes = []

for i = 1:length(node_data.commodity)
    push!(nodes, Node(node_data.commodity[i]))
     node_data.balance[i],
     State(node_data.initial_state[i], node_data.state_min[i], node_data.state_max[i]),
     [],
     node_data.cost[i]))
end

processes = []
for i = 1:length(unit_data.unit_name)
    push!(processes, Process()

end



a = 1


# In JuMP:
# Node balances are constraints
# processes are variables

# The State of a node at time t is equal to the state of the node at t-1 plus
# the sum of the value of all flows connecting to the node at t-1?
# This can be set to 0, if there is a balance requirement, or to something else
# if commodity can be stored in teh node.

# For each node: Sumof flows = is within state limits, or 0, depending on node,
# If node has balance. Otherwise no limits

# Worth checking what the optimal problem structure is, from a solver
# point of view.

# Should write this mathematically, and find equal solution ?
# Assuming the math behind the abstract and descriptive models should be equal.


# On - off variable, such as 2-way exclusive flow could simply have two constraint
# variables, the value of which can be between -1 and 1, and the product of these
# has to be -1
# ^ That is wrong, need to rethink

# How to model ramping limits?


# Data -> Descriptive layer interpreting/translating data -> Abstract model
# -> descriptive layer interpreting/translating results -> Results


# Input data , xlsx or smth => Model-readable data => Build model => Run model => Translate results => Output
 =#