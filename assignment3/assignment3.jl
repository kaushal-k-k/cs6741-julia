### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ e772d480-8d4e-11eb-3a08-6d09446f9724
begin
	using Plots
	gr()
end

# ╔═╡ e7859930-8d4e-11eb-0d0b-2d2ea16a144a
begin
	using PlutoUI
	using StatsPlots
	using RDatasets
	using StatsBase
	using Distributions
	using LaTeXStrings
	using DataFrames
	using StatsPlots
	using FreqTables
	using QuadGK
end

# ╔═╡ 45957504-a526-465e-949c-abf5e9a49f4d
#question 6
begin
	using Random
	using Dates
	using CSV
end

# ╔═╡ e7a29710-8d4e-11eb-2ca3-4d02628788cc
# question 1
D2(u,s) = Normal(u,s)

# ╔═╡ e7ab49a0-8d4e-11eb-002d-3923275ffa21
D1(v) = TDist(v)

# ╔═╡ e7bbeb70-8d4e-11eb-0a5a-690f421a542c
KL(p,q) = quadgk(x -> pdf(p,x) * log(pdf(p,x)/pdf(q,x)),-4,4...)[1]

# ╔═╡ e7be3560-8d4e-11eb-32be-9b51ff81ace7
begin
	with_terminal() do
		println("v" ,"   ", "divergence")
		for i in [1,2,3,4,5,Inf]
			println(i ," ",KL(D2(0,1),D1(i)))
		end
	end
end

# ╔═╡ e813f680-8d4e-11eb-2281-8792d6ad400f
begin
	# question 2
	D3 = Uniform(0,1)
	l = -5
	h = 8
	ran = 0.01
end

# ╔═╡ 4ab950a3-f228-486a-b400-6360fbbbe6da
conv_(p,q,x) = sum( pdf(p,x-i) * q[i] for i in l:ran:h ) * ran

# ╔═╡ bc61428c-89af-4b3a-be66-d141e340b458
function KL1(p,q)
	s = 0
	for j in l:0.1:h
		if(p[j] > 0 && pdf(q,j) > 0)
			s += log(p[j]/pdf(q,j)) * p[j] 
		end
	end
	return s * ran
end

# ╔═╡ 902e7c33-e72e-49ca-8be9-bc9729f366b0
function pdf_random()
	p = Uniform(0,1)
	pdf_rv = [Dict(j => pdf(p,j) for j in l:ran:h)]
	divergence = []
	for i in 2:10	
		t = Dict(j => conv_(p,pdf_rv[i-1],j) for j in l:ran:h)
		push!(pdf_rv,t)
		f = sum(pdf_rv[i][j] for j in l:ran:h)
		m = sum(pdf_rv[i][j] * j for j in l:ran:h) / f
		s = sum(pdf_rv[i][j] * j^2 for j in l:ran:h)^(1/2) / f
		q = Normal(m,s)
		println(m,s)
		push!(divergence,KL1(pdf_rv[i],q))
	end
	return divergence , pdf_rv
end

# ╔═╡ 94931232-580e-40e5-9da6-8e7d2a0d0262
# function sgn(x,k)
# 	if(x-k >= 0)
# 		return 1
# 	else
# 		return -1
# 	end
# end

# ╔═╡ 9a4e340c-d230-455b-b9df-ceebe25c238b
# cv(x,n) = 0.5/factorial(n-1) * sum((-1)^k * factorial(n)/(factorial(n-k) *factorial(k)) * (x-k)^(n-1) * sgn(x,k)  for k in 0:n)

# ╔═╡ c29cfd52-d97d-4b1c-8aa9-0e9b668f5461
# function pdf_random1()
# 	p = Uniform(0,1)
# 	pdf_rv = [Dict(j => pdf(p,j) for j in l:0.1:h)]
# 	divergence = []
# 	for i in 2:10	
# 		t = Dict(j => cv(j,i) for j in l:0.1:h)
# 		push!(pdf_rv,t)
# 		v = collect(values(pdf_rv[i]))
# 		q = Normal(i/2,i/12)
# 		println(mean(v),std(v))
# 		push!(divergence,KL1(pdf_rv[i],q))
# 	end
# 	return divergence , pdf_rv
# end

# ╔═╡ fff6afac-afe6-4ce4-932e-8ef0ad54884a
begin
	dv , dr = pdf_random()
	p = plot()
	for i in keys(dr)
		plot!(l:ran:h , [dr[i][j] for j in l:ran:h],legend = false)
	end
	# plot!(l:ran:h , [pdf(Normal(1.98,0.63),j) for j in l:ran:h],legend = false)
	p
end

# ╔═╡ 4a772016-2661-439f-9216-8c54cb8791ff
dv

# ╔═╡ f41eb0a4-0b42-434c-b849-82483a63c64e
plot(2:10,dv,label="divegence")

# ╔═╡ e8164070-8d4e-11eb-1c36-dd425eab05c9
# question 3
begin
# 	this a is a right skwed data with mean < median
	a=[0,0,0,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,5,6,7,8,9,10]
	t=copy(a)
	for i in 1:24
	  append!(t,a)
	end
end

# ╔═╡ e82115e0-8d4e-11eb-0aa2-1dbf37ff7dfb
length(t)

# ╔═╡ dcea4e1e-aeb3-4069-8412-f2e2633a5ac3
fq = freqtable(t)

# ╔═╡ e82e0e30-8d4e-11eb-343b-a96dad22ec20
begin
	histogram(t,layoput = (5,5),fillcolor = :black)
	temp31 = convert(Int,ceil(mean(t)))+1
	temp32 = convert(Int,ceil(median(t)))+1
	plot!([mean(t) for i in 1:fq[temp31]],[1:fq[temp31]],lw=0.5,linecolor = :blue,label = "mean " * string(mean(t)))
	plot!([median(t) for i in 1:fq[temp32]],[1:fq[temp32]],lw=0.9,linecolor = :red , label = "median " * string(median(t)) )
end

# ╔═╡ e8386e6e-8d4e-11eb-365f-391f5e850f93
mean(t)

# ╔═╡ e8412100-8d4e-11eb-1c93-4bc9ee744d86
median(t)

# ╔═╡ e84c4490-8d4e-11eb-3d06-d7bd5be9b212
begin
	# question 4
	r = []
	range_(x) = maximum(x) - minimum(x)
	for _ in 1:10000
	  push!(r,range_(rand(D3,30)))
	end
end

# ╔═╡ b82d6e5f-fa36-40ce-b70f-8b523c61258c

nh = fit(Histogram,r,0:0.005:1)

# ╔═╡ 18889533-69b3-4800-86af-78b8fcd34cc8
begin
	lh = length(nh.weights)
	ih = [i for i in 0:0.005:1-0.005]
	nr = [ih[j] for j in 1:lh for i in 1:nh.weights[j] ]
end

# ╔═╡ 4408a6fc-5de2-40c2-aaf7-92e62e211ab4
mean(nr)
	

# ╔═╡ 7889f7e7-df29-427a-9b08-ced18305585a
median(nr)
	

# ╔═╡ b63b296e-b027-42a4-9f2a-e5efb5021e9f
mode(nr)

# ╔═╡ e84f03ae-8d4e-11eb-23cc-3961ad4677ed
begin
	histogram(nr,legend = :topleft,fillcolor=:black)
	temp41 = 500
	temp48 = nh.weights[indexin(mode(nr),ih)][1]
	plot!([mean(nr) for i in 1:temp41] , 1:temp41, lw=2 , label = "mean "*string(mean(nr)))
	plot!([median(nr) for i in 1:temp41] , 1:temp41, lw=3 , label = "median " *string(median(nr)),linecolor = :orange)
	plot!([mode(nr) for i in 1:temp48] , 1:temp48, lw=3 , label = "mode " *string(mode(nr)),linecolor = :green)
end

# ╔═╡ c3b957b4-4da7-4a4f-98b7-c782fa5ea99b
nh.weights[indexin(mode(nr),ih)][1]

# ╔═╡ 96e0b4e7-30c6-4114-875b-6004304686e9
df6 = CSV.read("states.csv",DataFrame)

# ╔═╡ afef13f7-894c-42de-909e-524b842794ef
df61 = select(df6,:Date => ByRow(x -> Dates.year(x)) => :year,:Date => ByRow(x -> Dates.week(x)) => :week,2:3)

# ╔═╡ 1b7f2a4c-18ef-4d94-bf44-c9ab55c8d402
df63 = combine(groupby(df61,[:year,:week,:State]),:Confirmed => sum => :Confirmed_week)

# ╔═╡ 05f197e1-4039-48a2-84d3-48b4b90cedca
df62 = unstack(df63,:State,:Confirmed_week,allowduplicates=true)

# ╔═╡ 4c07449d-a88b-4630-8e92-890048c29981
df62[!,:id] = 1:size(df62)[1]

# ╔═╡ 317efd64-5dbf-46d7-b1dc-f0b6e50661bf
begin
	df64 = select(df62,:id,3:3+length(unique(df61.State)))
	df65 = df64[!,2:ncol(df64)]
end

# ╔═╡ 6d07bbc8-061f-4900-b259-e3e93f26f9c2
function apply(f,df)
	n = ncol(df)
	temp61 = zeros(n,n)
	f=getfield(StatsBase,Symbol(f))
	for (i,c1) in enumerate(eachcol(df))
		for (j,c2) in enumerate(eachcol(df))
			sx , sy = skipmissings(c1,c2)
			if(collect(sx) != [] && collect(sx) != [] )
			 	temp61[i,j] = f(collect(sx),collect(sy))
			end
		end
	end
	return temp61
end

# ╔═╡ 4a43dc59-7c80-4bf1-afc5-d0488a782eff
function plot_hm(h,name)
	st = names(df65)
	# default(size=(2000,800), leg=true)
	hn = heatmap(st,st,h, xtickfont=font(4),ytickfont=font(5),xticks=:all,yticks=:all,dpi=200)
	savefig(hn,name*".png")
end

# ╔═╡ 9a3fac28-7722-489e-b2c2-e6ae312833d8
begin
	hm =apply("cov",df65)
	plot_hm(hm,"cov")	
end

# ╔═╡ ab33980c-07b9-49dc-9ada-b911fc5519ca
begin
	hm1 =apply("cor",df65)
	plot_hm(hm1,"cor")	
end

# ╔═╡ 827310f0-8916-49c2-bda7-3c0f3c63b4a1
begin
	hm2 =apply("corspearman",df65)
	plot_hm(hm2,"corspearman")	
end

# ╔═╡ e8735490-8d4e-11eb-1de5-6fcb5496ec2b
#  question7 
OneSidedTail(p,x) = quantile(p,1-x/100)

# ╔═╡ e887ee00-8d4e-11eb-2031-9774ec31e8fd
begin
	plot(x->x, x->pdf(D2(0,1),x),-5,5)
	plot!(x->x, x->pdf(D2(0,1),x),-5,OneSidedTail(D2(0,1),95),fill= (0,:orange))
end

# ╔═╡ 0ec26c4d-5306-4d22-af4c-440291180a32
begin
	default(size=(600,400))
	plot(x->x, x->pdf(D1(10),x),-5,5)
	plot!(x->x, x->pdf(D1(10),x),-5,OneSidedTail(D2(0,1),95),fill= (0,:orange))
end

# ╔═╡ Cell order:
# ╠═e772d480-8d4e-11eb-3a08-6d09446f9724
# ╠═e7859930-8d4e-11eb-0d0b-2d2ea16a144a
# ╠═e7a29710-8d4e-11eb-2ca3-4d02628788cc
# ╠═e7ab49a0-8d4e-11eb-002d-3923275ffa21
# ╠═e7bbeb70-8d4e-11eb-0a5a-690f421a542c
# ╠═e7be3560-8d4e-11eb-32be-9b51ff81ace7
# ╠═e813f680-8d4e-11eb-2281-8792d6ad400f
# ╠═4ab950a3-f228-486a-b400-6360fbbbe6da
# ╠═bc61428c-89af-4b3a-be66-d141e340b458
# ╠═902e7c33-e72e-49ca-8be9-bc9729f366b0
# ╠═94931232-580e-40e5-9da6-8e7d2a0d0262
# ╠═9a4e340c-d230-455b-b9df-ceebe25c238b
# ╠═c29cfd52-d97d-4b1c-8aa9-0e9b668f5461
# ╠═fff6afac-afe6-4ce4-932e-8ef0ad54884a
# ╠═4a772016-2661-439f-9216-8c54cb8791ff
# ╠═f41eb0a4-0b42-434c-b849-82483a63c64e
# ╠═e8164070-8d4e-11eb-1c36-dd425eab05c9
# ╠═e82115e0-8d4e-11eb-0aa2-1dbf37ff7dfb
# ╠═dcea4e1e-aeb3-4069-8412-f2e2633a5ac3
# ╠═e82e0e30-8d4e-11eb-343b-a96dad22ec20
# ╠═e8386e6e-8d4e-11eb-365f-391f5e850f93
# ╠═e8412100-8d4e-11eb-1c93-4bc9ee744d86
# ╠═e84c4490-8d4e-11eb-3d06-d7bd5be9b212
# ╠═b82d6e5f-fa36-40ce-b70f-8b523c61258c
# ╠═18889533-69b3-4800-86af-78b8fcd34cc8
# ╠═4408a6fc-5de2-40c2-aaf7-92e62e211ab4
# ╠═7889f7e7-df29-427a-9b08-ced18305585a
# ╠═b63b296e-b027-42a4-9f2a-e5efb5021e9f
# ╠═e84f03ae-8d4e-11eb-23cc-3961ad4677ed
# ╠═c3b957b4-4da7-4a4f-98b7-c782fa5ea99b
# ╠═45957504-a526-465e-949c-abf5e9a49f4d
# ╠═96e0b4e7-30c6-4114-875b-6004304686e9
# ╠═afef13f7-894c-42de-909e-524b842794ef
# ╠═1b7f2a4c-18ef-4d94-bf44-c9ab55c8d402
# ╠═05f197e1-4039-48a2-84d3-48b4b90cedca
# ╠═4c07449d-a88b-4630-8e92-890048c29981
# ╠═317efd64-5dbf-46d7-b1dc-f0b6e50661bf
# ╠═6d07bbc8-061f-4900-b259-e3e93f26f9c2
# ╠═4a43dc59-7c80-4bf1-afc5-d0488a782eff
# ╠═9a3fac28-7722-489e-b2c2-e6ae312833d8
# ╠═ab33980c-07b9-49dc-9ada-b911fc5519ca
# ╠═827310f0-8916-49c2-bda7-3c0f3c63b4a1
# ╠═e8735490-8d4e-11eb-1de5-6fcb5496ec2b
# ╠═e887ee00-8d4e-11eb-2031-9774ec31e8fd
# ╠═0ec26c4d-5306-4d22-af4c-440291180a32
