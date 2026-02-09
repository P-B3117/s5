import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import rfft, rfftfreq
from scipy.signal import lfilter

from sounds import load_basson, save_wav

F_CUT = 1000
BAND = 40
N = 6000


def delta(n):
    h = np.zeros_like(n)
    h[0] = 1
    return h


def h_filtre_passe_bas(n, Fe):
    w1 = 2 * np.pi * BAND / Fe  # fréquence de coupure

    h = np.zeros_like(n, dtype=float)

    h[n != 0] = np.sin(w1 * n[n != 0]) / (np.pi * n[n != 0])
    h[n == 0] = w1 / np.pi

    return h


def h_filtre_coupe_bande(n, Fe):
    w0 = 2 * np.pi * F_CUT / Fe

    return delta(n) - 2 * h_filtre_passe_bas(n, Fe) * np.cos(w0 * n)


if __name__ == "__main__":
    FE, basson = load_basson()

    n = np.linspace(-N / 2, N / 2, N)
    h = h_filtre_coupe_bande(n, FE)

    filtered = lfilter(h, 1, basson)
    filtered = lfilter(h, 1, filtered)
    filtered = lfilter(h, 1, filtered)

    # FFT
    freqs = rfftfreq(len(basson), d=1 / FE)
    basson_fft = np.abs(rfft(basson))
    filtered_fft = np.abs(rfft(filtered))

    plt.figure()
    plt.subplot(2, 1, 1)
    plt.plot(freqs, basson_fft)
    plt.title("Basson original")
    plt.xlabel("Fréquence (Hz)")
    plt.ylabel("Amplitude")

    plt.subplot(2, 1, 2)
    plt.plot(freqs, filtered_fft)
    plt.title("Basson filtré (coupe-bande 1 kHz)")
    plt.xlabel("Fréquence (Hz)")
    plt.ylabel("Amplitude")

    plt.tight_layout()
    plt.show()

    save_wav("basson_filtered.wav", FE, filtered)
