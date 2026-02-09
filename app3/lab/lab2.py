import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, fftshift
from scipy.signal import freqz

plt.ion()  # Turn on interactive mode


def show():
    try:
        while True:
            plt.pause(0.1)  # Pause for a short duration to allow event processing
    except KeyboardInterrupt:
        print("Ctrl+C pressed. Exiting loop.")
    finally:
        plt.close("all")  # Ensure the figure is closed
        plt.ioff()  # Turn off interactive mode


############################
#                          #
#      CODE BEGINNING      #
#                          #
############################

NB_OF_POINTS = 64  # N
F_CUT = 2000
FE = 16000
K = (2 * NB_OF_POINTS * (F_CUT / FE)) + 1


def low_pass(n):
    if n == 0:
        h = K / NB_OF_POINTS
    else:
        h = (1 / NB_OF_POINTS) * (
            np.sin(np.pi * n * (K / NB_OF_POINTS)) / np.sin(np.pi * (n / NB_OF_POINTS))
        )
    return h


filter = [
    low_pass(n)
    for n in np.linspace(
        -(NB_OF_POINTS - 1) / 2, (NB_OF_POINTS - 1) / 2 + 1, NB_OF_POINTS
    )
]

for _ in range(NB_OF_POINTS):
    filter.append(0)

span = 2 * np.pi
xpoints = np.linspace(-span / 2, span / 2, len(filter))

plt.figure()
plt.stem(xpoints, filter)
plt.title("Filter")
plt.xlabel("Time")
plt.ylabel("Amplitude")
plt.xlim(-span / 2, span / 2)
plt.grid(True)  # good ol grid on

fft_filter = fftshift(fft(filter))

span = 2 * np.pi
xpoints = np.linspace(-span / 2, span / 2, len(fft_filter))

plt.figure()
plt.stem(xpoints, np.abs(fft_filter))
plt.title("FFT")
plt.xlabel("Frequency")
plt.ylabel("Magnitude")
plt.xlim(-span / 2, span / 2)
plt.grid(True)  # good ol grid on

plt.figure()
plt.title("FREQZ")
freq_ans = freqz(filter, whole=True, plot=plt.stem)
plt.xlabel("Frequency")
plt.ylabel("Magnitude")
plt.grid(True)  # good ol grid on

amp = max(np.abs(fft_filter))
print()
print(f"Amplitude: {amp}")
print()

phase = np.angle(fft_filter)
span = 2 * np.pi
xpoints = np.linspace(-span / 2, span / 2, len(phase))

plt.figure()
plt.stem(xpoints, phase)
plt.title("Phase")
plt.xlabel("Frequency")
plt.ylabel("Phase")
plt.xlim(-span / 2, span / 2)
plt.grid(True)  # good ol grid on

show()
