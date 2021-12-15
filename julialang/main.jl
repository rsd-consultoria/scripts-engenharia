# Copyright(c) Rafael Dias
# MIT Licensed
 
include("analise-estruturas.jl")

# Ordem deve ser horária
# coordenadas = [
#     PropriedadesSecoes.Coordenada(53f0, 0f0)
#     PropriedadesSecoes.Coordenada(53f0, 43f0)
#     PropriedadesSecoes.Coordenada(0f0, 43f0)
#     PropriedadesSecoes.Coordenada(0f0, 60f0)
#     PropriedadesSecoes.Coordenada(70f0, 60f0)
#     PropriedadesSecoes.Coordenada(70f0, 0f0)
# ]

coordenadas = [
    PropriedadesSecoes.Coordenada(0f0, 0f0)
    PropriedadesSecoes.Coordenada(0f0, 2f0)
    PropriedadesSecoes.Coordenada(5f0, 2f0)
    PropriedadesSecoes.Coordenada(5f0, 12f0)
    PropriedadesSecoes.Coordenada(0f0, 12f0)
    PropriedadesSecoes.Coordenada(0f0, 14f0)
    PropriedadesSecoes.Coordenada(12f0, 14f0)
    PropriedadesSecoes.Coordenada(12f0, 12f0)
    PropriedadesSecoes.Coordenada(7f0, 12f0)
    PropriedadesSecoes.Coordenada(7f0, 2f0)
    PropriedadesSecoes.Coordenada(12f0, 2f0)
    PropriedadesSecoes.Coordenada(12f0, 0f0)
]

@show PropriedadesSecoes.areaPoligono(coordenadas)

@show PropriedadesSecoes.centroGravidadePoligonoX(coordenadas)

@show PropriedadesSecoes.centroGravidadePoligonoY(coordenadas)

@show PropriedadesSecoes.perimetroPoligono(coordenadas)

@show PropriedadesSecoes.comprimentoEntrePontos(coordenadas)