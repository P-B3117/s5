import numpy as np

A = np.array([[4, 1], [2, 5]])


def quadratique(a, b, c):
    delta = (b * b) - (4 * a * c)
    if delta < 0:
        return None
    else:
        return (-b + np.sqrt(delta)) / (2 * a), (-b - np.sqrt(delta)) / (2 * a)


def transform(A, y):
    # inversion of the matrix A
    B = [[A[1][1], -A[0][1]], [-A[1][0], A[0][0]]]
    # substraction of the [[y, 0], [0, y]]
    B[0][0] = B[0][0] - y
    B[1][1] = B[1][1] - y
    return B


def mult(A, v):
    return [A[0][0] * v[0] + A[0][1] * v[1], A[1][0] * v[0] + A[1][1] * v[1]]


def get_v(A):
    return [-A[0][0] / A[0][1], 1]


a = 1
b = -(A[0][0] + A[1][1])
c = (A[0][0] * A[1][1]) - (A[0][1] * A[1][0])
print(a, b, c)
quad = quadratique(a, b, c)
assert quad is not None

print("Valeurs propres:")
print(f"  {quad[0]}")
print(f"  {quad[1]}")


A1 = transform(A, quad[0])
A2 = transform(A, quad[1])
print("Matrice soustraite par la matrice identité * la valeur propre")
print(f"  A1[{A1[0][0]} {A1[0][1]}]")
print(f"  A1[{A1[1][0]} {A1[1][1]}]")
print(f"  A2[{A2[0][0]} {A2[0][1]}]")
print(f"  A2[{A2[1][0]} {A2[1][1]}]")

#    A1[0][0]x + A1[0][1]y = 0
# et A1[1][0]x + A1[1][1]y = 0
# donc -A1[0][0]x / A1[0][1] = y

v1 = get_v(A1)
v2 = get_v(A2)
print("Vecteurs propres:")
print(f"  v1[{v1[0]} {v1[1]}]")
print(f"  v2[{v2[0]} {v2[1]}]")
