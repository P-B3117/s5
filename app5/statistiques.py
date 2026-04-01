import numpy as np
import matplotlib.pyplot as plt
import statistics
import math
from scipy import stats

data = []

with open("data.txt", "r") as f:
    for line in f:
        data.append(float(line.strip()))

n = len(data)


mean = statistics.mean(data)
median = statistics.median(data)
mode = statistics.mode(data)
variance = statistics.variance(data)
std_dev = statistics.stdev(data)

minimum = min(data)
maximum = max(data)
range_val = maximum - minimum

print("STATISTIQUES DESCRIPTIVES")
print(f"Moyenne: {mean}")
print(f"Médiane: {median}")
print(f"Mode: {mode}")
print(f"Variance: {variance}")
print(f"Écart-type: {std_dev}")
print(f"Min: {minimum}")
print(f"Max: {maximum}")
print(f"Étendue: {range_val}")


k = int(math.sqrt(n))  # nombre de classes
counts, bins = np.histogram(data, bins=k)

print("TABLE DES CLASSES")
print("Classe | Limites | Centre | Fréquence | Fréq. relative | Fréq. cumulée")

cumulative = 0
for i in range(len(counts)):
    lower = bins[i]
    upper = bins[i + 1]
    center = (lower + upper) / 2
    freq = counts[i]
    rel_freq = freq / n
    cumulative += freq

    print(
        f"{i + 1} | [{lower:.2f}, {upper:.2f}] | {center:.2f} | {freq} | {rel_freq:.4f} | {cumulative}"
    )

# Histogramme
plt.hist(data, bins=k)
plt.xlabel("Temps de jeu (minutes)")
plt.ylabel("Fréquence")
plt.title("Histogramme des temps de jeu")
plt.show()


# Test de Shapiro-Wilk
stat, p_value = stats.shapiro(data)

print("TEST DE NORMALITÉ")
print(f"Statistique: {stat}")
print(f"p-value: {p_value}")

alpha = 0.05
if p_value > alpha:
    print("→ Données compatibles avec une loi normale")
else:
    print("→ Données NON normales")


z = 1.96  # valeur pour 95%
margin_error = z * std_dev / math.sqrt(n)
ci_lower = mean - margin_error
ci_upper = mean + margin_error

print("INTERVALLE DE CONFIANCE (95%)")
print(f"[{ci_lower}, {ci_upper}]")


mu0 = 300
z_stat = (mean - mu0) / (std_dev / math.sqrt(n))
p_value = stats.norm.cdf(z_stat)  # test unilatéral gauche

print("TEST D’HYPOTHÈSE (MOYENNE)")
print(f"Statistique Z: {z_stat}")
print(f"p-value: {p_value}")

if p_value < alpha:
    print("→ Rejeter H0 (temps moyen < 300)")
else:
    print("→ Ne pas rejeter H0")

print("Erreur de première espèce: rejeter H0 alors qu'elle est vraie")

# On suppose que la vraie moyenne = moyenne échantillon
mu_real = mean

# seuil critique
z_crit = stats.norm.ppf(alpha)
x_crit = mu0 + z_crit * (std_dev / math.sqrt(n))

beta = 1 - stats.norm.cdf((x_crit - mu_real) / (std_dev / math.sqrt(n)))

print("ERREUR DE DEUXIÈME ESPÈCE")
print(f"β ≈ {beta}")


sigma0 = 50

chi2_stat = (n - 1) * variance / (sigma0**2)

chi2_lower = stats.chi2.ppf(alpha / 2, df=n - 1)
chi2_upper = stats.chi2.ppf(1 - alpha / 2, df=n - 1)

print("TEST SUR LA VARIANCE")
print(f"Statistique chi²: {chi2_stat}")
print(f"Intervalle critique: [{chi2_lower}, {chi2_upper}]")

if chi2_stat < chi2_lower or chi2_stat > chi2_upper:
    print("→ Rejeter H0")
else:
    print("→ Ne pas rejeter H0")
