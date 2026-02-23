#  Équation de la transformée en z du filtre inverse. (GIF570-C3 : 3 points)
#  Stabilité du filtre. (GIF570-C2 : 5 points)
#  Affichage des pôles et zéros de la fonction de transfert à appliquer (GIF570-C3 : 2 points)
#  Une image avec les aberrations et une image où les aberrations sont corrigées. (GIF570-C1 : 6 points)

import matplotlib.pyplot as plt
from zplane import zplane
import numpy as np
from numpy.fft import fft, fftshift
from scipy import signal


def filter_Hz():
    K = 1
    z1 = 0.9 * np.exp(1j * np.pi / 2)
    z2 = 0.9 * np.exp(-1j * np.pi / 2)
    z3 = 0.95 * np.exp(1j * np.pi / 8)
    z4 = 0.95 * np.exp(-1j * np.pi / 8)
    p1 = 0
    p2 = -0.99
    p3 = -0.99
    p4 = 0.8

    num, den = signal.zpk2tf([z1, z2, z3, z4], [p1, p2, p3, p4], K)
    return num, den


if __name__ == "__main__":
    # Inversion pour obtenir le filtre inverse
    den, num = filter_Hz()
    w, h = signal.freqz(num, den)
    zplane(num, den)

    plt.figure()
    plt.plot(w, 20 * np.log10(np.abs(h)))
    plt.plot(w, np.angle(h))
    plt.title("Réponse en fréquence du filtre")
    plt.xlabel("Fréquence (rad/éch)")
    plt.ylabel("Amplitude (dB)")
    plt.grid()

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")
