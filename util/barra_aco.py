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
def listar_barras_aco() -> list:
    return ((5., .2),(6.3, 0.31),(8., .5),(10., .7),(12.5, 1.25),(16., 1.98),(20., 2.85),(22., 3.8),(25., 5.05))

def get_diametro_barra_from_diametro(diametro: float) -> float:
    for barra in listar_barras_aco():
        if barra[0] >= diametro and diametro < 25.:
            return barra[0]
        else:
            return 25.

def get_diametro_barra_from_area(area: float) -> float:
    for barra in listar_barras_aco():
        if barra[1] >= area and area < 5.05:
            return barra[0]
        else:
            return 25