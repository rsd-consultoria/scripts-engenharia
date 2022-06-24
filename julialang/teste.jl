using LinearAlgebra

ninc = 5
neq = 2

a = [-1.0 1.0 -4.0 1.0 0.0; 2.0 -1.0 2.0 0.0 1.0]
b = [30.0 10.0]
c = [-1.0 -2.0 1.0 0.0 0.0]

f = 0.0
pivo = 0.0

contador = 1
centra = 0.0
while(true)
    global contador += 1
    isai = 1
    jentra = 1
    razao = 0

    @show a
    @show b
    @show c
    @show f
    @show pivo
    @show jentra
    @show razao

    for j in 1:ninc
        if c[j] < centra
            global centra = c[j]
            jentra = j
        end
    end

    if centra == 0.0
        @show contador
        break
    end

    razaoa = 10000.0

    for i in 1:neq
        razao = b[i]/a[i, jentra]

        if razao > 0.0
            if razao < razaoa
                isai = i
            end
        end
    end

    global pivo = a[isai, jentra]

    for j in 1:ninc
        a[isai, j] = a[isai, j] / pivo
    end

    b[isai] = b[isai] / pivo

    for i in 1:neq
        if i == isai
            _const = a[i, jentra]

            for j in 1:ninc
                a[i, j] = a[i, j] - _const * a[isai, j]
            end

            b[i] = b[i] - _const * b[isai]
        end
    end

    _const = c[jentra]

    for j in 1:ninc
        c[j] = c[j] - _const * a[isai, j]
    end

    global f = f - _const * b[isai]
end

println()
println()
@show a
@show b
@show c
@show f