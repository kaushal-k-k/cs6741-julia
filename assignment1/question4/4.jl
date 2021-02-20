
using Distributions

D_b = Binomial(8,1/78)

a= [pdf(D_b,x) for x in 2:8]
println("theorotical ",sum(a))

begin
    using Random
    
end
Random.seed!(1)

#  total 72 choices = 26 (A-Z/1-26) + 26 (a-z/27-52) + 10 (0-9/53-62) + 16 (special character/63-78)
choice = 78
p_l = 8
password = [rand(1:choice) for _ in 1:p_l]

n_e = 10^6
hit = 0

for _ in 1:n_e
    global hit
    guess = [rand(1:choice) for _ in 1:p_l]
    if count(x==y for (x,y) in zip(password,guess)) >= 2
        hit += 1
    end
end

println("computational ",hit/n_e)
println("MSE ",abs(sum(a)-hit/n_e))
