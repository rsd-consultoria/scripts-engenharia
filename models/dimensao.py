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
class Dimensao:
    def __init__(self):
        self.__x: float = 0.
        self.__y: float = 0.
        self.__z: float = 0.
    
    def get_x(self) -> float:
        return self.__x

    def get_y(self) -> float:
        return self.__y

    def get_z(self) -> float:
        return self.__z

    def set_x(self, x: float):
        self.__x = x

    def set_y(self, y: float):
        self.__y = y

    def set_z(self, z: float):
        self.__z = z
    
    def __str__(self):
        return 'x={0} y={1} z={2}'.format(self.get_x(), self.get_y(), self.get_z())