using Dates
using CSV
using JuMP
using DataFrames
using Cbc
using Plots

t_start = Dates.now()

# Include file
include(".\\src\\SimpleModel.jl")

# Basic solver/model settings
model = SimpleModel.add_model()
set_optimizer_attributes(model, "LogLevel" => 1, "PrimalTolerance" => 1e-7)

# import input data, assuming data is in .\data\
input_data = CSV.read(".\\data\\input_data.csv", DataFrame)

# cleaner form
date = input_data.date
el_spot_price = input_data.FI_spot_price_euro_per_MWh
DH_demand = input_data.DH_demand_MWh
el_demand = input_data.el_demand_MWh
NG_price = input_data.NG_price_euro_per_MWh
wind_power = input_data.wind_power_MWh
HP_heat_available = input_data.HP_heat_source_MWh

# Length of time series
n = length(date);

# Set a heravy penalty if demand cannot be met.
dummy_DH_price = zeros(n).+10000;

# Plants max power, min power
HP_max_power = zeros(n).+30;
HP_min_power = HP_max_power .* 0.2;
HOB_max_power = zeros(n).+30;
HOB_min_power = HOB_max_power .* 0.3;
CHP_max_power = zeros(n).+60;
CHP_min_power = CHP_max_power .* 0.4;

# Plants efficiency
HP_eff = 3;
HOB_eff = 0.8;
CHP_eff = 0.9;

# Define variables for plant power
@variable(model, (zeros(n))[i] <= HP_power[i = 1:n] <= HP_max_power[i])
@variable(model, (zeros(n))[i] <= HOB_power[i = 1:n] <= HOB_max_power[i])
@variable(model, (zeros(n))[i] <= CHP_power[i = 1:n] <= CHP_max_power[i])

# Add dummy power, in case demand can't be met using plants
@variable(model, dummy_power[i = 1:n], lower_bound=(zeros(n).+0)[i])
@variable(model, dummy_el_power[i = 1:n], lower_bound=(zeros(n).+0)[i])

# Constraints for operation
@constraint(model, con_HP,HP_power .<= HP_heat_available .* (3/2))
@constraint(model, con_test, (HP_power + HOB_power + CHP_power .* (2/3))  + dummy_power .== DH_demand)

# Minimize costs
@objective(model, Min, sum(HP_power ./ HP_eff .* el_spot_price + HOB_power ./ HOB_eff .* NG_price + CHP_power ./ CHP_eff .* NG_price + dummy_power .* dummy_DH_price - wind_power .* el_spot_price - CHP_power ./ 3 .* el_spot_price))
optimize!(model);

print(termination_status(model))
print("\n","HP_power value: ", value.(HP_power))
print("\n", "HOB_power, value: ", value.(HOB_power))
print("\n","CHP_power value: ", value.(CHP_power))
print("\n", "HP_power, percentage: ", value.(HP_power) ./ HP_max_power)
print("\n", "HOB_power, percentage: ", value.(HOB_power) ./ HOB_max_power)
print("\n", "CHP_power, percentage: ", value.(CHP_power) ./ CHP_max_power)
print("\n","dummy_power value: ", value.(dummy_power))

print("\n", "DH_demand: ", DH_demand)
print("\n", "demand - production: ", DH_demand-value.(HP_power)-value.(HOB_power),"\n")
print("total cost: ", sum((value.(HP_power) / HP_eff .* el_spot_price) + (value.(HOB_power) / HOB_eff .* NG_price)), "\n")
print("A total of ", Dates.now() - t_start, " has elapsed. ")

 plot(1:n, [DH_demand value.(HP_power) value.(HOB_power) value.(CHP_power).*2/3 value.(dummy_power)], title="DH demand", label=["DH_demand" "HP output" "HOB output" "CHP heat output" "additional output"])
