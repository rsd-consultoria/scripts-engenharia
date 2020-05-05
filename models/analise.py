# Copyright (c) 2020 rsdconsultorias.com.br

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
from models.material import Material

class Analise:
    
    def __init__(self):
        self.__cargas = list()
        self.__materiais = dict()
        self.__coeficiente_seguranca = 0.
    
    def add_material(self, nome: str, material: Material):
        self.__materiais.update({nome: material})

    def remove_material(self, nome: str):
        del self.__materiais[nome]

    def get_material(self, nome: str) -> Material:
        return self.__materiais[nome]
    
    def listar_materiais(self) -> dict:
        print('\n{:_^80}\n'.format('[ ESPECIFICACAO DOS MATERIAIS ]'))
        for material in self.__materiais.items():
            print('{0:.<20}{1}'.format(material[0], material[1]))

    def adicionar_carga(self, carga: float, descricao: str):
        self.__cargas.append((carga, descricao))
    
    def remover_carga(self, indice: int):
        self.__cargas.remove(self.__cargas[indice])
    
    def get_cargas(self) -> list:
        return self.__cargas

    def get_carga_total(self) -> float:
        if (len(self.__cargas) > 1):
            soma: float = 0.
            for carga in self.__cargas:
                soma += carga[0]
            return soma
        else:
            return self.__cargas[0][0]
    
    def set_coeficiente_seguranca(self, coeficiente_seguranca: float):
        self.__coeficiente_seguranca = coeficiente_seguranca
    
    def get_coeficiente_seguranca(self) -> float:
        return self.__coeficiente_seguranca
    
    def listar_cargas(self):
        print('\n\n{:_^80}\n'.format('[ CARGAS DE PROJETO ]'))
        for carga in self.get_cargas():
            print('{0:.<56}{1:.> 20,.3f} kgf'.format(carga[1], carga[0]))
        print('\n(=){0:.<53}{1:.> 20,.3f} kgf'.format('CARGA TOTAL', self.get_carga_total()))

    def get_memoria_calculo(self):
        self.listar_materiais()
        self.listar_cargas()