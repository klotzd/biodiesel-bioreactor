#!usr/bin/env julia

using YAML
using DataFrames
using DifferentialEquations
using Plots
using Sundials

gr()
include("FAME_dynsys.jl")

params = YAML.load_file("params.yml")

p = [ 
      params["I0"];  params["α"];  params["β"];
      params["μM0"]; params["μN"]; params["μd"];
      params["ϵ"];   params["γ"];  params["ki"];
      params["kq"];  params["kN"]; params["ks"]; 
      params["θ"]; params["τ"]; params["δ"]; params["ϕ"]
    ]

diff_vars = [true; true; true; true; false]

    
x0 = [.18; 36; 80; 120]
tspan = (0.0, 250.0)

FAME_prob = ODEProblem(FAME, x0, tspan, p)
sol = solve(FAME_prob,Tsit5())

res_frame = DataFrame( Time = sol.t[:],
                       Biomass = sol[1,:],
                       Nitrate = sol[2,:],
                       N_quota = sol[3,:],
                       FAME_yield = sol[4,:])

#one = plot(res_frame[!,"Time"], res_frame[!, "Biomass"], 
#           label = "Biomass g/L", legend=:topleft)
#two = twinx()
#plot!(two, res_frame[!,"Time"], [res_frame[!, "Nitrate"], res_frame[!, "N_quota"], res_frame[!, "FAME_yield"] ]/10, 
#     labels = ["Nitrate" "N2 Quota" "FAME Yield"], legend=:topright)
