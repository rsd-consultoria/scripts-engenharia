# Propriedades dos materiais
AE = 0.72e6
EI = 24e6

# Propriedades dos elementos
l1 = 600
l2 = 600
A = 1

# Elemento 1
k1 = [
    (4*EI)/l1 (2*EI)/l1 (6*EI)/l1^2 -(6*EI)/l1^2 0 0
    (2*EI)/l1 (4*EI)/l1 (6*EI)/l1^2 -(6*EI)/l1^2 0 0
    (6*EI)/l1^2 (6*EI)/l1^2 (12*EI)/l1^3 -(12*EI)/l1^3 0 0
    -(6*EI)/l1^2 -(6*EI)/l1^2 -(12*EI)/l1^3 (12*EI)/l1^3 0 0
    0 0 0 0 (AE)/l1 -(AE)/l1
    0 0 0 0 -(AE)/l1 (AE)/l1
]

f = [0, 0, 20, 3000]

@show k1 / 100
@show k1[1:4, 1:4]
@show f \ k1