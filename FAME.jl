#!usr/bin/env julia




function light_scatter(L, I0, α, β, X, ks, ki)
    """
    Del-Chanona et al.'s trapezoidal approximation for scattering effects of incident reactor illumination
    Source:
    
    Vars:
    BM - Biomass g/g
    z  - length discretisation
    μM - N2 quota mg/g 
    I  - light strength

    """
    
    z = [0;
         collect(1:10) / 10 * L]
    
    I = I0 * exp.( - ( α * X + β ) .* z)
    j = 0
    μM = 0

    for intensity in I
        
        if (j == 0) || (j == 0)
            ax =     intensity / (intensity + ks + intensity^2/ki)
        else
            ax = 2 * intensity / (intensity + ks + intensity^2/ki)
        end
        
    j += 1    
    μM += ax
    end
    
    return μM
end  
    
function FAME(dx, x, prm, t)
    """
    Del-Chanona et al.'s dynamic model for FAME production in a bioreactor
    Source:
    
    Vars:
    BM - Biomass g/g
    N - N2 content mg/g
    q - N2 quota mg/g 
    f - FAME yield mg/g

    """

    # extract params
    I0, α, β, μM0, μN, μd, ϵ, γ, ki, kq, kN, ks, θ = prm 
    
    # extract state vars for clarity:
    BM, N, q, f = x  
    
    # get light scattering approximation
    Reactor_Length = 0.044
    μM = μM0 / 20 * light_scatter(Reactor_Length, I0, α, β, BM, ks, ki)
    μ0 = μM * ( 1 - kq / q )
      
    # dynamic equations:
    dx[1] =  BM * ( μ0 - μd )                                     # dXdt = X(u0-ud)
    dx[2] = - μN * BM * N / ( N + kN )                             # dNdt = -uN N/(N+kN)X
    dx[3] =  μN * N / ( N + kN ) - μM * ( 1 - kq / q ) * q        # dqdt = uN N/N+kN -um(I)(1-kq/q)*q
    dx[4] =  μ0 * ( θ * q - ϵ * f ) - γ * μN * N / ( N + kN )     # dfdt = um(I) ( theata*q-eps*f)(1-kq/q) - 
                                                                  #        gamma uN N/N+k
    
end
