#!usr/bin/env julia

using DiffEqSensitivity, Statistics
using YAML
using QuasiMonteCarlo
using DataFrames
using CSV

include("sobol_prob.jl")
include("paramsampler.jl")

FAME_sobol = function (p)
    prob = remake(FAME_prob; p=p)
    sol = solve(prob, Tsit5(); saveat = t)
    [mean(sol[1,:]), maximum(sol[1,:])]
end

N = 5000
param_range = sobol_range()
sampler = SobolSample()

nms = ["I0";"α"; "β"; "μM0"; "μN"; "μd"; "ϵ"; "γ"; "ki"; "kq"; "kN"; "ks"; "θ"]
lb = param_range[1,:]
ub = param_range[2,:]

@time begin
A,B = QuasiMonteCarlo.generate_design_matrices(N,lb,ub,sampler)
sbl = gsa(FAME_sobol, Sobol(order=[0,1,2]), A,B)      
end
p1 = bar(nms, 
          sbl.ST[1,:],title="Total Order Indices Mean Yield",legend=false)
p1_ = bar(nms,
          sbl.ST[2,:],title="Total Order Indices Max Yield",legend=false)
p2 = bar(nms, 
          sbl.S1[1,:],title="First Order Indices Mean Yield",legend=false)
p2_ = bar(nms,
          sbl.S1[2,:],title="First Order Indices Max Yield",legend=false)
      
plot(p1,p2,p1_,p2_)   

#CSV.write("SO.csv", DataFrame(sbl.S2))
#CSV.write("FO.csv", DataFrame(sbl.S1))
#CSV.write("TO.csv", DataFrame(sbl.ST))