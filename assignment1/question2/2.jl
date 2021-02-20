using Random
Random.seed!(2)
# four jacks
jack = ["j1","j2","j3","j4"]
# suit 
suit = [string(i) for i in 1:48] 
append!(suit,jack)

n_e = 10^5

# a) without replacement
j = zeros(5)
for _ in 1:n_e
    t = copy(suit)
    # print(t)
    c_j = 0
    for _ in 1:5
        c = rand(t)
        deleteat!(t,findfirst(x -> x == c,t))
        # print(t)
        if c in jack
            c_j += 1
        end
    end
    j[c_j+1]+=1
end

# 
begin
    using Plots
    pyplot()
end 
# take avg i.e probability
j=j/n_e
println("without replacement the computaional probability is \t",j)

# 
begin
    plot(0:1:4,j,label="without replacement",marker=3)    
end

# b) with replacement
jr = zeros(6)

for _ in 1:n_e
    jr[count([rand(suit) in jack for _ in 1:5])+1] += 1 
end
# 

# take avg i.e probability
jr=jr/n_e

println("with replacement the computational probability is \t",jr)
# 
begin
    # histogram(0:4,j)
    plot!(0:1:5,jr,label="with replacement",marker=3)    
end
