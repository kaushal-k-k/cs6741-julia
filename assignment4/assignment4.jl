### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 7d994ad0-ad4c-11eb-1561-9d4edd2fe868
begin
	using Plots
	gr()
end

# ╔═╡ 5a494580-43d3-4b19-87ad-db9403b597ed
begin
	using PlutoUI
	using StatsPlots
	using StatsBase
	using Distributions
	using Random
end

# ╔═╡ 0dd4738b-5d36-46fc-84d6-94e17728bd49
Random.seed!(2)

# ╔═╡ 99c1e703-f192-43b6-9413-a28eec41fbeb
begin
	#question 1
	# 1 head 0 tail
	mcs = 10^6
	trials = 50
	win = 0
	for i in 1:mcs
		head_count = sum(rand(0:1,trials)) 
		if(head_count>=30)
			win += 1
		end
	end
	p = win/mcs
			
end

# ╔═╡ ad23aa8f-f661-4a6b-b4f6-0f66e781c600
# binomial
sum(factorial(big(50))/(factorial(big(i))*factorial(big(50-i))) for i in 30:50) * (1/2)^50

# ╔═╡ 897953aa-26ea-4ea5-bdd6-b0627ea544db
D = Normal(25,3.536)

# ╔═╡ 9d1b2fbf-89e2-4f51-87dc-991360fba703
# taken 29.5 as original distribution is discrete, CLT
1-cdf(D,29.5)

# ╔═╡ 148330ca-16d6-4455-88fe-b70e5e81d850
begin
	# question 2
# 	CLT
	final_p = 0
	for i in 0.5:0.01:1
		if(1-cdf(Normal(50*i,50^(1/2) * (i*(1-i))^(1/2)),29.5) >= 0.5)
			final_p = i
			break
		end
	end
	final_p
end

# ╔═╡ 7bbb4c48-be12-41e6-8620-958d0938df6c
#  monte carlo
begin
	win2 = 0
	mcs2 = 10^6
	trials2 = 50
	for i in 1:mcs2
		head = 0
		for j in 1:trials2
			if(rand() <= final_p)
				head += 1
			end
		end
		if(head >= 30)
			win2 += 1
		end
	end
	p2 = win2/mcs2
end

# ╔═╡ 2d3b60d7-afd1-4d34-83c6-cfcd8b37c280
# binomial
sum(factorial(big(50))/(factorial(big(i))*factorial(big(50-i))) * final_p^i * (1-final_p)^(50-i) for i in 30:50)

# ╔═╡ 158334e1-1051-4a52-a7fd-5455cd75fe4f
begin
	# question 3
	n = 1
	for i in 1:40
		if(1-cdf(Normal(100 * i , 30 * i^(1/2)),3000) >= 0.95)
			n = i
			break
		end
	end
	n
end

# ╔═╡ 3a9dddf1-76d4-4962-8dd7-efdfac6a518b
# considering original distribution as continuous
probability_to_survive = 1-cdf(Normal(100 *n , 30 * n^(1/2)),3000)

# ╔═╡ f14bfec6-8080-43ec-869f-b73625f293af
# question 4
function C(D)
	u = mean(D)
	s = std(D)
	D_n = Normal(0,1)
	for n in 2:500
		samples = []
		for k in 1:10^4
			X = rand(D,n)
			sn = sqrt(n)*s
			X = (X .- u) ./ sn
			push!(samples,X)
		end
		Y = [sum(sample) for sample in samples]
		d1 = abs(mean(Y) - mean(D_n))
		d2 = abs(std(Y) - std(D_n))
		d3 = abs(skewness(Y) - skewness(D_n))
		d4 = abs(kurtosis(Y) - kurtosis(D_n))
		if(d1<=0.1 && d2<=0.1 && d3<=0.1 && d4<=0.1)
			return n , Y
		end
	end
	return -1
end
	

# ╔═╡ 55b4808c-44d7-49bf-b467-1b259e2a3988
begin
	n1,v = C(Uniform(0,1))
	density(v,label = "n ="*string(n1))
	plot!(Normal(0,1))
	
end

# ╔═╡ caa73a03-226d-4ee3-89da-56fe9e810d73
begin
	n2,v2 = C(Binomial(50,0.01))
	density(v2,label = "n ="*string(n2))
	plot!(Normal(0,1))
end

# ╔═╡ 9d2a4a5e-064c-4229-a760-504e4c520b66
begin
	n3,v3 = C(Binomial(50,0.5))
	# histogram(v3,normalize = true,label = "n ="*string(n3))
	density(v3,label = "n ="*string(n3))
	plot!(Normal(0,1))
end

# ╔═╡ f8aa6f8d-d726-43bf-918c-ef880ded25f8
begin
	n4,v4 = C(Chisq(3))
	density(v4,label = "n ="*string(n4))
	plot!(Normal(0,1))
end

# ╔═╡ 31705573-aa18-4639-9433-be0ee9841712
#question 5
D2(k) = Chisq(k)

# ╔═╡ 742d87e0-bdfd-47db-aefe-ca69eefc8efb
begin
	n5 = 0
	for i in 2:100
		if(cdf(D2(i),5) < 0.9)
# 			as we have only 100 tbags so , degree of freedom will be k-1
			n5 = i -1
			break
		end
	end
	n5
end

# ╔═╡ 5b156a4c-a815-416d-97f8-71154363f532
n5/100

# ╔═╡ Cell order:
# ╠═7d994ad0-ad4c-11eb-1561-9d4edd2fe868
# ╠═5a494580-43d3-4b19-87ad-db9403b597ed
# ╠═0dd4738b-5d36-46fc-84d6-94e17728bd49
# ╠═99c1e703-f192-43b6-9413-a28eec41fbeb
# ╠═ad23aa8f-f661-4a6b-b4f6-0f66e781c600
# ╠═897953aa-26ea-4ea5-bdd6-b0627ea544db
# ╠═9d1b2fbf-89e2-4f51-87dc-991360fba703
# ╠═148330ca-16d6-4455-88fe-b70e5e81d850
# ╠═7bbb4c48-be12-41e6-8620-958d0938df6c
# ╠═2d3b60d7-afd1-4d34-83c6-cfcd8b37c280
# ╠═158334e1-1051-4a52-a7fd-5455cd75fe4f
# ╠═3a9dddf1-76d4-4962-8dd7-efdfac6a518b
# ╠═f14bfec6-8080-43ec-869f-b73625f293af
# ╠═55b4808c-44d7-49bf-b467-1b259e2a3988
# ╠═caa73a03-226d-4ee3-89da-56fe9e810d73
# ╠═9d2a4a5e-064c-4229-a760-504e4c520b66
# ╠═f8aa6f8d-d726-43bf-918c-ef880ded25f8
# ╠═31705573-aa18-4639-9433-be0ee9841712
# ╠═742d87e0-bdfd-47db-aefe-ca69eefc8efb
# ╠═5b156a4c-a815-416d-97f8-71154363f532
