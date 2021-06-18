using LinearAlgebra

#=
question2:
- Julia version: 1.5.3
- Author: pl
- Date: 2021-06-18
=#


# J'ai besoin d'une approximation de E[T] pour la policy on one shot.
function esperance_pour_gmax_egal_1(p)
    esperance = 0.
    for i in 0:100
        esperance += (1-p)^i * p * (i + 1)
    end

    esperance
end

function proba_loose(gmax, p)
    p_loose = 0.
    for i in 0:(gmax - 1)
        p_loose = p^i * (1 - p)
    end

    p_loose
end

function esperance_pour_gmax_egal_2(p)
    # Soit on fait 1 puis 1 -> 2 * esperance gmax = 1
    # Soit on calcule la proba de faire 2 d'un cout
    # p^2 + p * (1 - p)
    # => proba_1 * proba_1 + proba
end

function esperance_from_0_to_gmax_1_tour(p, gmax, seuil=1e-3)
    esperance = (1. / p) ^ gmax
#     T = 1
#     last_value = seuil + 1.
#     while last_value * T > seuil
#         last_value = p^gmax * (1 - p)^(T - 1) * (1 + p)^(gmax - 1) * binomial(gmax, T)
#         if isnan(last_value) || isinf(last_value)
#             break
#         end
#         esperance += T * last_value
#         T += 1
#     end

    # calculez analytiquement
    return esperance

#     p_loose = proba_loose(gmax, p)
#
#     esperance = 0.
#     T = 0
#     last_value = seuil + 1
#     proba_at_least = []
#     while last_value * (T + 1) > seuil
#         last_value = (1 - p_loose) ^ T * p_loose
#         push!(proba_at_least, last_value)
#         T += 1
#     end
#
#     for index in 1:length(proba_at_least)
#         esperance += index * proba_at_least[index]
#     end
#
#     esperance
end

function compute_optimal_policy(Gmax, p)
    memo = []
    policy = []
    for i in 1:Gmax
        policies = [esperance_from_0_to_gmax_1_tour(p, i)]
        for k in 1:(i - 1)
            push!(policies, memo[k] + memo[i - k])
        end
        push!(memo, min(
            policies...
        ))

        push!(policy, argmin(policies))
    end
    policy, memo
end

function print_optimal_policy(policy_memo)
    policy = policy_memo[1]
    memo = policy_memo[2]
    for j in 1:length(policy)
        i = length(policy) - j + 1
        if policy[i] == 1
            println("Pour Gmax = ", i, ", il jouer tant qu'on a pas atteint ", i, " (Esperance: ", memo[i], ")")
        else
            print("Pour Gmax = ", i, ", il faut jouer la politique optimale de ")
            println(i - policy[i], " et ", policy[i], " (Esperance: ", memo[i], ")")
        end
    end
end



function compute_bellman_recursion(Gmax, p)
    Tmax = 10
    actions = Matrix{Int64}(undef,Tmax,Gmax+1)
    cost = Matrix{Float64}(I,Tmax,Gmax+1)
    probas = Matrix{Float64}(undef,Gmax+1,Gmax+1)
    for k in 1:Tmax
        cost[k,:] = cost[k,:].*0
        actions[k,:] = actions[k,:].*0
    end
    for i in 1:Gmax+1
        for j in 1:Gmax+1
            if i < j
                probas[i,j] = 0
            elseif i > j
                probas[i,j] = p^(j-1) * (1-p)
            elseif i==j
                probas[i,j] = p^(j-1)
            end
        end
    end
    cost[Tmax,:] = cost[Tmax,:] .+ 100000
    cost[Tmax,Gmax+1] = 0
    for ti in 1:(Tmax-1)
        t = Tmax-ti
        Q = Matrix{Float64}(undef,Gmax+1,Gmax+1)
        for state in 0:Gmax
            cost[t,state+1] = 100000
            for action in 0:Gmax
                Q[state+1,action+1] = 0
                for next_state in state:Gmax
                    Q[state+1,action+1] += probas[action+1,next_state-state+1]*(1+cost[t+1,next_state+1])
                end
                if Q[state+1,action+1] < cost[t,state+1]
                    cost[t,state+1] = Q[state+1,action+1]
                    actions[t,state+1] = action
                end
            end
        end
    end
    return actions
end