using Base: Float64, Float16
mutable struct Deslocamento
    x::Float64
    y::Float64
    rotz::Float64
end

mutable struct Acao
    x::Float64
    y::Float64
    rotz::Float64
end

mutable struct No
    x::Float64
    y::Float64
    acao::Acao
    deslocamento::Deslocamento
end

mutable struct Elemento
    id::String
    noInicial::No
    noFinal::No
    Area::Float64
    I::Float64
    E::Float64
    G::Float64
    v::Float64
end

mutable struct Estrutura
    elementos::Array{Elemento}
end

function aplicarAcaoNoElemento(elemento::Elemento, x::Float64, y::Float64, acao::Acao)
    if (elemento.noInicial.x == x && elemento.noInicial.y == y)
        elemento.noInicial.acao = acao
    elseif (elemento.noFinal.x == x && elemento.noFinal.y == y)
        elemento.noFinal.acao = acao
    elseif (elemento.noInicial.x == x || elemento.noFinal.x == x || elemento.noInicial.y == y || elemento.noFinal.y == y)
        # Distribuir a ação entre os nós
    else
        @error "Não foi possível distribuir a ação entre os nós do elemento $(elemento.id)"
    end
end

function montarMatrizRigidez2(elemento::Elemento)::Array{Float64}
    AE = 1.0 #elemento.Area * elemento.E
    EI = 1.0 #elemento.E * elemento.I
    l1 = sqrt(abs((elemento.noFinal.x - elemento.noInicial.x)^2 + (elemento.noFinal.y - elemento.noInicial.y)^2)) * 12
    return [
        (4*EI)/l1 (2*EI)/l1 (6*EI)/l1^2 -(6 * EI)/l1^2 0 0
        (2*EI)/l1 (4*EI)/l1 (6*EI)/l1^2 -(6 * EI)/l1^2 0 0
        (6*EI)/l1^2 (6*EI)/l1^2 (12*EI)/l1^3 -(12 * EI)/l1^3 0 0
        -(6 * EI)/l1^2 -(6 * EI)/l1^2 -(12 * EI)/l1^3 (12*EI)/l1^3 0 0
        0 0 0 0 (AE)/l1 -(AE)/l1
        0 0 0 0 -(AE)/l1 (AE)/l1
    ]
end

function montarMatrizRigidez(elemento::Elemento)::Array{Float64}
    AE = 0.72e6 #elemento.Area * elemento.E
    EI = 24e6 #elemento.E * elemento.I
    comprimento = sqrt(abs((elemento.noFinal.x - elemento.noInicial.x)^2 + (elemento.noFinal.y - elemento.noInicial.y)^2))
    matriz = zeros(Float64, 6, 6)
    matriz[1, 1] = (elemento.Area * comprimento^2) / elemento.I
    matriz[2, 2] = 12.0
    matriz[3, 2] = 6.0 * comprimento
    matriz[3, 3] = 4.0 * comprimento^2
    matriz[4, 1] = -matriz[1, 1]
    matriz[4, 4] = matriz[1, 1]
    matriz[5, 2] = -matriz[2, 2]
    matriz[5, 3] = -matriz[3, 2]
    matriz[5, 5] = matriz[2, 2]
    matriz[6, 2] = matriz[3, 2]
    matriz[6, 3] = 2.0 * comprimento^2
    matriz[6, 5] = -matriz[3, 2]
    matriz[6, 6] = matriz[3, 3]

    for i in 1:6
        for j in 1:6
            matriz[i, j] = matriz[j, i]
        end
    end

    return matriz
end

elemento1 = Elemento("V1", No(0, 0, Acao(0, 0, 0), Deslocamento(0, 0, 0)), No(5, 0, Acao(0, 0, 0), Deslocamento(0, 0, 0)), 1, 1, 1.0, 1, 1)
elemento2 = Elemento("V2", No(5, 0, Acao(0, 0, 0), Deslocamento(1, 0, 0)), No(11, 0, Acao(0, 0, 0), Deslocamento(1, 0, 0)), 1, 1, 1.0, 1, 1)
elemento3 = Elemento("V3", No(11, 0, Acao(0, 0, 0), Deslocamento(1, 0, 0)), No(15, 0, Acao(0, 0, 0), Deslocamento(1, 0, 0)), 1, 1, 1.0, 1, 1)
estrutura = Estrutura([elemento1, elemento2, elemento3])

a = montarMatrizRigidez(elemento1)
b = montarMatrizRigidez(elemento2)
c = montarMatrizRigidez(elemento3)

println("\nElemento $(elemento1.id)")
display(a)
println("\nElemento $(elemento2.id)")
display(b)
println("\nElemento $(elemento3.id)")
display(c)
println()

matrizRigidez = zeros(12, 12)
matrizRigidez[1:6, 1:6] += a
matrizRigidez[4:9, 4:9] += b
matrizRigidez[7:12, 7:12] += b

println()
println("\nMatriz de Rigidez Global")
display(matrizRigidez)

println()