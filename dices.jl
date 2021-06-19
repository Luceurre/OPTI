#=
dices:
- Julia version: 1.5.3
- Author: pl
- Date: 2021-06-18
=#
module dices
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

end