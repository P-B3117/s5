#import "template.typ": *
#show: template.with(
  titre: "Rapport",
  cours: "Traitement numérique des signaux",
  code: "GIF570",
  auteurs: (
    (nom: "Poulin-Bergevin, Charles", cip: "POUC1302"),
    (nom: "Stéphenne, Laurent", cip: "STEL2002"),
  ),
  date: "11 février 2026",
  auteurs_footer: true,
)

= Introduction

= Probabilitées

== Machine à sous

=== Probabilitées d'acquisition de pouvoir

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

$ p_"2pareil" =  1 - f(0) - f(1) $ <prob-samesame>

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
    caption: "Tableau comparatif des probabilitées des différentes approches",
)<probs-approche>

Utilisant @prob-same, @prob-diff et @prob-samesame on peut donc calculer les résultats du @probs-approche.

$ mu = E(x) = n*p $ <binomial-average>

$ mu = E(x) = n * p * (1 - p) $ <binomial-variance>

#figure(
    table(
      columns: (auto, auto, auto),
      inset: 10pt,
      align: horizon,
      table.header("2 fois mêmes pictogrammes sur 5 essais", "moyenne", "variance"),
      "cas 1", [$0.009765$], [$0.0097465$],
      "cas 1", [$0.008$], [$0.0079872$],
    ),
    caption: "Moyenne et Variance du cas iii)",
)<binomial-mean-and-variance>

En utilisant la fonction de moyenne (@binomial-average[]) et de variance (@binomial-variance[]), les résultats du tableau @binomial-mean-and-variance[] démontre la variance et la moyenne des deux cas pour l'approche en iii)


== Fléchettes
// Démontrer que X et Y sont indépendantes
// Covariance entre X et Y

$ sigma_(x y) = E[(X - mu_x)(Y - mu_y)] = E[X Y] - mu_x mu_y $ <fct-covariance>

Afin de déterminer l'indépendance de $X$ et $Y$, il faut prouver que la moyenne du produit de $X$ et $Y$ soit équivalente au produit de leurs moyenne respective.  Pour cela il faut que la fonction @fct-covariance[] soit égale à 0.

$ sigma_(x y) = E[(X - mu_x)(Y - mu_y)] = E[X Y] - mu_x mu_y = 0 $ <fct-covariance-independance>

Cela donne l'équation @fct-covariance-independance[].


// Corrélation entre X et Y
// Fonctions de densité de probabilité conditionnelle f(x, y|z)

$ P(B|A) = frac(P(A inter B), P(A)) $ <fct-prob-conjointe>

Afin de caractériser la position de la fléchette sur la cible, il faut utiliser la fonction de densité de probabilité conjointe (@fct-prob-conjointe).
// Fonctions de densité de probabilité marginale f(x|z)
// Fonctions de densité de probabilité marginale f(y|z)
// Probabilité que le personnage ouvre la porte < 1m
// Probabilité que le personnage ouvre la porte > 10 m

= Statistiques descriptives et inférence statistiques

= Simulations de Monte-Carlo

= Conclusion
