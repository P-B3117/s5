from typing import Callable

import matplotlib.pyplot as plt
import numpy as np
from scipy.signal import bilinear, butter, buttord, ellip, ellipord, freqz, lfilter

from assets import load_array, save_image
from zplane import zplane

FE = 1600


def toDb(x):
    return 20 * np.log10(x)


class FilterArgs:
    def __init__(self, wp, ws, gpass, gstop, fe):
        """
        ws and wp in Hz
        gpass and gstop in dB
        fe in Hz
        """
        self.wp = wp
        self.ws = ws
        self.gpass = gpass
        self.gstop = gstop
        self.fe = fe


def butter_filter(args):
    butter_args = buttord(
        wp=args.wp, ws=args.ws, gpass=args.gpass, gstop=args.gstop, fs=args.fe
    )
    num, den = butter(*butter_args, fs=args.fe)
    print(f"butter order: {butter_args[0]}")
    return num, den


def eliptic_filter(args):
    ord, wn = ellipord(
        wp=args.wp, ws=args.ws, gpass=args.gpass, gstop=args.gstop, fs=args.fe
    )
    num, den = ellip(N=ord, rp=args.gpass, rs=args.gstop, Wn=wn, fs=args.fe)
    print(f"eliptic order: {ord}")
    return num, den


def digital_filter(img: np.ndarray, type: str = "butter") -> np.ndarray:
    butter_args = FilterArgs(500, 750, 0.2, 60, fe=FE)
    elliptic_args = FilterArgs(500, 750, 0.2, 60, fe=FE)

    if type == "butter":
        num, den = butter_filter(butter_args)
    elif type == "elliptic":
        num, den = eliptic_filter(elliptic_args)
    else:
        raise ValueError(f"Unknown filter type: {type}")

    num_digital, den_digital = bilinear(num, den)

    print("Digital numerator coefficients:", num_digital)
    print("Digital denominator coefficients:", den_digital)

    zplane(num_digital, den_digital)
    plt.title(type)

    w, h = freqz(num_digital, den_digital)

    plt.figure()
    plt.plot(w, toDb(h))
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.title(type)
    plt.grid(True)
    filtered_img = lfilter(num_digital, den_digital, img)

    return filtered_img


def digital_filter_by_hand(img: np.ndarray) -> np.ndarray:
    # gotten by hand
    num_digital, den_digital = (
        [1 / 2.3915, 2 / 2.3915, 1 / 2.3915],
        [2.3915 / 2.3915, 1.107 / 2.3915, 0.5015 / 2.3915],
    )

    print("Digital numerator coefficients:", num_digital)
    print("Digital denominator coefficients:", den_digital)

    filtered_img = lfilter(num_digital, den_digital, img)

    zplane(np.poly(num_digital), np.poly(den_digital))
    plt.title("À la main")
    w, h = freqz(num_digital, den_digital)

    plt.figure()
    plt.plot(w, toDb(h))
    plt.xlabel("Frequency")
    plt.ylabel("Magnitude")
    plt.title("main")
    plt.grid(True)
    return filtered_img


def main():
    img = load_array("goldhill_bruit.npy")

    filtered_img = digital_filter(img, "butter")

    save_image(filtered_img, "goldhill_pas_bruit_butter.png")

    img = load_array("goldhill_bruit.npy")

    filtered_img = digital_filter(img, "elliptic")

    save_image(filtered_img, "goldhill_pas_bruit_elliptic.png")

    img = load_array("goldhill_bruit.npy")

    filtered_img = digital_filter_by_hand(img)

    save_image(filtered_img, "goldhill_pas_bruit_main.png")

    try:
        plt.show()
    except KeyboardInterrupt:
        plt.close("all")


if __name__ == "__main__":
    main()
