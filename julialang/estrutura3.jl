using LinearAlgebra

module AnaliseEstrutura
using LinearAlgebra

function mrig(l::Float64, E::Float64 = 1.0, I::Float64 = 1.0)::Matrix{Float64}
    k = zeros(Float64, 4, 4)

    # I = (0.20 * 0.50^3) / 12.
    # E = 2.1e6

    # k[1, 1] = 12.0
    # k[2, 1] = 6.0 * l
    # k[2, 2] = 4.0 * l^2
    # k[3, 1] = -k[1, 1]
    # k[3, 2] = -k[2, 1] 
    # k[3, 3] = k[1, 1]
    # k[4, 1] = k[2, 1]
    # k[4, 2] = 2.0 * l^2
    # k[4, 3] = -k[2, 1]
    # k[4, 4] = k[2, 2]

    k[1, 1] = 3.0 * E * I / l^3
    # k[1,2] = 3. * E * I / l ^ 2
    # k[1,4] = - 3. * E * I / l ^ 3
    k[2, 1] = 3.0 * E * I / l^2
    k[2, 2] = 3.0 * E * I / l
    # k[2,4] = - 3. * E * I / l ^ 2
    k[4, 1] = -3.0 * E * I / l^3
    k[4, 2] = -3.0 * E * I / l^2
    k[4, 4] = 3.0 * E * I / l^3

    for i in 1:4
        for j in 1:4
            k[i, j] = k[j, i]
        end
    end

    return k
    # return k * ((E * I) / l^3)
end

function pequiv(p::Float64, l::Float64)
    f = zeros(Float64, 4)
    f[1] = 0.5
    f[2] = (p * l) / 12.
    f[3] = f[1]
    f[4] = -f[2]
    return f * (p * l)
end
end

# Coordenadas
c = (1, 2, 3, 4, 5, 6)

# Coordenadas livres
w = (2, 4, 6)
# Coordenadas restringidas
r = c[setdiff(1:end, w)]

e1 = (1, 2, 3, 4)
e2 = (3, 4, 5, 6)

# Matrizes de rigidez dos elementos

k1 = AnaliseEstrutura.mrig(4.35)
k2 = AnaliseEstrutura.mrig(3.0)

# Matriz de rigidez da estrutura
K = zeros(Float64, length(w) + length(r), length(w) + length(r))
K[1:4, 1:4] = k1
K[3:6, 3:6] += k2

println("[K] Matriz de Rigidez da Estrutura")
display(K)
println("\n")

# Deslocamentos da Estrutura
U = zeros(Float64, length(w) + length(r))

#  Matriz reduzida
Kr = K[setdiff(1:end, r), setdiff(1:end, r)]

# Forças da Estrutura
P = zeros(Float64, length(w) + length(r))
P[1:4] = AnaliseEstrutura.pequiv(-1605.0, 4.35)
P[3:6] += AnaliseEstrutura.pequiv(-1444.0, 3.0)

println("[P] Forças da Estrutura")
display(P)
println("\n")

# Forças da Matriz Reduzida
Pr = P[setdiff(1:end, r)]
println("[Pr] Forças da Matriz Reduzida")
display(Pr)
println("\n")

println("[Kr] Matriz de Rigidez da Estrutura Reduzida")
display(Kr)
println("\n")

# Deslocamentos da Estrutura Reduzida
Ur = pinv(Kr) * Pr
U[setdiff(1:end, r)] = Ur

println("[Ur] Deslocamentos da Estrutura Reduzida")
display(Ur)
println("\n")

println("====================")
println("[U] Deslocamentos da Estrutura")
display(U)
println("\n")

println("[k1] Forças do Elemento 1")
_k1 = k1[setdiff(1:end, r), setdiff(1:end, r)]
display(_k1 * U[setdiff(1:end, e2)])
println("\n")

println("[k2] Forças do Elemento 2")
_k2 = k2[setdiff(1:end, r), setdiff(1:end, r)]
display(_k2 * U[setdiff(1:end, e1)])
println("\n")

println("\n")



# def k(l, rotula_inicial, rotula_final, area, inercia, elasticidade):
#     matriz_de_rigidez_local_no_sistema_de_coordenadas_locais = []
#     for _ in range(6):
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais.append([0, 0, 0, 0, 0, 0])
#     matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[0][0] = area * elasticidade / l
#     matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[0][3] = - area * elasticidade / l
#     matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[3][0] = - area * elasticidade / l
#     matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[3][3] = area * elasticidade / l
#     if not rotula_inicial and not rotula_final:
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][1] = 12 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][2] = 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][4] = - 12 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][5] = 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][1] = 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][2] = 4 * elasticidade * inercia / l
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][4] = - 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][5] = 2 * elasticidade * inercia / l
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][1] = - 12 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][2] = - 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][4] = 12 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][5] = - 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][1] = 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][2] = 2 * elasticidade * inercia / l
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][4] = - 6 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][5] = 4 * elasticidade * inercia / l
#     if rotula_inicial and not rotula_final:
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][1] = 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][4] = - 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][5] = 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][1] = - 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][4] = 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][5] = - 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][1] = 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][4] = - 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[5][5] = 3 * elasticidade * inercia / l
#     if not rotula_inicial and rotula_final:
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][1] = 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][2] = 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[1][4] = - 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][1] = 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][2] = 3 * elasticidade * inercia / l
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[2][4] = - 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][1] = - 3 * elasticidade * inercia / l ** 3
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][2] = - 3 * elasticidade * inercia / l ** 2
#         matriz_de_rigidez_local_no_sistema_de_coordenadas_locais[4][4] = 3 * elasticidade * inercia / l ** 3
#     return matriz_de_rigidez_local_no_sistema_de_coordenadas_locais