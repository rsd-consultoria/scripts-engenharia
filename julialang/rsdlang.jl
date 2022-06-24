"""
arquivo.rsd

SINTAXE:

definir: # SINTAXE=> definir:
    material: "CONCRETO 20MPA" # SINTAXE=> material: {ID Material} ...
    no: 0.0 0.0 0.0 "A" # SINTAXE=> no: {x} {y} {z} {ID Nó}
    no: 0.0 1.0 0.0 "B" # SINTAXE=> no: {x} {y} {z} {ID Nó}
    elemento: "A" "B" "PILAR P1" # elemento: {ID Nó inicial} {ID Nó final} {ID Elemento}

com elemento "PILAR P1": # SINTAXE=> com elemento {ID Elemento}:
    propriedades: material="CONCRETO 20MPA" # SINTAXE=> propriedades: material={ID Material}  ...

com no "A": # SINTAXE=> com no {ID Nó}:
    carregar: 0.0 -12000.00 0.0 # SINTAXE=> carregar: {x} {y} {z} ...
    restringir: xyz # SINTAXE=> restringir: {[z,y,z]} ...

analisar # SINTAXE=> analisar
relatorio # SINTAXE=> relatorio
dimensionar # SINTAXE=> dimensionar

"""
module RSDLang
   function load()
       
   end

   function tokenize()
       
   end

   function evaluate()
       
   end

   function intepret()
       
   end
end