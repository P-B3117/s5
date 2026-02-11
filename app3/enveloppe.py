import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import rfft
from scipy.signal.windows import hamming

from sounds import load_basson

low_pass_test_freq = np.pi / 1000
low_pass_test_gain_decibel = -3
low_pass_test_gain_linear = 10 ** (low_pass_test_gain_decibel / 20)


def normalize_frequency(frequency, sampling_rate):
    return 2 * np.pi * (frequency / sampling_rate)


def revert_normalize_frequency(frequency, sampling_rate):
    return (frequency * np.pi) * sampling_rate


def low_pass(order, cut_freq):
    N = order
    # formule de feuille de formule
    # h = (1 / N) * (np.sin(np.pi * n * (K / N)) / np.sin(np.pi * (n / N)))
    # page 122 lyons
    # h = (1 / N) * (np.sin(N * cut_freq / 2) / np.sin(cut_freq / 2))
    h = (1 / (N)) * np.abs(np.sin((N) * cut_freq / 2) / np.sin(cut_freq / 2))
    return h


def test_filter(sampling_rate, sig, cut_freq) -> int:
    # cos genre le filtre passe bas, la formule qui donne j'ai limpression qui veut qu'on genere autant de coefficients que de points mais c pas ça qui faut
    # faut juste l'ordre
    # mais la faut que je fasse un filtre, le pad, then verifie à la freq normalizée voulue, si c po correct je dois crinquer l'ordre, ainsi de suite
    # N dans les centaines
    order = 1

    print("testing orders")
    while True:
        # generate filter's gains
        mag = low_pass(order, cut_freq)
        # compare to required value
        if (  # we dont pass the requirements
            mag > low_pass_test_gain_linear
        ):
            order += 1
        else:  # we pass the requirements
            print(f" - good order: {order}")
            break

    # minimum order necessary to pass the requirements
    return order


def straigthen(sig):
    return np.abs(sig)


def enveloppe(sampling_rate, sig):
    straigthen(sig)

    cut_freq = low_pass_test_freq
    order = test_filter(sampling_rate, sig, cut_freq)

    h = np.ones(order) / order

    conv = np.convolve(sig, h, mode="same")

    env = conv / np.max(conv)

    return env


if __name__ == "__main__":
    from sounds import load_guitare

    sampling_rate, sig = load_guitare()
    env = enveloppe(sampling_rate, sig)

    fig = plt.figure()
    plt.plot(env)
    plt.title("Envelope guitare")
    plt.xlabel("Time")
    plt.ylabel("Amplitude")
    # plt.xlim(-span / 2, span / 2)
    plt.grid(True)  # good ol grid on

    fig.savefig("rapport/enveloppe-guitare.svg")

    sampling_rate, sig = load_basson()
    env = enveloppe(sampling_rate, sig)

    fig = plt.figure()
    plt.plot(env)
    plt.title("Envelope basson")
    plt.xlabel("Time")
    plt.ylabel("Amplitude")
    # plt.xlim(-span / 2, span / 2)
    plt.grid(True)  # good ol grid on

    fig.savefig("rapport/enveloppe-basson.svg")

    print("done")
    plt.show()
