mutable struct Coordenada
    x::Float32
    y::Float32
end

function areaPoligono(coordenadas::Array{Coordenada})::Float32
    quantidade = length(coordenadas)
    atual = 1
    proximo = 2
    area = 0f0
    
    for contador in 1:quantidade
        area += (coordenadas[proximo].x * coordenadas[atual].y) - (coordenadas[atual].x * coordenadas[proximo].y)

        if proximo < quantidade
            proximo += 1
        else
            proximo = 1
        end
        if contador == quantidade
            atual = 1
        else
            atual += 1
        end
    end
    
    return area / 2f0
end

function centroGravidadeX(coordenadas::Array{Coordenada})::Float32
    quantidade = length(coordenadas)
    atual = 1
    proximo = 2
    xgc = 0f0
    
    for contador in 1:quantidade
        xgc += (coordenadas[proximo].x + coordenadas[atual].x) * ((coordenadas[proximo].x * coordenadas[atual].y) - (coordenadas[atual].x * coordenadas[proximo].y))

        if proximo < quantidade
            proximo += 1
        else
            proximo = 1
        end
        if contador == quantidade
            atual = 1
        else
            atual += 1
        end
    end

    return xgc * (1 / (6 * areaPoligono(coordenadas)))
end

function centroGravidadeY(coordenadas::Array{Coordenada})::Float32
    quantidade = length(coordenadas)
    atual = 1
    proximo = 2
    ygc = 0f0
    
    for contador in 1:quantidade
        ygc += (coordenadas[proximo].y + coordenadas[atual].y) * ((coordenadas[proximo].x * coordenadas[atual].y) - (coordenadas[atual].x * coordenadas[proximo].y))

        if proximo < quantidade
            proximo += 1
        else
            proximo = 1
        end
        if contador == quantidade
            atual = 1
        else
            atual += 1
        end
    end

    return ygc * (1 / (6 * areaPoligono(coordenadas)))
end

coordenadas = [
    Coordenada(0f0, 43f0)
    Coordenada(0f0, 60f0)
    Coordenada(70f0, 60f0)
    Coordenada(70f0, 0f0)
    Coordenada(53f0, 0f0)
    Coordenada(53f0, 43f0)
]

# Deve retornar 1921 cm^2
@show areaPoligono(coordenadas)

# Deve retornar 45.084 cm
@show centroGravidadeX(coordenadas)

# Deve retornar 40.084 cm^2
@show centroGravidadeY(coordenadas)