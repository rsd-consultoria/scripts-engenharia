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
class Material:
    def __init__(self):
        self.__indice_elasticidade: float = 0.
        self.__tipo_material = ''
        self.__tensao_escoamento: float = 0.
        self.__tensao_resistencia: float = 0.

    def get_indice_elasticidade(self) -> float:
        return self.__indice_elasticidade
    
    def set_indice_elasticidade(self, indice_elasticidade: float) -> float:
        self.__indice_elasticidade = indice_elasticidade
    
    def set_tensao_escoamento(self, tensao_escoamento: float):
        self.__tensao_escoamento = tensao_escoamento
    
    def get_tensao_escoamento(self) -> float:
        return self.__tensao_escoamento
    
    def set_tensao_resistencia(self, tensao_resistencia: float):
        self.__tensao_resistencia = tensao_resistencia
    
    def get_tensao_resistencia(self) -> float:
        return self.__tensao_resistencia
    
    def get_tipo_material(self) -> str:
        return self.__tipo_material
    
    def set_tipo_material(self, tipo_material: str):
        self.__tipo_material = tipo_material
    
    def __str__(self):
        return 'E={0} | Tensao Escoamento={1} | Tensao Resistencia={2}'.format(
            self.get_indice_elasticidade(), 
            self.get_tensao_escoamento(), 
            self.get_tensao_resistencia())
