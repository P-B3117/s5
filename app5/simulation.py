import numpy as np
import matplotlib.pyplot as plt


N = 10000  # nombre de joueurs simulés
mu = 280.58  # moyenne temps de jeu
sigma = 50.38  # écart-type
T_max = 1000  # temps de simulation


def simulate(rate):
    # Génération des arrivées
    arrival_times = []
    t = 0

    while t < T_max:
        U = np.random.rand()
        P = -np.log(U) / rate
        t += P
        arrival_times.append(t)

    arrival_times = np.array(arrival_times)

    # Temps de jeu
    Q = np.random.normal(mu, sigma, len(arrival_times))
    Q = np.maximum(Q, 0)

    # Histogrammes
    plt.figure()
    plt.subplot(2, 1, 1)
    plt.hist(np.diff(np.insert(arrival_times, 0, 0)), bins=50)
    plt.title(f"Temps entre arrivées (lambda={rate})")

    plt.subplot(2, 1, 2)
    plt.hist(Q, bins=50)
    plt.title(f"Temps de jeu (lambda={rate})")

    counts = []
    for t in np.linspace(T_max * 0.5, T_max, 1000):
        active = (arrival_times <= t) & (arrival_times + Q >= t)
        counts.append(np.sum(active))

    return np.mean(counts)


print("Nombre moyen de joueurs connectés :")
for rate in [10, 50, 100]:
    avg = simulate(rate)
    print(f"lambda = {rate} -> {avg:.2f} joueurs")


try:
    plt.show()
except KeyboardInterrupt:
    plt.close("all")
