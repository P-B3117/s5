#  Équation de la transformée en z du filtre inverse. (GIF570-C3 : 3 points)
#  Stabilité du filtre. (GIF570-C2 : 5 points)
#  Affichage des pôles et zéros de la fonction de transfert à appliquer (GIF570-C3 : 2 points)
#  Une image avec les aberrations et une image où les aberrations sont corrigées. (GIF570-C1 : 6 points)

import matplotlib.pyplot as plt
import numpy as np
from scipy import signal

from assets import load_array, load_image
from zplane import zplane


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

    image = load_array("goldhill_aberrations.npy")
    corrected = signal.lfilter(num, den, image)

    plt.figure()
    plt.imshow(corrected, cmap="gray")
    plt.title("Image corrigée")
    plt.axis("off")

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


def test_filter():
    """Makes sure that the filter's aberrations are as expected."""
    image = load_image("goldhill.png")

    num, den = filter_Hz()
    aberrated = signal.lfilter(num, den, image)

    np.testing.assert_array_equal(aberrated, load_array("goldhill_aberrations.npy"))


def test_correct_aberrations():
    """Makes sure that the image is correctly corrected."""
    image = load_array("goldhill_aberrations.npy")

    # Inversion pour obtenir le filtre inverse
    den, num = filter_Hz()
    corrected = signal.lfilter(num, den, image)

    np.testing.assert_array_almost_equal(corrected, load_image("goldhill.png"))
