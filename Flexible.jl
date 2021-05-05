using Dates
using CSV
using JuMP
using DataFrames
using Cbc
using Plots

t_start = Dates.now()

# Include file
include(".\\src\\SimpleModel.jl")

# Basic settings
model = JuMP.Model(Cbc.Optimizer)
set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)

# import input data, assuming data is in .\data\
unit_data = CSV.read(".\\data\\unit_data.csv", DataFrame)
price_data = CSV.read(".\\data\\price_data.csv", DataFrame)
demand_data = CSV.read(".\\data\\demand_data.csv", DataFrame)
supply_data = CSV.read(".\\data\\supply_data.csv", DataFrame)

dates = demand_data.date
unit_names = unit_data.unit_name
n_dates = length(dates);
n_units = length(unit_names)


# Intitialize dict containing unit data
# Dict(Dict(Dict))) => Output type, unit name, unit parametres
units = Dict()
for i in 1:length(unit_data.unit_name)
    op = unit_data.output[i]
    uname = unit_data.unit_name[i]
    if !(op in keys(units))
        units[op] = Dict()
    end
    units[op][uname] = Dict()
    for colname in names(unit_data)
        units[op][uname][colname] = unit_data[!, colname][i]
    end
end

# Find units
function find_units(keys, us)
    relevant_units = []
    for u in us
        if u in keys
            push!(relevant_units, u)
        end
    end
    relevant_units
end

@variable(model, unit_states[dates, k in keys(units), unit_names], Bin, container=DenseAxisArray)

# units power/production
@variable(model, unit_powers[dates, k in keys(units), unit_names], container=DenseAxisArray)

# MIP constraints
for op in keys(units)
    for date in dates, uname in unit_names
        if uname in keys(units[op])
            @constraint(model, unit_powers[date, op, uname] .<= unit_states[date, op, uname] .* units[op][uname]["max_power"]')
            @constraint(model, unit_powers[date, op, uname] .>= unit_states[date, op, uname] .* units[op][uname]["min_power"]')
        else
             @constraint(model, unit_powers[date, op, uname] .== 0)
        end
    end
end

# Dummy power in case demand cannot be met by production units
@variable(model, dummy_power[dates, keys(units)])
for date in dates, op in keys(units)
    @constraint(model, dummy_power[date, op] >= 0)
end

# General constraints
# Constraint per output type
for op in keys(units)
    for d in dates
        @constraint(model, sum(unit_powers[d, op, :]) + dummy_power[d, op] .== demand_data[!, op][d])
    end
end

# HP heat availability constraint
# Wind availability constraint
# CHP constraint

#VOM_cost = VOM_cost .* unit states?
@expression(model, vom_costs[d in dates, op in keys(units), uname in keys(units[op])], unit_states[d, op, uname] .* units[op][uname]["VOMcost"])
# fuel_cost = power ./ eff .* fuel price
@expression(model, fuel_costs[d in dates, op in keys(units), uname in keys(units[op])], unit_powers[d, op, uname] ./ units[op][uname]["plant_eff"] .* price_data[!, units[op][uname]["input"]][d])
@expression(model, cost[d in dates, op in keys(units), uname in keys(units[op])], fuel_costs[d, op, uname] + vom_costs[d, op, uname])





@objective(model, Min, sum(cost))
optimize!(model)
