import matplotlib.pyplot as plt
import numpy as np
from numpy.fft import fft, fftshift
from scipy import signal

from zplane import zplane

K = 1
z1 = 0.8j
z2 = -0.8j
p1 = 0.95 * np.exp(1j * np.pi / 8)
p2 = 0.95 * np.exp(-1j * np.pi / 8)

num, den = signal.zpk2tf([z1, z2], [p1, p2], K)

zplane(num, den)

w, h = signal.freqz(num, den)

plt.figure()
plt.plot(w, 20 * np.log10(np.abs(h)))
plt.plot(w, np.angle(h))
plt.title("Réponse en fréquence du filtre")
plt.xlabel("Fréquence (rad/éch)")
plt.ylabel("Amplitude (dB)")
plt.grid()

N = 500
impulsion = np.zeros(N)
impulsion[N // 2] = 1

impulsion_filtered = signal.lfilter(num, den, impulsion)
impulsion_filtered_fft = fftshift(fft(impulsion_filtered))

plt.figure()
plt.subplot(2, 1, 1)
plt.plot(impulsion_filtered)
plt.title("Réponse du filtre à une impulsion centrée")
plt.xlabel("n")
plt.ylabel("Amplitude (dB)")
plt.grid()

plt.subplot(2, 1, 2)
plt.plot(20 * np.log10(np.abs(impulsion_filtered_fft)))
plt.title("Réponse du filtre à une impulsion centrée")
plt.xlabel("Fréquence (rad/éch)")
plt.ylabel("Amplitude (dB)")
plt.grid()

try:
    plt.show()
except KeyboardInterrupt:
    plt.close("all")

K = 1
z1 = np.exp(1j * np.pi / 16)
z2 = np.exp(-1j * np.pi / 16)
p1 = 0.95 * np.exp(1j * np.pi / 16)
p2 = 0.95 * np.exp(-1j * np.pi / 16)

num, den = signal.zpk2tf([z1, z2], [p1, p2], K)

zplane(num, den)

w, h = signal.freqz(num, den)

plt.figure()
plt.plot(w, 20 * np.log10(np.abs(h)))
plt.plot(w, np.angle(h))
plt.title("Réponse en fréquence du filtre")
plt.xlabel("Fréquence (rad/éch)")
plt.ylabel("Amplitude (dB)")
plt.grid()

n = np.arange(N)
x = np.sin(n * np.pi / 16) + np.sin(n * np.pi / 32)

plt.figure()
plt.plot(n, x)
plt.title("Sortie du filtre")
plt.xlabel("n")
plt.ylabel("Amplitude (dB)")
plt.grid()

try:
    plt.show()
except KeyboardInterrupt:
    plt.close("all")

Fe = 48000

ord, wn = signal.buttord(2500, 3500, 0.2, 40, fs=Fe)
num, den = signal.butter(ord, wn, fs=Fe)

print("Ordre: ", ord)

zplane(num, den)


w, h = signal.freqz(num, den)

plt.figure()
plt.plot(w, 20 * np.log10(np.abs(h)))
plt.plot(w, np.angle(h))
plt.title("Réponse en fréquence du filtre")
plt.xlabel("Fréquence (rad/éch)")
plt.ylabel("Amplitude (dB)")
plt.grid()

try:
    plt.show()
except KeyboardInterrupt:
    plt.close("all")
