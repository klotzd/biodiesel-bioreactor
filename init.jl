#!usr/bin/env julia

using YAML
using DataFrames
using DifferentialEquations
using Plots
gr()

params = YAML.load_file("parameter.yml")

p = [ 
      params["I0"];  params["α"];  params["β"];
      params["μM0"]; params["μN"]; params["μd"];
      params["ϵ"];   params["γ"];  params["ki"];
      params["kq"];  params["kN"]; params["ks"]; 
      params["θ"]
    ]



    
x0 = [.18; 36; 80; 120]
tspan = (0.0,200.0)

prob = ODEProblem(FAME,x0,tspan, p)
sol = solve(prob,Tsit5(),reltol=1e-8,abstol=1e-8)

res_frame = DataFrame( Time = sol.t[:],
                       Biomass = sol[1,:],
                       Nitrate = sol[2,:],
                       N_quota = sol[3,:],
                       FAME_yield = sol[4,:])

plot(res_frame[!,"Time"], res_frame[!, "Biomass"], label = "Biomass g/L")
plot!(res_frame[!,"Time"], [res_frame[!, "Nitrate"], res_frame[!, "N_quota"], res_frame[!, "FAME_yield"] ]/100, labels = ["Nitrate" "N2 Quota" "FAME Yield"], axis=:right)
