using Random

#
Random.seed!(1)
# generating n_e random no 
n_e =1000
a = []
avg = []
for i in 1:n_e
    # using range of integeres as Int32 as it becomes computaionaly high for larger range 
    push!(a,rand(Int32))
    push!(avg,sum(a)/i)
end
begin
    using Plots
    pyplot()
end

plot(1:n_e,avg,label="average")
