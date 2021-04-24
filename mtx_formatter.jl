using CSV, DataFrames, Plots



df = CSV.read("SO.csv", DataFrame, header=false)

SOMatrix = zeros(13,13)

r = 1 
c = 0

for idx in collect(1:12)
    term = r + 12 - ( 1 * (c + 1 ) )
    SO = Array(df[2, r:term])
    SOMatrix[idx, idx+1:(idx+1+(term-r))] = SO

    r_new = term + 1
    c += 1
end 
