import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import rfft
from scipy.signal.windows import hamming

NORMAL_SPAN = 2 * np.pi


def apply_window(sig: np.ndarray, window_func=hamming) -> np.ndarray:
    return sig * window_func(len(sig))


def apply_fft(sampling_rate: float, sig: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    fft_filter = rfft(sig)
    N = len(sig)
    # fft_filter = fftshift(fft(sig) * np.hanning(len(sig)))

    xpoints = np.fft.rfftfreq(N, d=1 / sampling_rate)

    return xpoints, fft_filter


def apply_fft_magnitude(
    sampling_rate: float | None = None,
    sig: np.ndarray | None = None,
    xpoints: np.ndarray | None = None,
    fft_filter: np.ndarray | None = None,
) -> tuple[np.ndarray, np.ndarray]:

    if sig is None or sampling_rate is None:
        if xpoints is not None and fft_filter is not None:
            return xpoints, np.abs(fft_filter)
        else:
            raise ValueError(
                "Either sig and sampling rates or xpoints and fft_filter must be provided"
            )

    xpoints, fft_filter = apply_fft(sampling_rate, sig)

    return xpoints, np.abs(fft_filter)


def plot_fft(xpoints: np.ndarray, fft_filter: np.ndarray, title="FFT"):
    print(len(xpoints))
    print(len(fft_filter))
    plt.figure()
    plt.stem(xpoints, np.abs(fft_filter))
    plt.title(title)
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.grid(True)  # good ol grid on


def test():
    from wavLoader import load_guitare

    fs, signal = load_guitare()
    N = len(signal)
    t = np.linspace(0, N / fs, N)

    # 3. Apply Windowing (Hann)
    windowed_signal = apply_window(signal)

    # 4. Perform Real FFT
    fft_out = np.fft.rfft(windowed_signal)
    freqs = np.fft.rfftfreq(N, d=1 / fs)
    mags = np.abs(fft_out)  # Calculate Magnitude

    # 5. Plotting
    plt.figure(figsize=(12, 6))

    # Plot the Time Domain (The Waveform)
    plt.subplot(2, 1, 1)
    plt.plot(t, signal, label="Original Signal", alpha=0.5)
    plt.plot(t, windowed_signal, label="Windowed Signal", color="red")
    plt.title("Time Domain: Signal before and after Windowing")
    plt.xlabel("Time [s]")
    plt.ylabel("Amplitude")
    plt.legend()
    plt.grid(True)

    # Plot the Frequency Domain (The Spectrum)
    plt.subplot(2, 1, 2)
    plt.plot(freqs, mags, color="blue")
    plt.title("Frequency Domain: FFT Result")
    plt.xlabel("Frequency [Hz]")
    plt.ylabel("Magnitude")
    plt.xlim(0, 2000)  # Zoom in to the relevant part of the spectrum
    plt.grid(True)

    plt.tight_layout()


if __name__ == "__main__":
    from wavLoader import load_basson, load_guitare

    print("Plotting fft and magnitude of sounds using a Hamming window:")
    print()
    sample_rate, data = load_guitare()
    print(" - plotting Guitare fft")
    xpoints, fft_filter = apply_fft(sample_rate, data)
    plot_fft(xpoints, fft_filter, title="FFT Guitar")
    print(" - plotting Guitare magnitude")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Guitar",
    )
    print()
    print(" - plotting Bassoon fft")
    sample_rate, data = load_basson()
    xpoints, fft_filter = apply_fft(sample_rate, data)
    plot_fft(xpoints, fft_filter, title="FFT Bassoon")
    print(" - plotting Bassoon magnitude")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Bassoon",
    )
    #
    # test()
    plt.show()
