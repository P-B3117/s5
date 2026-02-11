import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import rfft
from scipy.signal.windows import hamming


def apply_window(sig: np.ndarray, window_func=hamming) -> np.ndarray:
    return sig * window_func(len(sig))


def apply_fft(sampling_rate: float, sig: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    fft_filter = rfft(sig)
    N = len(sig)

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
    fig = plt.figure()
    plt.plot(xpoints, 20 * np.log10(np.abs(fft_filter)))
    plt.title(title)
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.grid(True)  # good ol grid on

    return fig


if __name__ == "__main__":
    from sounds import load_basson, load_guitare

    print("Plotting fft and magnitude of sounds using a Hamming window:")
    print()
    sample_rate, data = load_guitare()
    print(" - plotting Guitare fft")
    xpoints, fft_filter = apply_fft(sample_rate, data)
    fig = plot_fft(xpoints, fft_filter, title="FFT Guitare")
    fig.savefig("rapport/fft-guitare.svg")
    print(" - plotting Guitare magnitude")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Guitar",
    )
    print()
    print(" - plotting Bassoon fft")
    sample_rate, data = load_basson()
    xpoints, fft_filter = apply_fft(sample_rate, data)
    fig = plot_fft(xpoints, fft_filter, title="FFT Basson")
    fig.savefig("rapport/fft-basson.svg")
    print(" - plotting Bassoon magnitude")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Bassoon",
    )

    plt.show()
