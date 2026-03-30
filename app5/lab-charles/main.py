import matplotlib.pyplot as plt
import numpy as np
from numpy._core import sqrt
from numpy.typing import NDArray

N = 10000


def generate_random_array(size: int, span: float = 1.0) -> NDArray[np.float64]:
    return np.random.randn(size, 1) * span


def normalize(array: NDArray[np.float64], center: float, standard_deviation: float):
    return (array * standard_deviation) + center


def plot_histogram(array, bins=10, range=None, title="Histogram"):
    plt.figure()
    plt.title(title)
    plt.hist(array, bins=bins, range=range)


def L2():
    u1 = generate_random_array(N)
    data = normalize(u1, 10, 2)
    plot_histogram(data, bins=15, title="L2 Histogram")


def box_muller(u1: NDArray[np.float64], u2: NDArray[np.float64]) -> NDArray[np.float64]:
    if u1.shape != u2.shape:
        raise ValueError("u1 and u2 must have the same shape")

    out = np.sqrt(-2 * np.log(u1)) * np.cos(2 * np.pi * u2)

    return out


def L3():
    u1 = generate_random_array(N)
    u2 = generate_random_array(N)
    data = box_muller(u1, u2)
    data = normalize(data, 10, 2)
    plot_histogram(data, bins=15, title="L3 Histogram")


def approx_cdf(array: NDArray[np.float64]) -> NDArray[np.float64]:
    return 0.5 * (1 + np.sqrt(1 - np.exp(-np.power(array, 2) * np.sqrt(np.pi / 8))))


def approx_negative_cdf(array: NDArray[np.float64]) -> NDArray[np.float64]:
    return 1 - approx_cdf(np.abs(array))


def L4():
    # a)
    stop = 5
    step = stop / N
    u1 = np.arange(0, stop, step)
    u2 = np.arange(-stop, 0, step)
    data1 = approx_cdf(u1)
    data2 = approx_negative_cdf(u2)
    data = np.append(data2, data1)
    u = np.append(u2, u1)
    plt.figure()
    plt.title("L4 a)")
    plt.plot(u, data)
    # b) I dont fucking know
    # u1 = generate_random_array(N)
    # u2 = generate_random_array(N)
    # data = box_muller(u1, u2)
    # data = normalize(data, 10, 2)
    # plot_histogram(data, bins=15, title="L4 b)")


def L5():
    pass


def main():
    L4()
    plt.show()


if __name__ == "__main__":
    main()
