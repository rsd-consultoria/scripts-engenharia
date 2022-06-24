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

    function comprimento(elemento::Elemento)::Float32
        return sqrt(((elemento.coordenadaFinal.x - elemento.coordenadaInicial.x) ^ 2) + ((elemento.coordenadaFinal.y - elemento.coordenadaInicial.y) ^ 2))
    end

    function buildElemento(inicioX::Float32, inicioY::Float32, terminoX::Float32, terminoY::Float32)::Elemento
        return Elemento(PropriedadesSecoes.Coordenada(inicioX, inicioY), PropriedadesSecoes.Coordenada(terminoX, terminoY))
    end

    function metodoDeslocamentos(elemento::Elemento)::Array{Float32}
        @show comprimento(elemento)

        return [0f0]
    end

    function metodoForcas(elemento::Elemento)::Array{Float32}
        @show elemento

        return [0f0]
    end
end
