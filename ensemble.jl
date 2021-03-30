#!usr/bin/env julia

include("prob.jl")
include("paramsampler.jl")

ensemble_problem = EnsembleProblem(FAME_prob, prob_func = prob_func)
simulation = solve(ensemble_problem, Tsit5(), trajectories = 500)

#plot(simulation ,linealpha=0.6,color=:blue,vars=(0,2),title="Phase Space Plot")
#plot!(simulation ,linealpha=0.6,color=:red,vars=(0,3),title="Phase Space Plot")
#plot!(simulation ,linealpha=0.6,color=:red,vars=(0,4),title="Phase Space Plot")
gr()
summ = EnsembleSummary(simulation, 0:1:200)

low = DataFrame(summ.qlow)
high = DataFrame(summ.qhigh)
med = DataFrame(summ.u)

using CSV

CSV.write("low.csv", low)
CSV.write("high.csv", high)
CSV.write("med.csv", med)

plot(summ, idxs = (1),
     labels=["Nitrogen"], fillalpha=0.5, legend=:topleft)

plot(summ, idxs = (2),
     labels=["Nitrogen"], fillalpha=0.5, legend=:topleft)

plot(summ, idxs = (3),
     labels=["Nitrogen"], fillalpha=0.5, legend=:topleft)

plot(summ, idxs = (4),
     labels=["Nitrogen"], fillalpha=0.5, legend=:topleft)


#plot(summ, idxs = (3, 4),
#     labels=["Quota" "FAME"], fillalpha=0.5, legend=:topleft)
