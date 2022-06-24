using Printf
using LinearAlgebra

# ============ Código do livro
# # Tipos
# mutable struct TCoord
#     X::Float64
#     Y::Float64
#     Z::Float64
# end

# mutable struct TElemento
#     Nome::String
#     Ndn::Vector{Int64}
#     NroDaPropriedade::Int64
#     NroDaMaterial::Int64
#     NroDeArticulacoes::Int64
#     Gama::Float64
#     AsArticulacoes::Vector{Int64}
# end

# mutable struct TMaterial
#     Nome::String
#     Elasticidade::Float64
#     Poisson::Float64
#     PesoEspecifico::Float64
#     MassaEspecifica::Float64
# end

# mutable struct TPropriedade
#     AreaX::Float64
#     AreaY::Float64
#     AreaZ::Float64
#     InerciaX::Float64
#     InerciaY::Float64
#     InerciaZ::Float64
# end

# mutable struct TApoio
#     NroDoNo::Int64
#     Restricoes::Vector{String}
# end

# # Constantes
# const Zero = 1.E-5
# const NDesNo = Int64(6)
# const NNoElem = Int64(2)
# const NumeroGrandeReferencia = 1.e30

# # Variaveis globais
# global Coord = Vector{TCoord}()
# global Elemento = Vector{TElemento}()
# global Material = Vector{TMaterial}()
# global Propriedade = Vector{TPropriedade}()
# global Apoio = Vector{TApoio}()
# global Apontador = Vector{Int64}
# global MRigidez = Vector{Float64}[]
# global VetorDeCarga = Matrix{Float64}[]
# ArquivoDeDados = ""
# ArquivoDeSaida = ""
# NomeDoArquivoDeDados = ""
# NomeDoArquivoDeSaida = ""
# global NumeroDeApoios = 0
# global NumeroDeCarregamentos = 0
# global NumeroDeElementos = 0
# global NumeroDeMateriais = 0
# global NumeroDeNos = 0
# global NumeroDePropriedades = 0
# global NGrande = 0.0
# ExistemElementosComArticulacoes = false

# function ProdutoDeMatrizesTr(matriz1::Matrix{Float64}, matriz2::Matrix{Float64})::Matrix{Float64}
#     return matriz1 * matriz2
# end

# function Matriz_De_Rotacao_PEspacial(NroDaBarra::Int64)::Matrix{Float64}
#     i::Int64 = 0
#     j::Int64 = 0
#     k::Int64 = 0
#     m::Int64 = 0
#     L::Float64 = 0.0
#     CX::Float64 = 0.0
#     CY::Float64 = 0.0
#     CZ::Float64 = 0.0
#     CosAlfa::Float64 = 0.0
#     SinAlfa::Float64 = 0.0
#     CosBeta::Float64 = 0.0
#     SinBeta::Float64 = 0.0
#     CosGama::Float64 = 0.0
#     SinGama::Float64 = 0.0
#     Tr::Matrix{Float64} = zeros(3, 3)
#     TrAuxiliar::Matrix{Float64} = zeros(3, 3)
#     RotBar::Matrix{Float64} = zeros(12, 12)

#     elem = Elemento[NroDaBarra]
#     CX = Coord[elem.Ndn[2]].X - Coord[elem.Ndn[1]].X
#     CY = Coord[elem.Ndn[2]].Y - Coord[elem.Ndn[1]].Y
#     CZ = Coord[elem.Ndn[2]].Z - Coord[elem.Ndn[1]].Z
#     L = sqrt(sqrt(CX) + sqrt(CY) + sqrt(CZ))
#     CX = CX / L
#     CY = CY / L
#     CZ = CZ / L

#     if sqrt(sqrt(CX) + sqrt(CZ)) > Zero
#         CosAlfa = CX / sqrt(sqrt(CX) + sqrt(CZ))
#         SinAlfa = CZ / sqrt(sqrt(CX) + sqrt(CZ))
#     else
#         CosAlfa = 1.0
#         SinAlfa = 0.0
#     end

#     CosBeta = sqrt(sqrt(CX) + sqrt(CZ))
#     SinBeta = CY
#     CosGama = cos(elem.Gama)
#     SinGama = sin(elem.Gama)

#     # Matriz alfa
#     Tr[1, 1] = CosAlfa
#     Tr[1, 3] = SinAlfa
#     Tr[2, 2] = 1.0
#     Tr[3, 1] = -SinAlfa
#     Tr[3, 3] = CosAlfa

#     # Matriz beta
#     TrAuxiliar[1, 1] = CosBeta
#     TrAuxiliar[1, 2] = SinBeta
#     TrAuxiliar[2, 1] = -SinBeta
#     TrAuxiliar[2, 2] = CosBeta
#     TrAuxiliar[3, 3] = 1.0
#     Tr = ProdutoDeMatrizesTr(TrAuxiliar, Tr)

#     TrAuxiliar = zeros(3, 3)
#     # Matriz gama
#     TrAuxiliar[1, 1] = 1.0
#     TrAuxiliar[2, 2] = CosGama
#     TrAuxiliar[2, 3] = SinGama
#     TrAuxiliar[3, 2] = -SinGama
#     TrAuxiliar[3, 3] = CosGama
#     Tr = ProdutoDeMatrizesTr(TrAuxiliar, Tr)

#     for k in 1:4
#         for i in 1:3
#             for j in 1:3
#                 RotBar[m+i, m+j] = Tr[i, j]
#             end
#         end
#         m += 3
#     end

#     return RotBar
# end

# function IntroduzArticulacaoNaMatrizDeRigidezDoElemento(k::Matrix{Float64}, DirecaoDaArticulacao::Int64)::Matrix{Float64}
#     j::Int64 = 0
#     m::Int64 = 0
#     Fator::Float64 = 0.0
#     Denominador::Float64 = 0.0

#     if (DirecaoDaArticulacao > 2 * NDesNo) || (DirecaoDaArticulacao <= 0)
#         return k
#     else
#         for j in 1:(2*NDesNo)
#             if j != DirecaoDaArticulacao
#                 Fator = k[j, DirecaoDaArticulacao]
#                 Denominador = k[DirecaoDaArticulacao, DirecaoDaArticulacao]
#                 Fator = k[j, DirecaoDaArticulacao] / Denominador

#                 for m in 1:(2*NDesNo)
#                     k[j, m] = k[j, m] - (Fator * k[DirecaoDaArticulacao, m])
#                 end
#             end
#         end
#         for m in 1:(2*NDesNo)
#             k[DirecaoDaArticulacao, m] = 0.0
#         end
#     end

#     return k
# end

# function Matriz_de_Rigidez_PEspacial_Local(NroDaBarra::Int64)::Matrix{Float64}
#     MRig = zeros(12, 12)
#     FiY::Float64 = 0.0
#     FiZ::Float64 = 0.0

#     elem = Elemento[NroDaBarra]
#     METransversal = Material[elem.NroDaMaterial].Elasticidade / 2 / (1.0 + Material[elem.NroDaMaterial].Poisson)

#     CX = Coord[elem.Ndn[2]].X - Coord[elem.Ndn[1]].X
#     CY = Coord[elem.Ndn[2]].Y - Coord[elem.Ndn[1]].Y
#     CZ = Coord[elem.Ndn[2]].Z - Coord[elem.Ndn[1]].Z
#     L = sqrt(sqrt(CX) + sqrt(CY) + sqrt(CZ))

#     if Propriedade[elem.NroDaMaterial].AreaY > 0
#         FiY = (12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ) / (METransversal * Propriedade[elem.NroDaPropriedade].AreaY * sqrt(L))
#     else
#         FiY = 0.0
#     end
#     if Propriedade[elem.NroDaMaterial].AreaZ > 0
#         FiZ = (12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY) / (METransversal * Propriedade[elem.NroDaPropriedade].AreaZ * sqrt(L))
#     else
#         FiZ = 0.0
#     end

#     MRig[1, 1] = Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].AreaX / L
#     MRig[7, 1] = -MRig[1, 1]
#     MRig[2, 2] = 12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / (L^3) * (1 + FiY)
#     MRig[6, 2] = 6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / (L^2) * (1 + FiY)
#     MRig[8, 2] = -MRig[2, 2]
#     MRig[12, 2] = MRig[6, 2]
#     MRig[3, 3] = 12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / (L^3) * (1 + FiZ)
#     MRig[5, 3] = -6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / (L^2) * (1 + FiZ)
#     MRig[9, 3] = -MRig[3, 3]
#     MRig[11, 3] = MRig[5, 3]
#     MRig[4, 4] = METransversal * Propriedade[elem.NroDaPropriedade].InerciaX / L
#     MRig[10, 4] = -MRig[4, 4]
#     MRig[5, 5] = (4 + FiZ) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / L / (1 + FiZ)
#     MRig[9, 5] = 6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / (L^2) * (1 + FiZ)
#     MRig[11, 5] = (2 - FiZ) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / L / (1 + FiZ)
#     MRig[6, 6] = (4 + FiY) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / L / (1 + FiZ)
#     MRig[8, 6] = -6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / (L^2) * (1 + FiY)
#     MRig[12, 6] = (2 - FiY) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / L / (1 + FiY)
#     MRig[7, 7] = Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].AreaX / L
#     MRig[8, 8] = 12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / (L^3) * (1 + FiY)
#     MRig[12, 8] = -6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / (L^2) * (1 + FiY)
#     MRig[9, 9] = 12 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / (L^3) * (1 + FiZ)
#     MRig[11, 9] = 6 * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / (L^2) * (1 + FiZ)
#     MRig[10, 10] = METransversal * Propriedade[elem.NroDaPropriedade].InerciaX / L
#     MRig[11, 11] = (4 + FiZ) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaY / L / (1 + FiZ)
#     MRig[12, 12] = (4 + FiY) * Material[elem.NroDaMaterial].Elasticidade * Propriedade[elem.NroDaPropriedade].InerciaZ / L / (1 + FiY)

#     for i in 1:12
#         for j in 1:12
#             MRig[i, j] = MRig[j, i]
#         end
#     end

#     if elem.NroDeArticulacoes > 0
#         for i in 1:elem.NroDeArticulacoes
#             MRig = IntroduzArticulacaoNaMatrizDeRigidezDoElemento(MRig, elem.AsArticulacoes[i])
#         end
#     end

#     return MRig
# end

# function Matriz_de_Rigidez_PEspacial_Global(NroDaBarra::Int64)::Matrix{Float64}
#     Kl = Matrix{Float64}[]
#     Ka = Matrix{Float64}[]
#     R = Matrix{Float64}[]

#     Ka = zeros(12, 12)
#     Kl = Matriz_de_Rigidez_PEspacial_Local(NroDaBarra)
#     R = Matriz_De_Rotacao_PEspacial(NroDaBarra)

#     for i in 1:12
#         for j in 1:12
#             for k in 1:12
#                 Ka[i, j] = Ka[i, j] + R[k, i] * Kl[k, j]
#             end
#         end
#     end

#     global Kl = zeros(12, 12)
#     for i in 1:12
#         for j in 1:12
#             for k in 1:12
#                 global Kl[i, j] = Kl[i, j] + Ka[i, k] * R[k, j]
#             end
#         end
#     end

#     return Kl
# end

# function MontarVetorApontador()
#     global Apontador = ones(Int64, NDesNo * NumeroDeNos + 1)
#     n = Int64(0)

#     for i in 1:NumeroDeElementos
#         Nol::Int64 = 1
#         for j in 2:NNoElem
#             if Elemento[i].Ndn[j] < Elemento[i].Ndn[Nol]
#                 Nol = j
#             end
#         end
#         n = NDesNo * (Elemento[i].Ndn[Nol] - 1) + 1
#         for j in 1:NNoElem
#             for k in 1:NDesNo
#                 m = NDesNo * (Elemento[i].Ndn[j] - 1) + k
#                 d = m - n + 1
#                 if Apontador[m] < d
#                     global Apontador[m] = d
#                 end
#             end
#         end
#     end

#     for i in 2:(NDesNo*NumeroDeNos)
#         global Apontador[i] = Apontador[i-1] + Apontador[i]
#     end
# end

# function MontarMatrizDeRigidezDaEtsrutura()
#     global MRigidez = zeros(Float64, Int64(Apontador[NDesNo*NumeroDeNos] + 1))
#     Q = ones(Int64, Int64((NNoElem * NDesNo) + 1))
#     for i in 1:NumeroDeElementos
#         Kg = Matriz_de_Rigidez_PEspacial_Global(i)
#         z = 0

#         for j in 1:NNoElem
#             for k in 1:NDesNo
#                 z += 1
#                 m = NDesNo * (Elemento[i].Ndn[j] - 1) + k
#                 Q[z] = m
#             end
#         end

#         for j in 1:(NNoElem*NDesNo)
#             for k in 1:(NNoElem*NDesNo)
#                 if Q[k] >= Q[j]
#                     m = Apontador[Q[k]] + Q[j] - Q[k]
#                     global MRigidez[m] = MRigidez[m] + Kg[j, k]
#                 end
#             end
#         end
#     end
# end

# function CondicoesGeometricasDeContorno()
#     MediaDiagonalPrincipalMRGlobal = 0.0
#     for i in 1:(NDesNo*NumeroDeNos)
#         MediaDiagonalPrincipalMRGlobal += MRigidez[Apontador[i]]
#     end
#     MediaDiagonalPrincipalMRGlobal = MediaDiagonalPrincipalMRGlobal / (NDesNo * NumeroDeNos)
#     global NGrande = MediaDiagonalPrincipalMRGlobal * NumeroGrandeReferencia

#     for i in 1:NumeroDeApoios
#         for j in 1:NDesNo
#             if Apoio[i].Restricoes[j] == "1"
#                 k = (Apoio[i].NroDoNo - 1) * NDesNo + j
#                 global MRigidez[Apontador[k]] = MRigidez[Apontador[k]] + NGrande
#             end
#         end
#     end
# end

# function ResolverOSistemadeEquacoes()::Bool
#     # Triangulação
#     OZeroLocal = 1.0e-30
#     ResolverOSistemadeEquacoes = true
#     global MRigidez[1] = sqrt(MRigidez[1])
#     for j in 2:(NDesNo*NumeroDeNos)
#         h = Apontador[j] - Apontador[j-1]
#         global q = Apontador[j-1] + 1
#         r = j - h + 1

#         if r != j
#             if abs(MRigidez[Apontador[r]]) > OZeroLocal
#                 global MRigidez[q] = MRigidez[q] / MRigidez[Apontador[r]]
#             else
#                 println("A MATRIZ NAO É POSITIVA DEFINIDA 1")
#                 return false
#             end
#         end

#         for i in (r+1):j
#             global q += 1
#             m = Apontador[i] - Apontador[i-1]
#             s = i - m + 1
#             if r > s
#                 x = r
#             else
#                 x = s
#             end

#             if x <= (i - 1)
#                 q1 = Apontador[i] - (i - x) - 1
#                 q2 = Apontador[j] - (j - x) - 1

#                 for k in x:(i-1)
#                     q1 += 1
#                     q2 += 1
#                     global MRigidez[q] = MRigidez[q] - MRigidez[q1] * MRigidez[q2]
#                 end

#                 if i == j
#                     # goto Pular
#                     break
#                 end

#                 if abs(MRigidez[Apontador[i]]) > OZeroLocal
#                     global MRigidez[q] = MRigidez[q] / MRigidez[Apontador[i]]
#                 else
#                     println("A MATRIZ NAO É POSITIVA DEFINIDA 3")
#                     return false
#                 end
#             end
#         end
#         # Pular
#         if MRigidez[q] > 0
#             global MRigidez[q] = sqrt(MRigidez[q])
#         else
#             println("A MATRIZ NAO É POSITIVA DEFINIDA 4 $(MRigidez[q])@$(q)")
#             return false
#         end
#         # End Pular
#     end

#     # Substituição
#     for j in 1:NumeroDeCarregamentos
#         global VetorDeCarga[1, j] = VetorDeCarga[1, j] / MRigidez[1]
#     end
#     for i in 2:(NDesNo*NumeroDeNos)
#         h = Apontador[i] - Apontador[i-1]
#         r = i - h + 1
#         for j in 1:NumeroDeCarregamentos
#             q = Apontador[i-1]
#             RealAuxiliar = VetorDeCarga[i, j]

#             if r != i
#                 for k in r:(i-1)
#                     q = q + 1
#                     RealAuxiliar = RealAuxiliar / MRigidez[q] * VetorDeCarga[k, j]
#                 end
#             end
#         end
#     end
#     # Retrosubstituicao
#     for i in reverse(2:(NDesNo*NumeroDeCarregamentos))
#         for j in 1:NumeroDeCarregamentos
#             VetorDeCarga[i, j] = VetorDeCarga[i, j] / MRigidez[Apontador[i]]
#         end
#         h = Apontador[i] - Apontador[i-1]
#         r = i - h + 1
#         if r != i
#             q = Apontador[i-1]
#             for k in r:(i-1)
#                 q = q + 1
#                 for j in 1:NumeroDeCarregamentos
#                     VetorDeCarga[k, j] = VetorDeCarga[k, j] - MRigidez[q] * VetorDeCarga[i, j]
#                 end
#             end
#         end
#     end
#     for j in 1:NumeroDeCarregamentos
#         VetorDeCarga[1, j] = VetorDeCarga[1, j] / MRigidez[1]
#     end

#     display(VetorDeCarga)
#     return true
# end

# function LerCoordenadasNodais()
#     push!(Coord, TCoord(0.0, 0.0, 0.0))
#     push!(Coord, TCoord(6.0, 0.0, 0.0))
#     push!(Coord, TCoord(0.0, 3.0, 0.0))
#     push!(Coord, TCoord(6.0, 3.0, 0.0))

#     global NumeroDeNos = length(Coord)
# end

# function LerInformacoesDosElementos()
#     push!(Elemento, TElemento("Pilar P101", [1, 3], 1, 1, 0, 0.0, [1.0]))
#     push!(Elemento, TElemento("Viga V101", [3, 4], 1, 1, 0, 0.0, [1.0]))
#     push!(Elemento, TElemento("Pilar P102", [2, 4], 1, 1, 0, 0.0, [1.0]))

#     global NumeroDeElementos = length(Elemento)
# end

# function LerMateriais()
#     push!(Material, TMaterial("ACO CA-50", 2.05E8, 0.2, 77.0, 7.849))

#     global NumeroDeMateriais = length(Material)
# end

# function LerPropriedadesDeSecao()
#     push!(Propriedade, TPropriedade(1.98e-2, 0.0, 0.0, 1.e-3, 1.e-3, 1.29e-3))

#     global NumeroDePropriedades = length(Propriedade)
# end

# function LerApoios()
#     push!(Apoio, TApoio(1, ["1", "1", "1", "1", "1", "0"]))
#     push!(Apoio, TApoio(2, ["1", "1", "1", "1", "1", "1"]))

#     global NumeroDeApoios = length(Apoio)
# end

# function LerEImprimirCargas()
#     global NumeroDeCarregamentos = 1
#     global VetorDeCarga = zeros(NDesNo * NumeroDeNos + 1, NumeroDeCarregamentos + 1)

#     # for i in 1:NumeroDeCarregamentos
#     #     NroDoCarregamento = 1
#     #     NroDeCargasNodais = 2
#     #     for j in 1:NroDeCargasNodais
#     #         for k in 1:6
#     #             VetorDeCarga[]
#     #         end
#     #     end
#     # end


#     global VetorDeCarga[1, 1] = -50.0
#     global VetorDeCarga[2, 1] = -30.0
#     global VetorDeCarga[6, 1] = -50.0
#     global VetorDeCarga[2, 2] = -30.0
#     global VetorDeCarga[6, 2] = 30.0


#     println("7. Carregamentos")
#     println("--> $(NumeroDeCarregamentos)")
# end

# function FazRelatorioDosDados()
#     println("1. Informações Gerais\n")
#     @printf "   Número de Nós.......... % 3i\n" NumeroDeNos
#     @printf "   Número de Elementos.... % 3i\n" NumeroDeElementos
#     @printf "   Número de Propriedades. % 3i\n" NumeroDePropriedades
#     @printf "   Número de Materiais.... % 3i\n" NumeroDeMateriais
#     @printf "   Número de Apoios....... % 3i\n" NumeroDeApoios
#     @printf "   Número de Carregamentos % 3i\n" NumeroDeCarregamentos
#     println()

#     println("\n2. Materiais\n")
#     println("   Material M.Elasticidade        Poisson   P.Especifico Massa Especifica Descrição")
#     println("   -------- -------------- -------------- -------------- ---------------- ---------------------------")
#     for i in 1:NumeroDeMateriais
#         @printf "   % 8i % 14.3f % 14.3f % 14.3f   % 14.3f %s\n" i Material[i].Elasticidade Material[i].Poisson Material[i].PesoEspecifico Material[i].MassaEspecifica Material[i].Nome
#     end
#     println()

#     println("\n3. Seções\n")
#     println("      Seção             Ax             Ay             Az             Ix             Iy             Iz")
#     println("   -------- -------------- -------------- -------------- -------------- -------------- --------------")
#     for i in 1:NumeroDePropriedades
#         @printf "   % 8i % 14.6f % 14.6f % 14.6f % 14.6f % 14.6f % 14.6f\n" i Propriedade[i].AreaX Propriedade[i].AreaY Propriedade[i].AreaZ Propriedade[i].InerciaX Propriedade[i].InerciaY Propriedade[i].InerciaZ
#     end
#     println()

#     println("\n4. Coordenadas Nodais\n")
#     println("         Nó              X              Y              Z")
#     println("   -------- -------------- -------------- --------------")
#     for i in 1:NumeroDeNos
#         @printf "   % 8i % 14.3f % 14.3f % 14.3f\n" i Coord[i].X Coord[i].Y Coord[i].Z
#     end
#     println()

#     println("\n5. Propriedades dos Elementos\n")
#     println("   Elemento  Nó Ini. Nó Final           Gama Material    Seção Descrição")
#     println("   -------- -------- -------- -------------- -------- -------- --------------------------------------")
#     for i in 1:NumeroDeElementos
#         @printf "   % 8i % 8i % 8i % 14.4f % 8i % 8i %s\n" i Elemento[i].Ndn[1] Elemento[i].Ndn[2] Elemento[i].Gama Elemento[i].NroDaMaterial Elemento[i].NroDaPropriedade Elemento[i].Nome
#     end
#     println()

#     println("\n6. Restrições\n")
#     println("         Nó   TX   TY   TZ   RX   RY   RZ")
#     println("   -------- ---- ---- ---- ---- ---- ----")
#     for i in 1:NumeroDeApoios
#         @printf "   % 8i" Apoio[i].NroDoNo
#         for j in 1:6
#             @printf " % 4s" Apoio[i].Restricoes[j]
#         end
#         print("\n")
#     end
#     println()
# end

# function ResultadosFinais()
#     println("**************************************************+**************************************************")
#     println("                                        RESULTADO DA ANÁLISE")
#     println("**************************************************+**************************************************")

#     println("**************************************************+**************************************************")
#     println("                                       VERIFICAÇÕES - NBR 6118")
#     println("**************************************************+**************************************************")
# end

# function LinhaDeComando()::Bool
#     return false
# end

# function LerONomeDoArquivoDeDadosEDeSaida()

# end

# function CabecalhoDoArquivoDeSaida()

# end

# function CabecalhoDeTela()
#     println("**************************************************+**************************************************")
#     println("                                        ANÁLISE DE ESTRUTURAS")
#     println("**************************************************+**************************************************")
# end

# function LerInformacoesGerais()

# end


# # -----------------------------------------------------------------------------
# CabecalhoDeTela()
# LerONomeDoArquivoDeDadosEDeSaida()
# CabecalhoDoArquivoDeSaida()
# LerInformacoesGerais()
# LerMateriais()
# LerPropriedadesDeSecao()
# LerCoordenadasNodais()
# LerInformacoesDosElementos()
# LerApoios()
# FazRelatorioDosDados()
# LerEImprimirCargas()
# MontarVetorApontador()
# MontarMatrizDeRigidezDaEtsrutura()
# CondicoesGeometricasDeContorno()

# if ResolverOSistemadeEquacoes()
#     ResultadosFinais()
# else
#     println("\n===> Análise não realizada.")
# end


# ============ Teoria do MEF
# # Exemplo de uma mola engastada no ponto A e carga no ponto B e D
# ka = 500
# kb = 1000
# kc = 1000

# # Matrizes de rigidez local
# Ka = [ka -ka; -ka ka]
# Kb = [kb -kb; -kb kb]
# Kc = [kc -kc; -kc kc]

# # Matriz de rigidez da estrutura
# K = zeros(4, 4)
# K[1:2, 1:2] = Ka
# K[2:3, 2:3] += Kb
# K[3:4, 3:4] += Kc

# # Forças/Reações
# Fa = 0.
# Fb = 50.
# Fc = 0.
# Fd = 100.
# F = [Fa; Fb; Fc; Fd]

# # Deslocamentos
# Ua = 0. # Engastado, está restrito
# Ub = 0.
# Uc = 0.
# Ud = 0.
# U = [Ua; Ub; Uc; Ud]

# # Sistema de equações Fr = Kr * Ur
# Fr = F[2:4]
# Kr = K[2:4, 2:4] 
# Ur = U[2:4]

# println("F")
# display(F)
# println()
# println("K")
# display(K)
# println()
# println("\n")

# println("Fr")
# display(Fr)
# println("\n")

# println("Kr")
# display(Kr)
# println("\n")

# println("Ur")
# display(Ur)
# println("\n")

# # Resolve o sistema para Ub Uc Ud
# U[2:4] = Kr \ Fr
# println("U")
# display(U)
# println("\n")

# # Calcula Fa
# F[1] = (K[1:1, 1:4] * U)[1]
# println("F")
# display(F)

# ============ Meu algoritmo
const DIRECAO_X = 1
const DIRECAO_Y = 2
const DIRECAO_Z = 3

numeroGrausLiberdade = 0
numeroNos = 0
matrizRigidezGlobal = Matrix{Float64}[]
matrizRigidezGlobalRestrita = Matrix{Float64}[]
matrizRigidezGlobalIrrestrita = Matrix{Float64}[]
vetorForcas = Vector{Float64}[]
vetorDeslocamentos = Vector{Float64}[]

function setup()
    global numeroGrausLiberdade = 3
    global numeroNos = 2
    global matrizRigidezGlobal = zeros(numeroNos * numeroGrausLiberdade, numeroNos * numeroGrausLiberdade)
    global vetorDeslocamentos = zeros(numeroNos * numeroGrausLiberdade)
    global vetorForcas = zeros(numeroNos * numeroGrausLiberdade)
end

function matrizRigidezElementoCoordenadaGlobal(noInicial::Vector{Float64}, noFinal::Vector{Float64}, areas::Vector{Float64}, momentosInercia::Vector{Float64}, moduloElasticidade::Float64, moduloPoisson::Float64)::Matrix{Float64}
    comprimentos = 0.0
    for i in 1:2
        comprimentos += (noFinal[i] - noInicial[i])^2
    end

    L = sqrt(comprimentos)
    cosBeta = (noFinal[1] - noInicial[1]) / L
    senBeta = (noFinal[2] - noInicial[2]) / L
    # @show cosBeta
    # @show senBeta
    # @show L

    E = moduloElasticidade
    EI = moduloElasticidade * momentosInercia[3]
    EK = EI
    EA = areas[2] * moduloElasticidade
    matrizRigidez = zeros(numeroGrausLiberdade * 2, numeroGrausLiberdade * 2)
    # @show EK
    # @show EA
    # @show E
    # @show EI

    mu = (A * L^2) / (2.0 * I)
    m = (2.0 * EI) / L^3
    matrizRigidez = m * [
        mu 0.0 0.0 0.0 0.0 0.0
        0.0 6.0 0.0 0.0 0.0 0.0
        0.0 -3.0*L 2*L^2 0.0 0.0 0.0
        -mu 0.0 0.0 mu 0.0 0.0
        0.0 -6.0 3.0*L 0.0 6.0 0.0
        0.0 -3.0*L L^2 0.0 3.0*L 2*L^2
    ]

    d1 = [cosBeta senBeta 0.0
        -senBeta cosBeta 0.0
        0.0 0.0 1.0]

    d = zeros(6, 6)

    d[1:3, 1:3] = d1 # transpose(d1)
    d[4:6, 4:6] = d1 # transpose(d1)

    return transpose(d) * matrizRigidez * d
end

function montarMatrizRigidezEstrutura(mapaNo::Vector{Int64}, matrizesElemento::Vector{Matrix{Float64}})
    global matrizRigidezGlobal = zeros(length(mapaNo), length(mapaNo))

    mapaNoRestricao = Dict{Int64,Vector{Int64}}()
    mapaNoCarregamento = Dict{Int64,Dict{Int64,Float64}}()
    mapaCoordenadas = Dict{Int64,Dict{Int64,Float64}}()
    mapaElementosNos = Dict{Int64,Tuple{Int64,Int64}}()

    mapaElementosNos[1] = (1, 2)
    # mapaElementosNos[2] = (2, 3)

    mapaNoRestricao[1] = [DIRECAO_X, DIRECAO_Y]
    mapaNoRestricao[2] = [DIRECAO_X, DIRECAO_Y]
    # mapaNoRestricao[3] = [DIRECAO_X, DIRECAO_Y, DIRECAO_Z]

    mapaNoCarregamento[1] = Dict(DIRECAO_Y => -5.0)
    mapaNoCarregamento[2] = Dict(DIRECAO_Y => -5.0)

    mapaCoordenadas[1] = Dict(DIRECAO_X => 0.0, DIRECAO_Y => 0.0)
    mapaCoordenadas[2] = Dict(DIRECAO_X => 5.0, DIRECAO_Y => 0.0)

    # mapaCoordenadas[1] = Dict(DIRECAO_X => 0.0, DIRECAO_Y => 0.0)
    # mapaCoordenadas[2] = Dict(DIRECAO_X => 0.0, DIRECAO_Y => 4.0)
    # mapaCoordenadas[3] = Dict(DIRECAO_X => 2.0, DIRECAO_Y => 4.0)

    # Monta Matriz de Rigidez da Estrutura
    for i in sort!(collect(keys(mapaElementosNos)), by = x -> x = x)
        println("e$(i)")
        display(matrizesElemento[i])
        println("\n")
        global j1 = 1
        global k1 = 0
        indiceInicial = (mapaElementosNos[i][1] * 3) - 2
        indiceFinal = (mapaElementosNos[i][2] * 3) - 2
        for j in indiceInicial:indiceInicial+2
            k1 = 0
            for k in indiceInicial:indiceInicial+2
                k1 += 1
                global matrizRigidezGlobal[j, k] = matrizRigidezGlobal[j, k] + matrizesElemento[i][j1, k1]
            end
            j1 += 1
        end
        for j in indiceFinal:indiceFinal+2
            k1 = 0
            for k in indiceFinal:indiceFinal+2
                k1 += 1
                global matrizRigidezGlobal[j, k] = matrizRigidezGlobal[j, k] + matrizesElemento[i][j1, k1]
            end
            j1 += 1
        end
    end

    # Monta matriz de rigidez global matrizRigidezGlobalRestrita
    global indicesNosRestritos = []
    global indicesNosIrrestritos = []

    for i in sort!(collect(keys(mapaNoRestricao)), by = x -> x = x)
        for j in sort!(collect(values(mapaNoRestricao[i])), by = x -> x = x)
            push!(indicesNosRestritos, ((i * 3) - 3) + j)
        end
    end
    global matrizRigidezGlobalIrrestrita = zeros((length(mapaNo) - length(indicesNosRestritos)), (length(mapaNo) - length(indicesNosRestritos)))
    global matrizRigidezGlobalRestrita = zeros(length(indicesNosRestritos), length(indicesNosRestritos))

    global i1 = 1
    global j1 = 1
    global i2 = 1
    global j2 = 1
    for i in 1:length(mapaNo)
        if length(findall(x -> x == i, indicesNosRestritos)) == 0
            for j in 1:length(mapaNo)
                if length(findall(x -> x == j, indicesNosRestritos)) == 0
                    println("[$(i1), $(j1)] += [$(i), $(j)] -> $(matrizRigidezGlobalIrrestrita[i1, j1]) += $(matrizRigidezGlobal[i, j])")
                    global matrizRigidezGlobalIrrestrita[i1, j1] += matrizRigidezGlobal[i, j]
                    j1 += 1
                end
            end
            if length(findall(x -> x == i, indicesNosRestritos)) == 0
                i1 += 1
                j1 = 1
            end
        else
            for j in 1:length(mapaNo)
                if length(findall(x -> x == j, indicesNosRestritos)) > 0
                    global matrizRigidezGlobalRestrita[i2, j2] += matrizRigidezGlobal[i, j]
                    j2 += 1
                end
            end
            if length(findall(x -> x == i, indicesNosRestritos)) > 0
                i2 += 1
                j2 = 1
            end
        end
    end

    for l in 1:length(mapaNo)
        if !(l in (indicesNosRestritos))
            push!(indicesNosIrrestritos, l)
        end
    end

    @show indicesNosRestritos

    println("matrizRigidezGlobal")
    display(matrizRigidezGlobal)
    println("\n")
    println("matrizRigidezGlobalRestrita")
    display(matrizRigidezGlobalRestrita)
    println("\n")
    println("matrizRigidezGlobalIrrestrita")
    display(matrizRigidezGlobalIrrestrita)
    println("\n")
end

e1 = Matrix{Float64}[]
e2 = Matrix{Float64}[]
e1 = zeros(numeroGrausLiberdade * 2, numeroGrausLiberdade * 2)
e2 = zeros(numeroGrausLiberdade * 2, numeroGrausLiberdade * 2)

setup()
E = 1.0
I = 1.0
A = 1.0
e1 = matrizRigidezElementoCoordenadaGlobal([0.0; 0.0], [1.0; 0.0], [A, A], [I, I, I], E, 0.0)
e2 = matrizRigidezElementoCoordenadaGlobal([1.0; 0.0], [2.0; 0.0], [A, A], [I, I, I], E, 0.0)
vetorForcas[2] = -5.0
vetorForcas[5] = -5.0

mapa = zeros(Int64, numeroGrausLiberdade * numeroNos)

montarMatrizRigidezEstrutura(mapa, [e1, e2])

@show indicesNosRestritos
@show indicesNosIrrestritos

ggg = zeros(length(indicesNosIrrestritos))
for i in 1:length(indicesNosIrrestritos)
    ggg[i] = vetorForcas[indicesNosIrrestritos[i]]
end
@show ggg
println("deslocamentos")
dd = matrizRigidezGlobalIrrestrita \ ggg
display(dd)
println()
println("Forças?")

for i in 1:length(indicesNosIrrestritos)
    vetorDeslocamentos[indicesNosIrrestritos[i]] = dd[i]
end

# vetorDeslocamentos[3] = dd[1]
# vetorDeslocamentos[6] = dd[2]

@show vetorDeslocamentos
@show vetorForcas

fff = zeros(length(indicesNosRestritos))
for i in 1:length(indicesNosRestritos)
    vetorDeslocamentos[indicesNosRestritos[i]] = vetorForcas[i]
end
eee = matrizRigidezGlobalRestrita * fff
display(eee)

@show matrizRigidezGlobal \ vetorDeslocamentos


## display(matrizRigidezElemento([0.; 0.], [0.; 4.], [1., 20000.], [1., 1., 300.e6], 200., 0.) \ [2., 3., 4., 5., 6., 7.])

#  1. Montar matriz de rigidez do elemento (matriz de rigidez local)
#  2. Transformar matriz de rigidez do elemento para coordenadas globais
#  3. Criar vetor para mapear índices da matriz do elemento para índices da matriz global
#  4. Criar vetor para mapear índices da matriz global às restrições de movimento
#  5. Criar vetor para mapear índices da matriz global aos carregamentos da estrutura
#  6. Criar vetor para mapear índices da matriz global aos deslocamentos iniciais da estrutura
#  7. Reduzir a matriz global removendo os índices com restrição de movimento
#  8. Resolver o sistemas de equações Fr = Kr * Ur para Ur
#  9. Atualizar o vetor U com os valores calculados em Ur
# 10. Resolver o sistema de equaçoes F = K * U para F
# 11. Apresentar o resultado dos cálculos

println()