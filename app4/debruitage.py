import numpy as np
import pytest
from scipy.signal import bilinear, butter, buttord

FE = 1600


class FilterArgs:
    def __init__(self, wp, ws, gpass, gstop, fs):
        self.wp = wp
        self.ws = ws
        self.gpass = gpass
        self.gstop = gstop
        self.fs = fs


def butter_filter(args, fs=FE):
    butter_args = buttord(
        wp=args.wp, ws=args.ws, gpass=args.gpass, gstop=args.gstop, fs=args.fs
    )
    num, den = butter(*butter_args, fs=fs)
    num_digital, den_digital = bilinear(num, den)
    return num_digital, den_digital


def main():
    butter_args = FilterArgs(500, 750, 0.2, 60, fs=FE)

    num_digital, den_digital = butter_filter(butter_args)

    print("Digital numerator coefficients:", num_digital)
    print("Digital denominator coefficients:", den_digital)


# def test_butter_filter():
#     butter_args = FilterArgs(500, 750, 0.2, 60, fs=FE)

#     num_digital, den_digital = butter_filter(butter_args)

#     print("Digital numerator coefficients:", num_digital)
#     print("Digital denominator coefficients:", den_digital)

#     if num_digital is not None and den_digital is not None:
#         assert np.testing.assert_allclose(
#             actual=num_digital,
#             desired=np.array(
#                 [
#                     0.58905803,
#                     -0.98176339,
#                     0.65450892,
#                     -0.21816964,
#                     0.03636161,
#                     -0.00242411,
#                 ]
#             ),
#         )
#         assert pytest.approx(den_digital) == pytest.approx(
#             [
#                 1.0,
#                 -3.0684835,
#                 3.92551916,
#                 -2.62681375,
#                 0.92318164,
#                 -0.13693283,
#             ]
#         )

if __name__ == "__main__":
    main()
