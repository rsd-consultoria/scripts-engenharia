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

class PerfilMetalico:
    def __init__(self, area: float, rx: float, ry: float, material: Material):
        self.__area = area
        self.__rx = rx
        self.__ry = ry
        self.__material = material
        self.__peso = 0.
        self.__altura = 0.

    def get_area(self):
        return self.__area
    
    def set_area(self, area: float):
        self.__area = area
    
    def get_rx(self) -> float:
        return self.__rx
    
    def set_rx(self, rx: float):
        return self.__rx
    
    def get_ry(self) -> float:
        return self.__ry
    
    def set_ry(self, ry: float):
        return self.__ry

    def get_material(self) -> Material:
        return self.__material

    def set_material(self, material: Material):
        self.__material = material
    
    def set_peso(self, peso: float):
        self.__peso = peso
    
    def get_peso(self) -> float:
        return self.__peso
    
    def set_altura(self, altura: float):
        self.__altura = altura
    
    def get_altura(self) -> float:
        return self.__altura
