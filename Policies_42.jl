module Policies_42 #Replace 42 by your groupe number
using ..CantStop # to access function exported from CantStop
include("dices.jl")

"""
You have to define a policy for each question
    (you can reuse code, or even use the same policy for multiple questions
    by copy-pasting)

A policy is a set of two functions with the same name (arguments described later) :

- The first function is called once the dices are thrown.
It take as argument a game_state called gs and an admissible movements set.
It return the index of the admissible movements chosen as an integer.

- The second function is called to choose to stop the turn or continue with a new throw.
It take as argument a game_state and return a boolean: true if you stop, false if you continue.

A admissible movement sets is given as a vector of tuple. Each of the tuple being
an admissible movement offered by the throw.
Eg : adm_movement = [(4),(6,6),(5,7)]. In this case
returning 1 mean that you move your tentative marker on column 4 by 1;
returning 2 mean that you move twice on column 6;
returning 3 mean that you move on 5 and 7.

A game_state is an "object" defined in the module CantStop.
It has the following useful fields
    players_position :: Array{Int,2} # definitive position at start of turn
    tentitative_movement:: Array{Int,1} # tentitative position for active player
    non_terminated_columns :: Array{Int,1} #columns that have not been claimed yet
    nb_player :: Int #number of players in the game
    open_columns :: Array{Int,1} #columns open during this turn (up to 3)
    active_player :: Int #index of active player


For example:
gs.tentitative_movement is a vector of 12 integer.
gs.tentitative[4] is the number of tentitative move done during this turn in column 4.
gs.players_position[i,j] is the position of the definitive marker of player i in column j
gs.open_column = [2,5] means that, during this turn, there is non-null tentitative
movement in column 2 and 5.

Finally you can access the length of column j by column_length[j].
"""
function policy_q1(gs::game_state, adm_movement)
    return 1 #choose the first admissible movement offered
end
function policy_q1(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 2
function policy_q2(gs::game_state, adm_movement)
    return 1
end
function policy_q2(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 3
function policy_q3(gs::game_state, adm_movement)
    return 1
end
function policy_q3(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 4
function policy_q4(gs::game_state, adm_movement)
    return 1
end
function policy_q4(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 5
function policy_q5(gs::game_state, adm_movement)

    return 1
end
function policy_q5(gs::game_state)
    seuil = 0.3
    prob_each_column = zeros(11)
    dist = zeros(11)
    for k in 1:11
        prob_each_column[k] = can_play([k+1])
        dist[k] = gs.players_position[1,k+1] - column_length[k+1]
    end
    I = gs.open_columns
    if sizeof(I) == 2
        return true
    end
    prob_d = proba_dice()
    prob = can_play(I)
    coef1 = proba_coup(prob_d,I[1], I[2], I[3],[dist[I[1]-1],dist[I[2]-1],dist[I[3]-1]])
    coef2 = proba_col_weighted(prob_d,I[1], I[2], I[3],dist)
    sum1 = 0
    sum2 = 0
    for k in 1:11
        if k+1 in I
            sum2 += dist[k]
        else
            sum1 += dist[k]
        end
    end

    prob_to_play = (coef1/sum1)*(coef2/sum2)*prob
    if prob_to_play > seuil
        return true
    end
    return false
end

#Question 6
function policy_q6(gs::game_state, adm_movement)
    return 1
end
function policy_q6(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 7
function policy_q7(gs::game_state, adm_movement)
    return 1
end
function policy_q7(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

#Question 8
function policy_q8(gs::game_state, adm_movement)
    return 1
end
function policy_q8(gs::game_state)
    return (sum(gs.tentitative_movement) > 2)
end

end #end of module
