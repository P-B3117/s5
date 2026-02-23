import matplotlib.image as mpimg
import matplotlib.pyplot as plt
import numpy as np
from numpy.typing import ArrayLike
from scipy import signal

from zplane import zplane


def toDb(x):
    return 20 * np.log10(x)


print("FF 15")

K = 1
z1 = 0.8j
z2 = -0.8j
p1 = 0.95 * np.exp(1j * np.pi / 8)
p2 = 0.95 * np.exp(-1j * np.pi / 8)

num = np.poly([z1, z2])
den = np.poly([p1, p2])


# a)
def a1():
    zplane(num, den)
    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


# b)
# je sais pas

# c)
w, h = signal.freqz(num, den)


def c1():
    plt.figure()
    plt.plot(w, toDb(h))
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.title("Magnitude Response")
    plt.grid(True)

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


# d)
imp = np.concatenate([np.zeros(250), np.ones(1), np.zeros(250)])
y = signal.lfilter(num, den, imp)

y_fft = np.fft.fft(y)

span = np.linspace(0, len(y), len(y))


def d1():
    plt.subplot(2, 1, 1)
    plt.plot(span, y)
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.title("Magnitude Response")
    plt.grid(True)

    plt.subplot(2, 1, 2)
    plt.plot(span, y_fft)
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.title("Magnitude Response")
    plt.grid(True)

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


z1 = np.exp(1j * np.pi / 16)
z2 = np.exp(-1j * np.pi / 16)
# poles are near our zeroes, teacher said 0.95 * z would be good
p1 = 0.95 * np.exp(1j * np.pi / 16)
p2 = 0.95 * np.exp(-1j * np.pi / 16)

num = np.poly([z1, z2])
den = np.poly([p1, p2])

x = [(np.sin(n * np.pi / 16) + np.sin(n * np.pi / 32)) for n in range(500)]

x_filtered = signal.lfilter(num, den, x)


def a2():
    plt.figure()
    plt.subplot(2, 1, 1)
    plt.plot(x)
    plt.xlabel("time")
    plt.ylabel("Magnitude")
    plt.title("signal")
    plt.grid(True)

    plt.subplot(2, 1, 2)
    plt.plot(x_filtered)
    plt.xlabel("time")
    plt.ylabel("Magnitude")
    plt.title("signal filtered")
    plt.grid(True)

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


FE = 48000

butter_args = signal.buttord(2500, 3500, 0.2, 40, fs=FE)
num, den = signal.butter(*butter_args, fs=FE)


def a3():

    print(f"Filter order is: {butter_args[0]}")
    print(f"Poles are: {den}")
    print(f"Zeroes are: {num}")

    zplane(num, den)
    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


a3()
