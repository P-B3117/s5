import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as signal
from scipy.fft import rfft, rfftfreq

from sounds import load_guitare, save_wav

K = 32

NOTE_DURATION = 0.6
NOTES = {
    "Do": -10,
    "Do#": -9,
    "Ré": -8,
    "Ré#": -7,
    "Mi": -6,
    "Fa": -5,
    "Fa#": -4,
    "Sol": -3,
    "Sol#": -2,
    "La": -1,
    "La#": 0,
    "Si": 1,
}


def extract_harmonics(x, Fe):
    N = len(x)

    # Window to reduce leakage
    w = np.hanning(N)
    xw = x * w

    X = rfft(xw)
    freq_axis = rfftfreq(N, d=1 / Fe)

    mag = np.abs(X)

    # Peak detection on magnitude
    peaks, _ = signal.find_peaks(mag)
    peak_mags = mag[peaks]

    # Sort peaks by magnitude (descending)
    idx = np.argsort(peak_mags)[::-1][:K]

    selected_bins = peaks[idx]
    freqs = freq_axis[selected_bins]
    amps = (2 * mag[selected_bins]) / N  # correct rFFT amplitude scaling
    phases = np.angle(X[selected_bins])

    return freqs, amps, phases


def extract_envelope(x, Fe, cutoff_norm=np.pi / 1000):
    xr = np.abs(x)

    w_c = cutoff_norm
    p = int(np.floor(np.pi / w_c) - 1)
    Nfir = p + 1

    h = np.ones(Nfir) / Nfir
    env = np.convolve(xr, h, mode="same")
    env /= np.max(env)

    return env, h


def synthesize_note(freqs, amps, phases, envelope, Fe, duration=None):
    if duration is None:
        N = len(envelope)
    else:
        N = int(Fe * duration)
        envelope = signal.resample(envelope, N)

    n = np.arange(N)
    xsum = np.zeros(N)

    for f, A, phi in zip(freqs, amps, phases):
        xsum += A * np.cos(2 * np.pi * f * n / Fe + phi)

    xout = envelope * xsum
    xout /= np.max(np.abs(xout))

    return xout


def note_shift(freqs, amps, phases, envelope, Fe, note):
    shifted_freqs = pow(2, NOTES[note] / 12) * freqs
    note_syn = synthesize_note(shifted_freqs, amps, phases, envelope, Fe, NOTE_DURATION)
    return note_syn


if __name__ == "__main__":
    Fe, x = load_guitare()

    freqs, amps, phases = extract_harmonics(x, Fe)
    envelope, h_env = extract_envelope(x, Fe)

    x_syn = synthesize_note(freqs, amps, phases, envelope, Fe)

    freqs_range = rfftfreq(len(x), d=1 / Fe)
    x_fft = np.abs(rfft(x))
    x_syn_fft = np.abs(rfft(x_syn))

    fig = plt.figure()
    plt.subplot(2, 1, 1)
    plt.plot(freqs_range, 20 * np.log10(np.abs(x_fft)))
    plt.title("Spectre de fourrier - note de guitare originale")
    plt.xlabel("Fréquence (Hz)")
    plt.ylabel("Amplitude")

    plt.subplot(2, 1, 2)
    plt.plot(freqs_range, 20 * np.log10(np.abs(x_syn_fft)), color="tab:orange")
    plt.title("Spectre de fourrier - note de guitare synthétisée")
    plt.xlabel("Fréquence (Hz)")
    plt.ylabel("Amplitude")

    plt.tight_layout()

    fig.savefig("rapport/fft-guitare-avant-apres.svg")

    plt.show()

    save_wav("synthetic_note_guitare.wav", Fe, x_syn)

    beethoven = np.array([])
    for note in ["Sol", "Sol", "Sol", "Mi", "-", "Fa", "Fa", "Fa", "Ré"]:
        if note == "-":
            beethoven = np.concatenate((beethoven, np.zeros(int(Fe * NOTE_DURATION))))
            continue

        note_syn = note_shift(freqs, amps, phases, envelope, Fe, note)
        beethoven = np.concatenate((beethoven, note_syn))

    save_wav("beethoven.wav", Fe, beethoven)
