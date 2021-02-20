
using Random

Random.seed!(3)

n_e = 10^6
p_value = [x for x in 0:0.05:1]
p_win = []
for i in p_value
    local win = 0
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
            win += 1
        end
    end
    push!(p_win,win/n_e)
end

begin
    using Plots
    pyplot()
end
print(p_win)
plot(p_value,p_win,marker=3,label="probability")
xlabel!("p/x-axis")
ylabel!("probaility of having atleast10 atendof 20days")