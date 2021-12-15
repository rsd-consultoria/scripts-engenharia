# Copyright(c) Rafael Dias
# MIT Licensed

module PropriedadesSecoes
    mutable struct Coordenada
        x::Float32
        y::Float32
    end

    function comprimentoEntrePontos(coordenadas::Array{Coordenada})::Float32
        quantidade = length(coordenadas)
        atual = 1
        proximo = 2
        comprimento = 0f0

        for contador in 1:quantidade - 1
            comprimento += sqrt(((coordenadas[proximo].x - coordenadas[atual].x)^2) + ((coordenadas[proximo].y - coordenadas[atual].y)^2))

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

        return comprimento
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

    function perimetroPoligono(coordenadas::Array{Coordenada})::Float32
        quantidade = length(coordenadas)
        atual = 1
        proximo = 2
        perimetro = 0f0

        for contador in 1:quantidade
            perimetro += sqrt(((coordenadas[proximo].x - coordenadas[atual].x)^2) + ((coordenadas[proximo].y - coordenadas[atual].y)^2))

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

        return perimetro
    end

    function centroGravidadePoligonoX(coordenadas::Array{Coordenada})::Float32
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

    function centroGravidadePoligonoY(coordenadas::Array{Coordenada})::Float32
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
end