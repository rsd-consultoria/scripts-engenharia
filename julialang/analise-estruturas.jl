# Copyright(c) Rafael Dias
# MIT Licensed
include("propriedades-secoes.jl")

module AnaliseEstruturas
    include("propriedades-secoes.jl")
    mutable struct Elemento
        coordenadaInicial::PropriedadesSecoes.Coordenada
        coordenadaFinal::PropriedadesSecoes.Coordenada
    end

    mutable struct Estrutura
        elementos::Array{Elemento}
    end
end
