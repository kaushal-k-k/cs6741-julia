
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
m_count = 0
# length of database
l_database = 1000
# database
p_database = []

for _ in 1:n_e
    global hit,m_count
    guess = [rand(1:choice) for _ in 1:p_l]
    if count(x==y for (x,y) in zip(password,guess)) >= 2
        hit += 1
        m_count += 1
        if m_count <= l_database
            push!(p_database,guess)
        else
            p_database[(m_count%(l_database))+1]=guess
        end
    end
end

# println("computational ",hit/n_e)
# println("MSE ",abs(sum(a)-hit/n_e))
println("length of database",length(p_database))