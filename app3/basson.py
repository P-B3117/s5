import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import rfft, rfftfreq
from scipy.signal import freqz, lfilter

from sounds import load_basson, save_wav

F_CUT = 1000
BAND = 40
N = 6000


def delta(n):
    h = np.zeros_like(n)
    h[0] = 1
    return h


def h_filtre_passe_bas(n, Fe):
    K = 2 * N * F_CUT / Fe + 1

    h = np.zeros_like(n)

    h[n != 0] = np.sin(K * np.pi * n[n != 0] / N) / (np.pi * n[n != 0] / N) / N
    h[n == 0] = K / N

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

    # h(n)
    fig1, ax1 = plt.subplots(figsize=(8, 4))
    ax1.plot(n, h, linewidth=0.5)
    ax1.set_title("Réponse impulsionnelle $h(n)$ du filtre coupe-bande")
    ax1.set_xlabel("$n$")
    ax1.set_ylabel("$h(n)$")
    ax1.grid(True, alpha=0.3)
    fig1.tight_layout()
    fig1.savefig("rapport/fig_hn.svg")

    # Réponse à un signal sinusoïdal de 1000 Hz
    t = np.arange(0, 0.1, 1 / FE)
    x_1000 = np.sin(2 * np.pi * F_CUT * t)
    y_1000 = lfilter(h, 1, x_1000)

    fig2, (ax2a, ax2b) = plt.subplots(2, 1, figsize=(8, 5), sharex=True)
    ax2a.plot(t * 1000, x_1000, linewidth=0.8)
    ax2a.set_title("Signal d'entrée à 1000 Hz")
    ax2b.set_xlabel("Temps (ms)")
    ax2a.set_ylabel("Amplitude")
    ax2a.grid(True, alpha=0.3)

    ax2b.plot(t * 1000, y_1000, linewidth=0.8, color="tab:orange")
    ax2b.set_title("Signal de sortie après filtre coupe-bande")
    ax2b.set_xlabel("Temps (ms)")
    ax2b.set_ylabel("Amplitude")
    ax2b.grid(True, alpha=0.3, which="both")
    fig2.tight_layout()
    fig2.savefig("rapport/fig_reponse_1000hz.svg")

    # Amplitude et phase de la réponse en fréquence
    w, H = freqz(h, worN=8192, fs=FE)

    fig3, (ax3a, ax3b) = plt.subplots(2, 1, figsize=(8, 5))
    ax3a.plot(w, 20 * np.log10(np.abs(H) + 1e-12), linewidth=0.7)
    ax3a.set_title("Réponse en fréquence — Amplitude")
    ax3a.set_xlabel("Fréquence (Hz)")
    ax3a.set_ylabel("Amplitude (dB)")
    ax3a.set_xlim(20, FE / 2)
    ax3a.grid(True, alpha=0.3, which="both")

    ax3b.plot(w, np.unwrap(np.angle(H)), linewidth=0.7, color="tab:orange")
    ax3b.set_title("Réponse en fréquence — Phase")
    ax3b.set_xlabel("Fréquence (Hz)")
    ax3b.set_ylabel("Phase (rad)")
    ax3b.set_xlim(20, FE / 2)
    ax3b.grid(True, alpha=0.3, which="both")
    fig3.tight_layout()
    fig3.savefig("rapport/fig_amplitude_phase.svg")

    # Spectres d'amplitude du basson avant et après filtrage
    freqs = rfftfreq(len(basson), d=1 / FE)
    basson_fft = np.abs(rfft(basson))
    filtered_fft = np.abs(rfft(filtered))

    fig4, (ax4a, ax4b) = plt.subplots(2, 1, figsize=(8, 5))
    ax4a.plot(freqs, 20 * np.log10(basson_fft + 1e-12), linewidth=0.5)
    ax4a.set_title("Spectre d'amplitude — Basson original")
    ax4a.set_xlabel("Fréquence (Hz)")
    ax4a.set_ylabel("Amplitude (dB)")
    ax4a.set_xlim(20, FE / 2)
    ax4a.grid(True, alpha=0.3, which="both")

    ax4b.plot(
        freqs, 20 * np.log10(filtered_fft + 1e-12), linewidth=0.5, color="tab:orange"
    )
    ax4b.set_title("Spectre d'amplitude — Basson filtré (coupe-bande 1 kHz)")
    ax4b.set_xlabel("Fréquence (Hz)")
    ax4b.set_ylabel("Amplitude (dB)")
    ax4b.set_xlim(20, FE / 2)
    ax4b.grid(True, alpha=0.3, which="both")
    fig4.tight_layout()
    fig4.savefig("rapport/fig_spectres_basson.svg")

    plt.show()

    save_wav("basson_filtered.wav", FE, filtered)
