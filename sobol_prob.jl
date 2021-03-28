#!usr/bin/env julia

using YAML
using DataFrames
using DifferentialEquations
using Plots

gr()
include("FAME.jl")

params = YAML.load_file("params.yml")

p = [ 
      params["I0"];  params["α"];  params["β"];
      params["μM0"]; params["μN"]; params["μd"];
      params["ϵ"];   params["γ"];  params["ki"];
      params["kq"];  params["kN"]; params["ks"]; 
      params["θ"]
    ]

tmax = 200
    
x0 = [.18; 36; 80; 120]
tspan = (0.0, tmax)

FAME_prob = ODEProblem(FAME, x0, tspan, p)
t = collect(range(0, tmax, length = tmax*600))