EJ = 1
EO = 1
l = 2
p = 10

k = p * [
    EJ/l 0 0 -EO/l 0 0
    0 (12*EJ/l^3) (6*EJ/l^2) 0 (-12*EJ/l^3) (6*EJ/l^2)
    0 (6*EJ/l^2) (4*EJ/l) 0 (-6*EJ/l^2) (2*EJ/l)
    -EJ/l 0 0 -EO/l 0 0
    0 (-12*EJ/l^3) (-6*EJ/l^2) 0 (12*EJ/l^3) (-6*EJ/l^2)
    0 (6*EJ/l^2) (4*EJ/l) 0 (-6*EJ/l^2) (2*EJ/l)
]

f = [-10, 0, -10, 0]
display(k)
println("\n")
u = ((k[2:end, 2:end])[1:end .!=2, 1:end .!=2])
display(u)
println("\n")
u1 = [0, u[1], 0, u[2]]
display(u1)
println("\n")

display(u1 * f)
println("\n")

# @show u2 = [
#     k[2,2] k[2,4]
#     k[4,2] k[4,4]
# ] \ [-10, -10]

# @show [
#     k[1,1] k[1,3]
#     k[3,2] k[3,3]
# ] * u2

println()