
using Random

Random.seed!(3)

n_e = 10^6
p_value = [x for x in 0:0.05:1]
p_br = []
for i in p_value
    local br = 0
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
        if amount <= 0
            # println(amount)
            br += 1
        end
    end
    push!(p_br,br/n_e)
end

begin
    using Plots
    pyplot()
end

print(p_br)
plot(p_value,p_br,marker=3,label="probability")
xlabel!("p/x-axis")
ylabel!("probability for going bankrupt")