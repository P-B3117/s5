#import "template.typ": *
#show: template.with(
  titre: "Rapport",
  cours: "Probabilité statistiques et simulations de Monte-Carlo",
  code: "GIF591",
  auteurs: (
    (nom: "Poulin-Bergevin, Charles", cip: "POUC1302"),
    (nom: "Stéphenne, Laurent", cip: "STEL2002"),
  ),
  date: "1er Avril 2026",
  auteurs_footer: true,
)

= Introduction

Il faut établir différents portraits statistiques sur le nouveau jeux vidéo de la compagnie ZeldUs et afin de compléter notre tâche de probabilitées statistiques, 3 mandats nous sont donnés.

= Probabilités

== Machine à sous

=== Probabilités d'acquisition de pouvoir

// Calculer les probabilités des 3 approches pour acquérir un pouvoir,
// pour chacun des 2 cas considérés :
//   mêmes pictogrammes,
//   pictogrammes différents,
//   2 fois mêmes pictogrammes sur 5 essais
// Moyenne et variance pour le cas iii)

Afin d'acquérir un pouvoir, dans les 3 approches, 2 cas sont évalués:
- une machine à sous avec 3 roues possédants 8 pictogrammes différents (cas 1)
- une machine à sous avec 5 roues possédants 4 pictogrammes différents (cas 2)

Pour les équations suivantes:
- $N$ est le nombre de roue
- $m$ est le nombre de pictogramme sur chaque roue

Afin de déterminer la probabilitée (p) d'acquisition d'un pouvoir si les roues ont toutes le même pictogramme, la formule mathématique suivante peut être utilisée.

$ p_"pareil" = Pi^N_0 1/m $ <prob-same>

Afin de déterminer la probabilitée (p) d'acquisition d'un pouvoir si les roues ont toutes un pictogramme différent, la formule mathématique suivante peut être utilisée.

$ p_"différent" = Pi^N_0 (m - (N + 1))/m $ <prob-diff>

Afin de déterminer la probabilitée (p) d'acquisition d'un pouvoir si les roues ont toutes le même pictogramme au moins 2 fois en 5 essais, la formule mathématique suivante peut être utilisée. $f$ représentant la fonction de distribution polynomiale exprimée sous la forme suivante où:

- $p$ représente la probabilitée de succès d'un seul essais
- $x$ le nombre d'essais à réussir
- $n$ le nombre d'essais totaux

$f(x) = P(X = x) = (#stack("n", "x"))p^x (1 - p)^(n - x)$

on peut dire que la probabilitée d'Avoir au moins 2 résultats pareils est la probabilitée de ne pas avoir seulement 0 ou 1 résultat pareil.

$ p_"2pareil" = 1 - f(0) - f(1) $ <prob-samesame>

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header("Approche", "cas 1", "cas 2"),
    "mêmes pictogrammes", [0.001953125], [0.0016],
    "pictogrammes différents", [0.65625], [0.192],
    "2 fois mêmes pictogrammes sur 5 essais", [$3.792389 * 10^-6$], [$2.55184 * 10^-6$],
  ),
  caption: "Tableau comparatif des probabilitées des différentes approches"
)<probs-approche>

Utilisant @prob-same, @prob-diff et @prob-samesame on peut donc calculer les résultats du @probs-approche.

=== Moyenne et variance de iii)

$ mu = E(x) = n*p $ <binomial-average>

$ mu = E(x) = n * p * (1 - p) $ <binomial-variance>

#figure(
  table(
    columns: (auto, auto, auto),
    inset: 10pt,
    align: horizon,
    table.header("2 fois mêmes pictogrammes sur 5 essais", "moyenne", "variance"),
    "cas 1", [$0.009765$], [$0.0097465$],
    "cas 2", [$0.008$], [$0.0079872$],
  ),
  caption: "Moyenne et Variance du cas iii)"
)<binomial-mean-and-variance>

En utilisant la fonction de moyenne (@binomial-average[]) et de variance (@binomial-variance[]), les résultats du tableau @binomial-mean-and-variance[] démontre la variance et la moyenne des deux cas pour l'approche en iii)


== Fléchettes
// Démontrer que X et Y sont indépendantes

=== Indépendance des variables <independance-des-variables>

L'indépendance de $X$ et $Y$ est claire car aucune relation n'est donnée pour $X$ et $Y$ a comme seule relation $Z$. Cela veut donc dire que $rho_(x y) = 0$ . À cause de cela la fonction de densitée devient:

$ f(x, y) = (frac(1, sqrt(2 pi) sigma_x) e^frac(-x^2, 2 sigma_x^2)) * (frac(1, sqrt(2 pi) sigma_y) e^frac(-y^2, 2 sigma_y^2)) = f(x) * f(y) $

La densité conjointe des 2 variables est équivalente à leurs densitée marginales respective, ce qui démontre qu'il n'y a aucun lien de dépendance entre les 2 variables.

// Covariance entre X et Y
=== Covariance entre $X$ et $Y$

$ sigma_(x y) = E[(X - mu_x)(Y - mu_y)] = E[X Y] - mu_x mu_y $ <fct-covariance>

Puisque les 2 variables sont indépendante, il est connu que la covariance de 2 variables indépendantes est de 0. Pour cela, il faut que la fonction @fct-covariance[] soit égale à 0.

$ sigma_(x y) = E[(X - mu_x)(Y - mu_y)] = E[X Y] - mu_x mu_y = 0 $ <fct-covariance-independance>

// Corrélation entre X et Y

=== Corrélation $X$ et $Y$

La corrélation est de 0 puisque $X$ et $Y$ sont indépendants comme expliqué dans la section @independance-des-variables[].

// Fonctions de densité de probabilité marginale f(x|z)
=== Fonctions de densité de probabilité marginale $f(x | z)$

$ f(x | z) = frac(1, sigma_x sqrt(2 pi)) e^(frac(-x^2, 2 (sigma_x)^2)) \
  f(x) = frac(1, 0.1 sqrt(2 pi)) e^(frac(-x^2, 2 (0.1)^2)) $ <densité-marginale-x>

En lisant l'énoncé, il est compris que x ne dépend nullement de z car l'écart type ($sigma$) ne change jamais (donc il n'est pas affecté par z)

// Fonctions de densité de probabilité marginale f(y|z)
=== Fonctions de densité de probabilité marginale $f(y | z)$

$ f(y | z) = frac(1, sigma_y (z) sqrt(2 pi)) e^(frac(-x^2, 2 (sigma_y  (z))^2)) \
  f(y | z > 10) = frac(1, 0.4 sqrt(2 pi)) e^(frac(-x^2, 2 (0.4)^2)) \
  f(y | z < 1) = frac(1, 0.05 sqrt(2 pi)) e^(frac(-x^2, 2 (0.05)^2)) $ <densité-marginale-y>

// Fonctions de densité de probabilité conditionnelle f(x, y|z)
=== Fonctions de densité de probabilité conditionnelle $f(x, y|z)$

$ f(x, y|z) = frac(1, sigma_y (z) sqrt(2 pi)) e^(frac(-x^2, 2 (sigma_y  (z))^2)) * frac(1, sigma_x sqrt(2 pi)) e^(frac(-x^2, 2 (sigma_x)^2)) \
f(x, y | z ) = frac(1, 2 pi sigma_x sigma_y (z)) * e^( -1/2 (frac(x^2, (sigma_x)^2) + frac(y^2, (sigma_y)^2 (z)) )) \
f(x, y | z > 10) = frac(1, 2 pi 0.1 * 0.4) * e^( -1/2 (frac(x^2, (0.1)^2) + frac(y^2, (0.4)^2) )) \
f(x, y | z < 10) = frac(1, 2 pi 0.1 * 0.05) * e^( -1/2 (frac(x^2, (0.1)^2) + frac(y^2, (0.05)^2) ))
$ <densité-marginale-xy>

La fonction de densité de probabilité conditionnelle se construit avec les équations de probabilitées marginales comme mentionné précedemment dans la section @independance-des-variables[]. On utilise donc les équations @densité-marginale-x[] et @densité-marginale-y[] en les multipliant ensembles afin d'obtenir la fonction @densité-marginale-xy[]

=== Probabilitées d'ouverture de la porte

#figure(
  table(
    columns: (auto, auto),
    inset: 10pt,
    align: horizon,
    table.header("Distance de tir", "Probabilité"),
    "z < 1m", [$0.5918$],
    "z > 10m", [$0.1166$],
  ),
  caption: "Probabilité d'ouverture de la porte en fonction de z"
)<resultats-monte-carlo-flechettes>

Afin d'évaluer la probabilité d'ouverture de la porte par le joueur, une simulation de monte-carlo avec 10 000 points a été produite afin d'obtenir les résultats présentés dans le tableau @resultats-monte-carlo-flechettes. Le code suivant a été utilisé pour établir ces résultats:

```python
class target:
    def __init__(
        self,
    ):
        self.center: tuple[float, float] = (0, 0)
        self.radius: float = 0.1

    def distance(self, point: tuple[float, float]) -> float:
        return (
            (point[0] - self.center[0]) ** 2 + (point[1] - self.center[1]) ** 2
        ) ** 0.5

    def contains(self, point: tuple[float, float]) -> bool:
        return self.distance(point) <= self.radius


def gen_points(
    sigma: tuple[float, float], mu: tuple[float, float], n: int
) -> list[tuple[float, float]]:
    xpoints = np.random.normal(mu[0], sigma[0], n)
    ypoints = np.random.normal(mu[1], sigma[1], n)

    return list(zip(xpoints, ypoints))


def flechettes():
    print("Testing flechette's probability with monte carlo")
    tar = target()

    sigma_x: float = 0.1  # écart-type
    mu_x: float = 0.0  # moyenne
    mu_y: float = 0.0  # moyenne
    n = 10000

    print(f"n = {n}")

    # z < 1m: sigma_y = 0.05
    print("z < 1m: sigma_y = 0.05")

    sigma_y: float = 0.05  # écart-type

    points = gen_points((sigma_x, sigma_y), (mu_x, mu_y), n)
    hits = sum(tar.contains(point) for point in points)
    print(f"    Hits: {hits}")
    print(f"    Probability: {hits / n}")

    # z > 10m: sigma_y = 0.4
    print("z > 10m: sigma_y = 0.4")

    sigma_y = 0.4

    points = gen_points((sigma_x, sigma_y), (mu_x, mu_y), n)
    hits = sum(tar.contains(point) for point in points)
    print(f"    Hits: {hits}")
    print(f"    Probability: {hits / n}")

if __name__ == "__main__":
    flechettes()
```

= Statistiques descriptives et inférence statistique

== Statistiques descriptives

Les données analysées correspondent aux temps de jeu hebdomadaires (en minutes) de 100 joueurs. Les statistiques descriptives obtenues sont présentées au tableau suivant.

#table(
  columns: 2,
  [*Mesure*], [*Valeur*],
  [Moyenne], [280.58],
  [Médiane], [279.0],
  [Mode], [291.0],
  [Variance], [2537.84],
  [Écart-type], [50.38],
  [Minimum], [148.0],
  [Maximum], [382.0],
  [Étendue], [234.0],
)

La moyenne et la médiane étant relativement proches, cela suggère une distribution globalement symétrique des données. L’écart-type relativement élevé (≈ 50 minutes) indique une dispersion notable autour de la moyenne.

== Histogramme et distribution des données

Les données ont été regroupées en 10 classes, déterminées à partir de la règle empirique :

$
  k approx sqrt{n}
$

avec $n = 100$.

#table(
  columns: 6,
  [*Classe*], [*Intervalle*], [*Centre*], [*Fréquence*], [*Fréq. relative*], [*Fréq. cumulée*],

  [1], [[148.00, 171.40]], [159.70], [2], [0.0200], [2],
  [2], [[171.40, 194.80]], [183.10], [3], [0.0300], [5],
  [3], [[194.80, 218.20]], [206.50], [5], [0.0500], [10],
  [4], [[218.20, 241.60]], [229.90], [8], [0.0800], [18],
  [5], [[241.60, 265.00]], [253.30], [19], [0.1900], [37],
  [6], [[265.00, 288.40]], [276.70], [21], [0.2100], [58],
  [7], [[288.40, 311.80]], [300.10], [16], [0.1600], [74],
  [8], [[311.80, 335.20]], [323.50], [10], [0.1000], [84],
  [9], [[335.20, 358.60]], [346.90], [8], [0.0800], [92],
  [10], [[358.60, 382.00]], [370.30], [8], [0.0800], [100],
)

L’histogramme présente une forme en cloche, suggérant une distribution normale des données.

#figure(
  image("hist-data.png"),
  caption: "Histogramme des temps de jeu hebdomadaires"
)

== Test de normalité

Un test de normalité de Shapiro-Wilk a été effectué.

- Statistique : 0.9895
- p-value : 0.628

Avec un seuil de signification $alpha = 0.05$, la p-value étant supérieure à $alpha$, on ne rejette pas l’hypothèse de normalité.

*Conclusion :* les données sont compatibles avec une distribution normale.

== Intervalle de confiance (95%)

L’intervalle de confiance pour la moyenne est donné par :

$
  "IC" = bar(x) +- z frac(s, sqrt(n))
$

avec $z = 1.96$.

$
  "IC"_"95%" = [270.71, 290.45]
$

Cela signifie qu’avec un niveau de confiance de 95%, la moyenne réelle se situe dans cet intervalle.

== Test d’hypothèse sur la moyenne

On teste l’hypothèse du patron :

- $H_0 : mu >= 300$
- $H_1 : mu < 300$

Statistique de test :

$
  Z = frac(bar(x) - mu_0, s / sqrt(n)) = -3.85
$

p-value :

$
  5.79 times 10^{-5}
$

Comme la p-value est inférieure à $alpha = 0.05$, on rejette $H_0$.

*Conclusion :* le temps de jeu moyen est inférieur à 300 minutes.

*Erreur de première espèce :* rejeter $H_0$ alors qu’elle est vraie.

== 2.6 Erreur de deuxième espèce

L’erreur de deuxième espèce correspond au fait de ne pas rejeter $H_0$ alors qu’elle est fausse.

$
  beta approx 0.0135
$

Cette valeur indique une faible probabilité de ne pas détecter une différence réelle.

== 2.7 Test d’hypothèse sur la variance

On teste :

- $H_0 : sigma = 50$

Statistique :

$
  chi^2 = 100.50
$

Intervalle critique :

$
  [73.36; 128.42]
$

Comme la statistique appartient à cet intervalle, on ne rejette pas $H_0$.

*Conclusion :* la variance observée est compatible avec 50.


= Simulations de Monte-Carlo

Afin d’estimer le nombre moyen de joueurs connectés à un instant donné, une simulation Monte-Carlo a été réalisée en modélisant les arrivées des joueurs comme un processus de Poisson de taux λ (joueurs/minute), et les temps entre arrivées comme des variables exponentielles générées par la méthode de transformation inverse suivante.

$
  T = -frac(ln(U), lambda), quad U ~ cal(U)(0, 1)
$

Les temps de jeu sont modélisés par une variable aléatoire normale ($Q ~ cal(N)(mu, sigma)$), avec :

- $mu = 280.58$ minutes
- $sigma = 50.38$ minutes

Ces paramètres proviennent de l’analyse statistique effectuée au mandat 2.
Chaque simulation utilise 1000 réalisations.

== Validation des distributions

#figure(
  image("hist-simulation.png"),
  caption: "Histogramme des temps de jeu et temps entre arrivées"
)

Les histogrammes obtenus montrent que :

- les temps entre arrivées suivent une distribution exponentielle décroissante
- les temps de jeu suivent une distribution normale en forme de cloche.

Ces observations confirment la validité des modèles probabilistes utilisés.

== Résultats

Les simulations ont été effectuées pour trois valeurs du taux d’arrivée λ :

#figure(
  table(
    columns: 2,
    [*λ (joueurs/min)*], [*Nombre moyen de joueurs*],
    [10], [2747.79],
    [50], [13851.17],
    [100], [28233.37],
  ),
  caption: "Résultats des simulations Monte-Carlo pour différentes valeurs de λ",
)


== Analyse

Les résultats obtenus montrent que le nombre moyen de joueurs connectés augmente proportionnellement au taux d’arrivée λ. Cette observation est cohérente avec le modèle théorique :

$
  N_"moyen" approx lambda times mu
$

Avec $mu approx 280.58$, les estimations théoriques sont :

- pour $lambda = 10$, environ 2806 joueurs
- pour $lambda = 50$, environ 14029 joueurs
- pour $lambda = 100$, environ 28058 joueurs

Les résultats simulés sont très proches de ces valeurs, ce qui valide la cohérence de la simulation.

= Conclusion

L’analyse statistique montre que :

- les données suivent une distribution normale
- le temps de jeu moyen est inférieur à 300 minutes
- la variance est cohérente avec une valeur de 50

Ces résultats indiquent que l’estimation initiale du patron est surestimée de 20 minutes, ce qui pourrait influencer les décisions liées à la conception du jeu.


La méthode Monte-Carlo permet d’estimer efficacement le nombre moyen de joueurs connectés en tenant compte de la variabilité des arrivées et des durées de jeu. Les résultats obtenus confirment que la charge des serveurs dépend directement du taux d’arrivée des joueurs et du temps moyen de jeu. Ces résultats peuvent être utilisés pour dimensionner adéquatement les infrastructures serveur en fonction de différents scénarios de fréquentation.
