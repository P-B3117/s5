import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, fftshift

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

PERIOD = 20
NB_OF_POINTS = 128


def x(n):
    return np.sin(0.1 * np.pi * n + (np.pi / 4))


signal = [x(n) for n in range(NB_OF_POINTS)]

plt.figure()
plt.stem(signal)
plt.title("Signal")
plt.xlabel("Time")
plt.ylabel("Amplitude")
plt.grid(True)  # good ol grid on

fft_result = fftshift(fft(signal))
han_result = fftshift(fft(signal * np.hanning(len(signal))))

span = 2 * np.pi
xpoints = np.linspace(-span / 2, span / 2, len(fft_result))

plt.figure()
plt.stem(xpoints, np.abs(fft_result))
plt.title("FFT")
plt.xlabel("Frequency")
plt.ylabel("Magnitude")
plt.xlim(-span / 2, span / 2)
plt.grid(True)  # good ol grid on


plt.figure()
plt.stem(xpoints, np.abs(han_result))
plt.title("FFT with Hanning Window")
plt.xlabel("Frequency")
plt.ylabel("Magnitude")
plt.xlim(-span / 2, span / 2)
plt.grid(True)  # good ol grid on

show()
