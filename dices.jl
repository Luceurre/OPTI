#=
dices:
- Julia version: 1.5.3
- Author: pl
- Date: 2021-06-18
=#

function compute_proba()
    num_test = 1000000
    results = zeros(11)

    for i in 1:num_test
        dices = rand(1:6, 4)
        values = [
            dices[1] + dices[2],
            dices[3] + dices[4],
            dices[1] + dices[3],
            dices[2] + dices[4],
            dices[1] + dices[4],
            dices[3] + dices[2]
            ]

        for value in unique(values)
            results[value - 1] += 1
        end
    end

    results = results ./ num_test
    for (index, result) in enumerate(results)
        println("Pour ", index + 1, " proba de ", result)
    end
end

function can_play(columns)
    num_test = 10000
    success = 0

    for i in 1:num_test
        dices = rand(1:6, 4)
        values = [
            dices[1] + dices[2],
            dices[3] + dices[4],
            dices[1] + dices[3],
            dices[2] + dices[4],
            dices[1] + dices[4],
            dices[3] + dices[2]
            ]

            for value in unique(values)
            if value in columns
            success +=1
            break
        end
        end

    end
    success / num_test
end

function proba_dice(weights=nothing)
    dice_proba = zeros((11, 11))

    for dice1 in 1:6
        for dice2 in 1:6
            for dice3 in 1:6
                for dice4 in 1:6
                    values = [
                        [dice1 + dice2, dice3 + dice4],
                        [dice1 + dice3, dice2 + dice4],
                        [dice1 + dice4, dice3 + dice2]
                    ]

                    for value in values
                        v1 = value[1]
                        v2 = value[2]

                        dice_proba[v1 - 1, v2 - 1] += 1
                    end
                end
            end
        end
    end
    dice_proba ./ 6^4 / 3
end

function proba_coup(proba_d, i, j, k, weights=nothing)
    # i, j and k must be distinct
    if isnothing(weights)
        weights = ones((3))
    end

    proba_d[i, j] * weights[1] + proba_d[j, i] * weights[2] + proba_d[j, k] * weights[2]
    + proba_d[k, j] * weights[3] + proba_d[i, k] * weights[1] + proba_d[k, i] * weights[3] + proba_d[i, i] * weights[1] + proba_d[j, j] * weights[2]
    + proba_d[k, k] * weights[3]
end

function proba_coup_one_closed(proba_d, i, j)

    proba_d[i, j] * weights + proba_d[j, i] + proba_d[i, i] + proba_d[j, j]
end

function proba_coup_one_open(proba_d, i, j, weights=nothing)
    if isnothing(weights)
        weights = ones((2))
    end

    weights[1] * sum(proba_d[i, :]) + weights[2] * sum(proba_d[j, :])
end

function proba_col_full_open(proba_d, i, weight)
    sum(proba_d[i, :]) * weight
end


function proba_col_weighted(proba_d, i, j, k, weights=nothing)
    if isnothing(weights)
        weights = ones((11))
    end

    p = 0.
    for l in 1:11
        if l == i || l == j || l == k
            continue
        end

        p += proba_col_full_open(proba_d, l, weights[l])
    end

    p
end
