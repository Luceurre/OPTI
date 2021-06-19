function esperance_from_0_to_gmax_1_tour(p, gmax, seuil=1e-3)
    esperance = (1. / p) ^ gmax
    return esperance
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

print_optimal_policy(compute_optimal_policy(10, 0.7))