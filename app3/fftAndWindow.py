import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, fftshift
from scipy.signal.windows import hamming

NORMAL_SPAN = 2 * np.pi


def apply_fft(sig: np.ndarray, span=NORMAL_SPAN) -> tuple[np.ndarray, np.ndarray]:
    fft_filter = fftshift(fft(sig) * hamming(len(sig)))
    # fft_filter = fftshift(fft(sig) * np.hanning(len(sig)))

    xpoints = np.linspace(-span / 2, span / 2, len(fft_filter))

    return xpoints, fft_filter


def apply_fft_magnitude(
    sig: np.ndarray | None = None,
    xpoints: np.ndarray | None = None,
    fft_filter: np.ndarray | None = None,
) -> tuple[np.ndarray, np.ndarray]:

    if sig is None:
        if xpoints is not None and fft_filter is not None:
            return xpoints, np.abs(fft_filter)
        else:
            raise ValueError("Either sig or xpoints and fft_filter must be provided")

    xpoints, fft_filter = apply_fft(sig)

    return xpoints, np.abs(fft_filter)


def plot_fft(
    xpoints: np.ndarray, fft_filter: np.ndarray, span=NORMAL_SPAN, title="FFT"
):
    plt.figure()
    plt.stem(xpoints, np.abs(fft_filter))
    plt.title(title)
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.xlim(-span / 2, span / 2)
    plt.grid(True)  # good ol grid on


if __name__ == "__main__":
    from wavLoader import load_basson, load_guitare

    print("Plotting fft and magnitude of sounds using a Hamming window:")
    print()
    sample_rate, data = load_guitare()
    print(" - plotting for Guitar")
    xpoints, fft_filter = apply_fft(data)
    plot_fft(xpoints, fft_filter, title="FFT Guitar")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Guitar",
    )
    print()
    print(" - plotting for Bassoon")
    sample_rate, data = load_basson()
    xpoints, fft_filter = apply_fft(data)
    plot_fft(xpoints, fft_filter, title="FFT Bassoon")
    plot_fft(
        *apply_fft_magnitude(xpoints=xpoints, fft_filter=fft_filter),
        title="Magnitude Bassoon",
    )
    plt.show()
