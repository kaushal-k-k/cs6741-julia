
using Random

Random.seed!(3)

n_e = 10^7
p_value = [x for x in 0:0.05:1]
p_ab = []

for i in p_value
    local ab = 0
    local n_invalid = 0
    # print(n_e)
    for _ in 1:n_e
        amount = 10
        for _ in 1:20
            if rand() <= i
                amount -= 1
            else
                amount += 1
            end
        end
        if amount >= 10
            # println(amount)
            ab += 1
        end

        if amount <= 0
            n_invalid += 1
        end
    end
    if ab == 0
        push!(p_ab,0)
    else
        push!(p_ab,ab/(n_e-n_invalid))
    end
end

begin
    using Plots
    pyplot()
end

println(p_ab)
plot(p_value,p_ab,marker=7,label="probability")

p_br = [0.0, 0.0, 0.0, 0.0, 1.0e-6, 5.0e-6, 3.6e-5, 0.000323, 0.00162, 
0.006417, 0.020774, 0.05538, 0.125556, 0.246304, 0.416075, 0.616643, 0.804634, 
0.932731, 0.988587, 0.999678, 1.0]

p_win = [1.0, 1.0, 1.0, 0.999957, 0.999452, 0.996147, 0.98289, 
0.946749, 0.872304, 0.751149, 0.588515, 0.409425, 0.244385, 0.121465, 
0.047903, 0.013719, 0.002549, 0.000243, 5.0e-6, 0.0, 0.0]

p_q = []
for (x,y) in zip(p_win,p_br)
    if x == 0
        push!(p_q,x)
    else
        push!(p_q, x/(1-y))
    end
end

println(p_q)



plot!(p_value,p_q,marker=2,label="using previous question probabilities")
xlabel!("p/x-axis")
ylabel!("required probability")
