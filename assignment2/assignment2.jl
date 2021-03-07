### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ b48c0a70-7e42-11eb-3b59-eb8b32410d22
begin
	using DataFrames
	using Random
	using Dates
	using HTTP
	using JSON
end

# ╔═╡ 92d891d0-7e67-11eb-1620-a3fe325f1aa6
begin
	using Plots
	pyplot()
end

# ╔═╡ 69040bb0-7e48-11eb-3610-cd0499cc95c8
# question 1

# ╔═╡ f7261250-7e46-11eb-2188-2907e44f8499

df = DataFrame(
	religion = ["a","b","c"] , 
	k10 = [23,34,56] ,
	k10k20 = [12,23,34] ,
	k20k30 = [45,11,23],
	k50 = [34,14,42]
)

# ╔═╡ f89a14b0-7e46-11eb-2a8a-93d4fe471cb3
begin
	n_df = DataFrame(religion = String[] , income = String[] , fre = Int[])
	t = names(df)
	l = length(t)
	for row in eachrow(df)
		# for each column push a entry
		for j in 2:l
			push!(n_df,(row[1],t[j],row[j]))
		end
	end
	n_df
# 	or we could obtain the same outcome by using "stack(df,[:k10,:k10k20,:k20k30,:k50])" + column name change operation
end

# ╔═╡ 724239de-7e48-11eb-2a98-c51a9fad0d8b
# question 2

# ╔═╡ ecd75b50-7e42-11eb-2181-fd6f0c95e42d

df2 = DataFrame(id = String[] , year = Int[] , month = Int[] , element = String[])

# ╔═╡ 0492cbd0-7e43-11eb-25e6-c36810e6e538
begin
	for i in 1:31
		col_name = *("d", string(i))
		df2[!,col_name] = [Any(missing) for i in 1:size(df2,1)]
	end
	# dd = [Any(Missing) for i in 1:31]
end

# ╔═╡ 0bfa1720-7e43-11eb-259e-f1d3093cbe64
begin
	dd = Union{Missing , Int}[missing for i in 1:31]
	# println(typeof(dd))
	for i in 1:4
		temp = ["MX004",rand(2000:2010),rand(1:12)]
		temp1 = copy(temp)
		dd1 = copy(dd)
		dd2 = copy(dd)
		
		for j in 1:rand(1:5)
			r = rand(1:31)
			dd1[r] = rand(20:30)
			dd2[r] = rand(1:10)
		end
	
		append!(append!(temp,["tmax"]),dd1)
		append!(append!(temp1,["tmin"]),dd2)
		push!(df2,temp)
		push!(df2,temp1)
		
		if i == 1
			temp = ["MX004",rand(2000:2010),rand(1:12)]
			temp1 = copy(temp)
			append!(append!(temp,["tmax"]),dd)
			append!(append!(temp1,["tmin"]),dd)
			push!(df2,temp)
			push!(df2,temp1)
			
		end
		
	end
	
end

# ╔═╡ 0e386e60-7e43-11eb-21e9-894a23365433
# 3 and 4 th entry contains only missing values so in the new table that will not be present
df2

# ╔═╡ 1ce30240-7e43-11eb-3cc6-533878e37cce
n_df2 = DataFrame( id = String[] , date = Date[] , tmax = Float64[] , 
	tmin = Float64[])

# ╔═╡ 224d1e00-7e43-11eb-0522-c56e24e67eff
for i in 1:2:size(df2,1)
	
	day = Missing
	max = Missing
	min = Missing
	for j in 5:size(df2,2)
		if df2[i,j] !== missing && df2[i+1,j] !== missing
			day = j-4
			max = df2[i,j]
			min = df2[i+1,j]
			date = Dates.Date(df2[i,2],df2[i,3],day)
			temp3 = []
			push!(temp3,df2[i,1])
			push!(temp3,date)
			append!(temp3,[max,min])
			println(temp3)
			push!(n_df2,temp3)
		end
	end
end
	

# ╔═╡ 2add0ad0-7e43-11eb-1bc9-438e5440bd38
n_df2

# ╔═╡ 5e5c1450-7e48-11eb-3132-0bc8e72e1c6f
# question 3

# ╔═╡ 652dfd70-7e48-11eb-08e1-c5ed0d046ed0
begin
	year_3 = [2000 for i in 1:6]
	artist_3 = ["2pac" ,"2pac","2pac","3gen","3gen","becky"]
	time_3 = ["4:3" ,"4:3","4:3","3:4","3:4","1:2"]
	track_3 = ["baby" ,"baby","baby","hey","hey","on"]
	date_3 = [Dates.Date(2000,01,i) for i in 1:6]
	week_3 = [1,2,3,1,2,1]
	rank_3 = [90,80,70,80,50,45]
	df3 = DataFrame(year = year_3 , artist = artist_3 ,track = track_3 , time = time_3 		, date = date_3 , week = week_3, rank = rank_3)
	
end

# ╔═╡ 7526112e-7e4e-11eb-064f-d1661364e001
begin
	temp_31 = unique(select(df3 , [:artist,:track,:time]))
# 	tidy part 1 table
	insertcols!(temp_31 , 1 , :id => 1:size(temp_31,1),makeunique = true)
end

# ╔═╡ 7d360652-7e53-11eb-2d59-df1a5c3d7774
# tidy part 2 table
select(innerjoin(temp_31,df3, on = [:track,:artist],makeunique = true),
	[:id , :date , :rank])


# ╔═╡ a198cb30-7e54-11eb-335c-bf8b3aa95dd1
# question 4

# ╔═╡ a8d3af50-7e54-11eb-39c7-3f0d9c675fe0
begin
	get_data = HTTP.request("GET","https://api.covid19india.org/data.json")
	get_data = get_data.body
end

# ╔═╡ cf1facf0-7e5d-11eb-031c-fd3829efed14
temp_41 = JSON.Parser.parse(String(get_data))

# ╔═╡ 0d0e00b0-7e5a-11eb-15e2-2f37a5781d84
begin
# 	keys(temp_41["cases_time_series"][0])
	df4 = DataFrame(dateymd = Date[] , date = String[] , dailyconfirmed = Int[] , dailydeceased = Int[] , dailyrecovered = Int[] , totalconfirmed = Int[] , totaldeceased = Int[] , totalrecovered = Int[] )
	
	date_format = DateFormat("y-m-d")
	for i in temp_41["cases_time_series"]
		push!(df4 , [Date(i["dateymd"],date_format),
				i["date"] ,
				 parse(Int64,i["dailyconfirmed"]),
				 parse(Int64,i["dailydeceased"]),
				 parse(Int64,i["dailyrecovered"]),
				 parse(Int64,i["totalconfirmed"]),
				 parse(Int64,i["totaldeceased"]),
				 parse(Int64,i["totalrecovered"])])
	end
end

# ╔═╡ 0bc9b220-7e60-11eb-14ef-213cf5da8e92
df4

# ╔═╡ 3a61f2f0-7e60-11eb-32a6-2d7a6a925a9b
begin
	
	temp_42 = select(df4,:dateymd => ByRow(x -> Dates.yearmonth(x)) => 		:year_month,:dailyconfirmed,:dailydeceased,:dailyrecovered)
	
	temp_43 = groupby(temp_42,:year_month)
	
# 	aggregate no of confirmed, deceased and recovered cases for each month
	combine(temp_43,:dailyconfirmed => sum => :monthlyconfirmed,
		:dailydeceased => sum => :monthlydeceased , 
		:dailyrecovered => sum => :monthlyrecovered)
	
	
end

# ╔═╡ 525f4a40-7e67-11eb-1c63-cb81fa0a67a4
# question 5

# ╔═╡ 6738c922-7e6a-11eb-3cb8-254893b18905
no_of_days = 7

# ╔═╡ e824da80-7e68-11eb-30dd-3d78352f3503
begin
	
	p1 = plot(1:size(df4,1) , df4.dailyconfirmed , label = "original values")
	xlabel!("no of days")
	ylabel!("no of confirmed cases")
	p2 = plot(1:size(df4,1) ,
		append!(Union{Missing,Float64}[missing for i in 1:no_of_days-1],
		[sum(df4.dailyconfirmed[i:i+no_of_days-1])/no_of_days for i in 1:size(df4,1)-no_of_days+1]) , 
		label = "smoothened values")
	xlabel!("no of days")
	ylabel!("no of confirmed cases by moving avg")
	plot(p1,p2,legend = false)
end

# ╔═╡ c68465c0-7e6e-11eb-28c2-511c41f98d68
begin
	
	p3 = plot(1:size(df4,1) , df4.dailydeceased , label = "original values")
	xlabel!("no of days")
	ylabel!("no of deceased cases")
	p4 = plot(1:size(df4,1) , 
		append!(Union{Missing,Float64}[missing for i in 1:no_of_days-1],
		[sum(df4.dailydeceased[i:i+no_of_days-1])/no_of_days for i in 1:size(df4,1)-no_of_days+1]) , 
		label = "smoothened values")
	xlabel!("no of days")
	ylabel!("no of deceased cases by moving avg")
	plot(p3,p4,legend = false)
end

# ╔═╡ d8707392-7e6f-11eb-0795-8f4e22454a35
begin
	
	p5 = plot(1:size(df4,1) , df4.dailyrecovered , label = "original values")
	xlabel!("no of days")
	ylabel!("no of recovered cases")
	
	p6 = plot(1:size(df4,1) ,
	append!(Union{Missing,Float64}[missing for i in 1:no_of_days-1],
	[sum(df4.dailyrecovered[i:i+no_of_days-1])/no_of_days for i in 1:size(df4,1)-no_of_days+1]) , 
		label = "smoothened values")
	xlabel!("no of days")
	ylabel!("no of recovered cases by moving avg")
	
	plot(p5,p6,legend = false)
end

# ╔═╡ Cell order:
# ╠═b48c0a70-7e42-11eb-3b59-eb8b32410d22
# ╠═69040bb0-7e48-11eb-3610-cd0499cc95c8
# ╠═f7261250-7e46-11eb-2188-2907e44f8499
# ╠═f89a14b0-7e46-11eb-2a8a-93d4fe471cb3
# ╠═724239de-7e48-11eb-2a98-c51a9fad0d8b
# ╠═ecd75b50-7e42-11eb-2181-fd6f0c95e42d
# ╠═0492cbd0-7e43-11eb-25e6-c36810e6e538
# ╠═0bfa1720-7e43-11eb-259e-f1d3093cbe64
# ╠═0e386e60-7e43-11eb-21e9-894a23365433
# ╠═1ce30240-7e43-11eb-3cc6-533878e37cce
# ╠═224d1e00-7e43-11eb-0522-c56e24e67eff
# ╠═2add0ad0-7e43-11eb-1bc9-438e5440bd38
# ╠═5e5c1450-7e48-11eb-3132-0bc8e72e1c6f
# ╠═652dfd70-7e48-11eb-08e1-c5ed0d046ed0
# ╠═7526112e-7e4e-11eb-064f-d1661364e001
# ╠═7d360652-7e53-11eb-2d59-df1a5c3d7774
# ╠═a198cb30-7e54-11eb-335c-bf8b3aa95dd1
# ╠═a8d3af50-7e54-11eb-39c7-3f0d9c675fe0
# ╠═cf1facf0-7e5d-11eb-031c-fd3829efed14
# ╠═0d0e00b0-7e5a-11eb-15e2-2f37a5781d84
# ╠═0bc9b220-7e60-11eb-14ef-213cf5da8e92
# ╠═3a61f2f0-7e60-11eb-32a6-2d7a6a925a9b
# ╠═525f4a40-7e67-11eb-1c63-cb81fa0a67a4
# ╠═92d891d0-7e67-11eb-1620-a3fe325f1aa6
# ╠═6738c922-7e6a-11eb-3cb8-254893b18905
# ╠═e824da80-7e68-11eb-30dd-3d78352f3503
# ╠═c68465c0-7e6e-11eb-28c2-511c41f98d68
# ╠═d8707392-7e6f-11eb-0795-8f4e22454a35
