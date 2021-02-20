
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



#  calclating theoratical probability
using Distributions


# a) without replacement
D_h = Hypergeometric(4,48,5)
p = [pdf(D_h,x) for x in 0:4]
println("theorotical probability for without replacement",p)

# b) with replacement
D_b = Binomial(5,4/52)
p_r = [pdf(D_b,x) for x in 0:5]
println("theorotical prbability for with replacement",p_r)

p1 = plot(0:1:4,j,label="computational",marker=5) 
p2 = plot!(0:1:4,p,label="theorotical",marker=2)

# mean squared error
println("MSE without replacement",(sum( x^2 for x in (j-p))^(1/2))/4)
println("MSE with replacement",(sum( x^2 for x in (jr-p_r))^(1/2))/4) 

p3 = plot(0:1:5,jr,label="computational",marker=5) 
p4 = plot!(0:1:5,p_r,label="theorotical",marker=2)
plot(p2,p4)



