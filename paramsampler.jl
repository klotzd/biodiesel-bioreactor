#!usr/bin/env julia

using Distributions
using Random
using YAML


function sample_params()
    """
    """

    params = YAML.load_file("params.yml")
    scale = 1

    α_dist = Normal(params["α"], scale * params["α-s"])
    α = rand(α_dist, 1)

    β_dist = Normal(params["β"], scale * params["β-s"])
    β = rand(β_dist, 1)

    μM0_dist = Normal(params["μM0"], scale * params["μM0-s"])
    μM0 = rand(μM0_dist, 1)

    μN_dist = Normal(params["μN"], scale * params["μN-s"])
    μN = rand(μN_dist, 1)

    μd_dist = Normal(params["μd"], scale * params["μd"])
    μd = rand(μd_dist, 1)

    ϵ_dist = Normal(params["ϵ"], scale * params["ϵ-s"])
    ϵ = rand(ϵ_dist, 1)

    γ_dist = Normal(params["γ"], scale * params["γ-s"])
    γ = rand(γ_dist, 1)

    ki_dist = Normal(params["ki"], scale * params["ki-s"])
    ki = rand(ki_dist, 1)

    kq_dist = Normal(params["kq"], scale * params["kq-s"])
    kq = rand(kq_dist, 1)

    kN_dist = Normal(params["kN"], scale * params["kN-s"])
    kN = rand(kN_dist, 1)

    ks_dist = Normal(params["ks"], scale * params["ks-s"])
    ks = rand(ks_dist, 1)

    θ_dist = Normal(params["θ"], scale * params["θ-s"])
    θ = rand(θ_dist, 1)

    prm = [params["I0"]; α; β; μM0; μN; μd; ϵ; γ; ki; kq; kN; ks; θ]

    return prm
end

function sobol_range()
    """
    """

    params = YAML.load_file("params.yml")
    scale = 0.2

    parameters = ["α"; "β"; "μM0"; "μN"; "μd"; "ϵ"; "γ"; "ki"; "kq"; "kN"; "ks"; "θ"]

    rng  = Array{Float64}(undef, (2,1))
    rng[1,1] = params["I0"]
    rng[2,1] = params["I0"]
    for name in parameters
        sdname = name * "-s"
        upper = params[name] + params[name] * 0.001
        lower = params[name] - params[name] * 0.001
        rng = hcat(rng, [upper, lower])
    end 

    return rng
end

function prob_func(prob,i,repeat)
    """
    
    """
    new_prms = sample_params()
    p_new = new_prms
    remake(prob,p=p_new)
  end