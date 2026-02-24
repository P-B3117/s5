from typing import Callable

import numpy as np
from scipy.signal import bilinear, butter, buttord, lfilter

from assets import load_array, save_image

FE = 1600


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
    return num, den


def butter_filter_by_hand(args):
    # h(s) = ws / (s + ws)

    ws_norm = (2 * np.pi * args.wp) / args.fe
    # gauchissement des fréquences
    args.wp = 2 * args.fe * np.tan(ws_norm / 2)

    def H(s: float) -> float:
        return 1 / (pow((s / args.wp), 2) + ((s / args.wp) * np.sqrt(2)) + 1)

    return args, H


def bilinear_by_hand(args: FilterArgs, H_butter: Callable[[float], float]):

    def s(z):
        return (2 * args.fe) * ((z - 1) / (z + 1))

    def H(z):
        return H_butter(s(z))

    return H


def digital_filter(img: np.ndarray) -> np.ndarray:
    butter_args = FilterArgs(500, 750, 0.2, 60, fe=FE)

    num, den = butter_filter(butter_args)
    num_digital, den_digital = bilinear(num, den)

    print("Digital numerator coefficients:", num_digital)
    print("Digital denominator coefficients:", den_digital)

    filtered_img = lfilter(num_digital, den_digital, img)

    return filtered_img


def digital_filter_by_hand(img: np.ndarray) -> np.ndarray:
    butter_args = FilterArgs(500, 750, 0.2, 60, fe=FE)

    res = butter_filter_by_hand(butter_args)
    H = bilinear_by_hand(*res)

    output = np.array([H(z) for z in img])

    return output


def main():
    img = load_array("goldhill_bruit.npy")

    filtered_img = digital_filter(img)

    save_image(filtered_img, "goldhill_pas_bruit_python.png")

    filtered_img = digital_filter_by_hand(img)

    save_image(filtered_img, "goldhill_pas_bruit_main.png")


if __name__ == "__main__":
    main()
