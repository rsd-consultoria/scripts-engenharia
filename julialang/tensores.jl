@info "Análise Estrutural"
# Matriz de rigidez dos elementos
k1 = [300  -300
    -300   300]

k2 = [
    600  -600
    -600   600
]

k3 = [
    800  -800
    -800   800
]

k4 = [
    500  -500
    -500   500
]

k5 = [
    600  -600
    -600   600
]

k6 = [
    800  -800
    -800   800
]

# Vetor de forças aplicadas nos Nós
f =[0, 500, 500, 600, 1000, 0]
# Vetor de deslocamentos nodais
u = [0, 0, 0, 0, 0, 2]

# Nós
A = 1
B = 2
C = 3
D = 4
E = 5
F = 6

# Relacionamento entre elementos e nós
ak1 = [[A,A], [A,B], [B,A], [B,B]]
ak2 = [[B,B], [B,C], [C,B], [C,C]]
ak3 = [[B,B], [B,D], [D,B], [D,D]]
ak4 = [[B,B], [B,E], [E,B], [E,E]]
ak5 = [[D,D], [F,D], [D,F], [F,F]]
ak6 = [[E,E], [E,F], [F,E], [F,F]]

# Matriz de rigidez global
k = zeros(6, 6)

# Mapeia a matriz de rigidez local com a matriz de rigidez global
function mapear(a, b)
    l = 1
    for i in 1:2
        for j in 1:2
            k[a[l][1,1],a[l][2,1]] += b[i, j]
            l+=1
        end
    end
end

# Monta matriz de rigidez global
mapear(ak1, k1)
mapear(ak2, k2)
mapear(ak3, k3)
mapear(ak4, k4)
mapear(ak5, k5)
mapear(ak6, k6)

# Resolve sistema de equações para achar os deslocamentos nodais
# é retirada da matriz a linha e coluna correspondente ao nó que não tem deslocamento
@show _k = (k[1:end .!=A, 1:end .!=A])[1:end .!=E, 1:end .!=E] \ (f[1:end .!=A])[1:end .!=E]
