#!usr/bin/env julia

include("prob.jl")
include("paramsampler.jl")

ensemble_problem = EnsembleProblem(FAME_prob, prob_func = prob_func)
simulation = solve(ensemble_problem, Tsit5(), trajectories = 100)

#plot(simulation ,linealpha=0.6,color=:blue,vars=(0,2),title="Phase Space Plot")
#plot!(simulation ,linealpha=0.6,color=:red,vars=(0,3),title="Phase Space Plot")
#plot!(simulation ,linealpha=0.6,color=:red,vars=(0,4),title="Phase Space Plot")
gr()
summ = EnsembleSummary(simulation, 0:1:200)

plot(summ, idxs = (1, 2),
     labels=["Biomass" "Nitrogen"], fillalpha=0.5, legend=:topleft)

plot(summ, idxs = (3, 4),
     labels=["Quota" "FAME"], fillalpha=0.5, legend=:topleft)