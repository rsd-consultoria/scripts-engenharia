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
import numpy as np
import math

class No:
    def __init__(self, descricao: str, x: float, y: float, z: float = 0.):
        self.__descricao: str = descricao
        self.__x: float = x
        self.__y: float = y
        self.__z: float = z
        self.__dx: float = 0.
        self.__dy: float = 0.
        self.__dz: float = 0.
    
    def get_descricao(self) -> str:
        return self.__descricao

    def get_x(self) -> float:
        return self.__x

    def get_y(self) -> float:
        return self.__y

    def get_z(self) -> float:
        return self.__z
    
    def set_descricao(self, descricao: str):
        self.__descricao = descricao

    def set_x(self, x: float):
        self.__x = x
    
    def set_y(self, y: float):
        self.__y = y
    
    def set_z(self, z: float):
        self.__z = z
    
    def get_dx(self) -> float:
        return self.__dx
    
    def get_dy(self) -> float:
        return self.__dy
    
    def get_dz(self) -> float:
        return self.__dz
    
    def set_dx(self, dx: float):
        self.__dx = dx
    
    def set_dy(self, dy: float):
        self.__dy = dy
    
    def set_dz(self, dz: float):
        self.__dz = dz


class Elemento:
    def __init__(self, descricao: str, no_a: No, no_b: No):
        self.__descricao = descricao
        self.__no_a = no_a
        self.__no_b = no_b
    
    def get_descricao(self) -> str:
        return self.__descricao
    
    def set_no_a(self, no):
        self.__no_a = no
    
    def set_no_b(self, no):
        self.__no_b = no
    
    def get_no_a(self) -> No:
        return self.__no_a
    
    def get_no_b(self) -> No:
        return self.__no_b
    
    def get_comprimento(self) -> float:
        return abs(math.sqrt( (self.get_no_b().get_x() - self.get_no_a().get_x())**2 + (self.get_no_b().get_y() - self.get_no_a().get_y())**2 ))

__coordenadas = []

def input_coordenadas(descricao, x, y, z):
    __coordenadas.append(No(descricao, x, y, z))

def listar_coordenadas():
    print('{0:_^80}'.format(''))
    print('{0:_^20}|{1:_^19}|{2:_^19}|{3:_^19}'.format('[ Descricao ]', '[ x ]', '[ y ]', '[ z ]'))
    for coordenada in __coordenadas:
        print('{0: <19}|{1: ^19}|{2: ^19}|{3: ^19}'.format(
            coordenada.get_descricao(),
            coordenada.get_x(), 
            coordenada.get_y(), 
            coordenada.get_z()))


import sqlite3

if __name__ == "__main__":
    malha = list()

    malha.append(Elemento('Elemento 1', No('', 1., 0.), No('', 4., 0.)))
    malha.append(Elemento('Elemento 3', No('', 4., 0.), No('', 5., 2.)))
    malha.append(Elemento('Elemento 3', No('', 5., 2.), No('', 8., 2.)))

    for elemento in malha:
        print('{0:.<40}{1:.>30.3f}'.format(elemento.get_descricao(), elemento.get_comprimento()))


    # input_coordenadas('No 1', 1, 1, 1)
    # input_coordenadas('No 2', 1, 2, 2)
    # input_coordenadas('No 3', 2, 1, 1)
    # input_coordenadas('No 4', 2, 1, 1)
    # input_coordenadas('No 5', 2, 1, 1)
    # input_coordenadas('No 6', 2, 1, 1)
    # listar_coordenadas()

    # conn = sqlite3.connect(':memory:')
    # c = conn.cursor()

    # c.execute('''CREATE TABLE teste (date text, descricao text) ''')
    # c.execute("INSERT INTO teste values('1', 'Teste 1')")
    # c.execute("INSERT INTO teste values('2', 'Teste 2')")
    # c.execute("INSERT INTO teste values('2', 'Teste 3')")

    # conn.commit()

    # for row in c.execute('select * from teste'):
    #     print(row)
    



# x = np.array([
#     [20, 4],
#     [4, 32]
# ])

# y = np.array(
#     [20, -32]
# )
# z = np.linalg.solve(x, -y)
# print(x)
# print()
# print(z)
# print()
# print()

# x = np.array([[25/48, 0, 3/8], [0, 5/9, 1/6], [3/8, 1/6, 5/3]])
# y = np.array([[-10], [6], [0]])

# z = np.linalg.solve(x, -y)
# print(x)
# print()
# print(z)
# print()
# print()

# x = np.array([
#     [25/48, 0, 3/8, -1/3, 0, 0],
#     [0, 37/72, 1/12, 0, -1/72, 0],
#     [3/8, 1/12, 3/2, 0, -1/12, 0],
#     [-1/3, 0, 0, 25/48, 0, 3/8],
#     [0, -1/72, -1/12, 0, 37/72, 0],
#     [0, 0, 0, 3/8, 0, 1]])

# y = np.array([
#     [-10],
#     [37.5],
#     [45],
#     [0],
#     [22.5],
#     [0]])

# z = np.linalg.solve(x, -y)
# print(x)
# print()
# print(z)

# import math

# # Alongamento/Encurtamento
# def d1(a, b):
#     return (a * (math.sqrt(2) / 2)) - (b * (math.sqrt(2) / 2))

# def d2(a, b):
#     return a

# def d3(a, b):
#     return (a * (math.sqrt(2) / 2)) + (b * (math.sqrt(2) / 2))

# def d4(a, b):
#     return (-a * (math.sqrt(2) / 2)) + (b * (math.sqrt(2) / 2))

# L = 1.

# L1 = L * math.sqrt(2)
# L2 = L
# L3 = L * math.sqrt(2)
# L4 = L * math.sqrt(2)

# E = 1.
# A = 1.
# P = 1.

# # Deformacoes
# def E1(a, b):
#     return d1(a, b) / (L * math.sqrt(2))

# def E2(a, b):
#     return d2(a, b) / L

# def E3(a, b):
#     return d3(a, b) / (L * math.sqrt(2))

# def E4(a, b):
#     return d4(a, b) / (L * math.sqrt(2))

# # Esforcos Normais

# def N1(a, b):
#     return ((E * A) / 2 * L) * (a - b)

# def N2(a, b):
#     return ((E * A) / L) * (a)

# def N3(a, b):
#     return ((E * A) / 2 * L) * (a + b)

# def N4(a, b):
#     return ((E * A) / 2 * L) * (-a + b)

# def Fx(a, b):
#     return (-N1(a, b) * (math.sqrt(2) / 2)) - N2(a, b) - (N3(a, b) * (math.sqrt(2) / 2)) + (N4(a, b) * (math.sqrt(2) / 2)) + P

# def Fy(a, b):
#     return N1(a, b) * (math.sqrt(2) / 2) - N3(a, b) * (math.sqrt(2) / 2) - N4(a, b) * (math.sqrt(2) / 2)

# if __name__ == "__main__":

#     a = .515
#     b = .171

#     print('Fx={:,.3f}'.format(Fx(a, b)))
#     print('Fy={:,.3f}'.format(Fy(a, b)))

#     print('')
#     print('d1={:,.3f}'.format(d1(a, b)))
#     print('d2={:,.3f}'.format(d2(a, b)))
#     print('d3={:,.3f}'.format(d3(a, b)))
#     print('d4={:,.3f}'.format(d4(a, b)))

#     print('')
#     print('E1={:,.3f}'.format(E1(a, b)))
#     print('E2={:,.3f}'.format(E2(a, b)))
#     print('E3={:,.3f}'.format(E3(a, b)))
#     print('E4={:,.3f}'.format(E4(a, b)))

#     print('')
#     print('N1={:,.3f}'.format(N1(a, b)))
#     print('N2={:,.3f}'.format(N2(a, b)))
#     print('N3={:,.3f}'.format(N3(a, b)))
#     print('N4={:,.3f}'.format(N4(a, b)))