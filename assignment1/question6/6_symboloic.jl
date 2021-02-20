f=[]
p = [x for x in 0:0.05:1]
for p in p
    local a = []
    for i in 0:10
        push!(a,factorial(20)/(factorial(20-i)*factorial(i)) * p^i * (1-p)^(20-i))
    end
    push!(f,sum(a))
end

println(f)
p_win = [1.0, 1.0, 1.0, 0.999957, 0.999452, 0.996147, 0.98289, 
0.946749, 0.872304, 0.751149, 0.588515, 0.409425, 0.244385, 0.121465, 
0.047903, 0.013719, 0.002549, 0.000243, 5.0e-6, 0.0, 0.0]

println(p_win - f)