using Printf
"""
Funções para Análise de Pórtico Espacial

Sistema de Coordenadas

* X = Horizontal, positivo para direita
* Y = Vertical, positivo para cima
* Z = Horizontal, positivo para direita

"""
module PorticoEspacial

"""Constrói matriz de transformação do elemento"""
function matriztransformacao(noinicial::Vector{Float64}, nofinal::Vector{Float64}, gama::Float64 = 1.0)::Matrix{Float64}
    Tr::Matrix{Float64} = zeros(3, 3)
    TrAux::Matrix{Float64} = zeros(3, 3)
    Cx = (nofinal[1] - noinicial[1])
    Cy = (nofinal[2] - noinicial[2])
    Cz = (nofinal[3] - noinicial[3])
    L = sqrt(sqrt(Cx) + sqrt(Cy) + sqrt(Cz))
    Cx /= L
    Cy /= L
    Cz /= L
    cosBeta = sqrt(sqrt(Cx) + sqrt(Cz))
    sinBeta = Cy

    if cosBeta > 0.0
        cosAlfa = Cx / cosBeta
        sinAlfa = Cz / cosBeta
    else
        cosAlfa = 1.0
        sinAlfa = 0.0
    end

    cosGama = cos(gama)
    sinGama = sin(gama)

    Tr[1, 1] = cosAlfa
    Tr[1, 3] = sinBeta
    Tr[2, 2] = 1.0
    Tr[3, 1] = -sinAlfa
    Tr[3, 3] = cosAlfa

    TrAux[1, 1] = cosBeta
    TrAux[1, 2] = sinBeta
    TrAux[2, 1] = -sinBeta
    TrAux[2, 2] = cosBeta
    TrAux[3, 3] = 1.0
    Tr = TrAux * Tr

    TrAux[1, 1] = 1.0
    TrAux[2, 2] = cosGama
    TrAux[2, 3] = sinGama
    TrAux[3, 2] = -sinGama
    TrAux[3, 3] = cosGama
    Tr = TrAux * Tr

    return Tr
end

"""Constrói matriz de rotação da barra"""
function matrizrotacaoespacial(Tr::Matrix{Float64})::Matrix{Float64}
    rotBar::Matrix{Float64} = zeros(12, 12)

    m = 0
    for _ in 1:4
        for i in 1:3
            for j in 1:3
                rotBar[m+i, m+j] = Tr[i, j]
            end
        end
        m += 3
    end

    return rotBar
end

"""Inclui articulação na matriz de rigidez do elemento"""
function addarticulacao(matrizrigidez::Matrix{Float64})::Matrix{Float64}
    return nothing
end

"""Constrói matriz de rigidez local"""
function matrizrigidezlocal(noinicial::Vector{Float64}, nofinal::Vector{Float64})::Matrix{Float64}
    return nothing
end

"""Constrói matriz de rigidez global"""
function matrizrigidezglobal(matrizrigidezlocal::Matrix{Float64})::Matrix{Float64}
    return nothing
end

"""Constrói vetor apontador"""
function vetorapontador()::Vector{Float64}
    return nothing
end

"""Constrói matriz de rigidez da estrutura"""
function matrizrigidezestrutura()::Matrix{Float64}
    return nothing
end

"""Verifica condições de contorno"""
function condicoesgeometricascontorno() end

"""Entry point para executar a análise"""
function execute()
    # Carregar Materiais
    # Configurar propriedades das seções
    # Carregar coordenadas nodais
    # Carregar Elementos
    # Carregar apoios
    # Carregar Cargas

    vetorapontador()
    matrizrigidezestrutura()
    condicoesgeometricascontorno()
    # Resolver sistema de equações
end
end



println("========================================== ANÁLISE DE ESTRUTURAS ==========================================\n")
println("1. Cargas\n")
println("2. Ações\n")
println("3. Deslocamentos Iniciais\n")
println("4. Matrizes de Rigidez Locais\n")
println("5. Matriz de Rigidez Global\n")

println()
println("=============================================== RESULTADO =================================================\n")
println("1. Materiais\n")
println("ID       Módulo E   Módulo G   Densidade")
println("-------- ---------- ---------- ----------")

@printf "%s % 10.6f % 10.2f % 10.2f\n" "CONCR20M" 123E-6 3.4 2345.45
@printf "%s % 10.6f % 10.2f % 10.2f\n" "CONCR30M" 123E-6 3.4 2345.45
@printf "%s % 10.6f % 10.2f % 10.2f\n" "CONCR40M" 123E-6 3.4 2345.45
println()
println()
println("2. Elementos\n")

println("ID        Material Comprimento  Área Seção   Nó Inicial Nó Final   Anotação")
println("--------- -------- ------------ ------------ ---------- ---------- ----------------------------------------")
@printf "%s %s % 12.2f % 12.2f %s %s\n" "V101     " "CONCR40M" 12.34 12.34 "NO00000001" "NO00000002"
@printf "%s %s % 12.2f % 12.2f %s %s\n" "V101     " "CONCR40M" 12.34 12.34 "NO00000001" "NO00000002"
@printf "%s %s % 12.2f % 12.2f %s %s\n" "V101     " "CONCR40M" 12.34 12.34 "NO00000001" "NO00000002"
@printf "%s %s % 12.2f % 12.2f %s %s\n" "V101     " "CONCR40M" 12.34 12.34 "NO00000001" "NO00000002"

println()
println("NO00000001                                             NO00000002")
println("----------------------------------------------------   ----------------------------------------------------")
@printf "X1: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m   X2: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Y1: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m   Y2: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Z1: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m   Z2: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
println()

println("NO00000001                                             NO00000002")
println("----------------------------------------------------   ----------------------------------------------------")
@printf "X1: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m   X2: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Y1: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m   Y2: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Z1: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m   Z2: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
println()

println("NO00000001                                             NO00000002")
println("----------------------------------------------------   ----------------------------------------------------")
@printf "X1: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m   X2: % 8.2f m  Fx: % 8.2f kgf  Mx: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Y1: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m   Y2: % 8.2f m  Fy: % 8.2f kgf  My: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56
@printf "Z1: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m   Z2: % 8.2f m  Fz: % 8.2f kgf  Mz: % 8.2f kgf.m\n" 12.34 1234.56 1234.56 12.34 1234.56 1234.56


println()