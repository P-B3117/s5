#import "template.typ": *
#show: template.with(
  titre: "Éléments de statique et de dynamique",
  cours: "Méchanique pour ingénieurs",
  code: "GEN441",
  auteurs: (
    (nom: "Brisson, Julien", cip: "BRIJ0701"),
    (nom: "Le Gallic, Martin", cip: "LEGM1303"),
    (nom: "Poulin-Bergevin, Charles", cip: "POUC1302"),
    (nom: "Stéphenne, Laurent", cip: "STEL2002")
  ),
  date: "14 janvier 2026",
)

= Introduction

Dans le cadre de cet APP, nous étudions le comportement d'un bras robotisé robotisé composé de deux segments de longueur identique $l_1 = l_2 = 25 "cm"$ L'objectif est de déterminer, à partir d'un angle d'entrée imposé, les positions, vitesses et accélérations du point terminal $A$, ainsi que les efforts et couples nécessaires pour maintenir ou accélérer le système.

Deux phases sont envisagées :

- Un phase cinématique : basé sur la géométrie et la dérivée des positions.
- Une phase statique et dynamique : basé sur l'analyse des forces et des moments agissant sur le système.

= Cinématique

Nous étudions un robot manipulateur planaire composé de deux barres rigides :

- OB : premier segment, de longueur $l_1$
- BA : deuxième segment, de longueur $l_2$


Les deux segments sont articulés aux points :

- O (base fixe),
- B (coude),
- A (extrémité manipulée).

Deux angles commandent le mouvement :

- θ : angle entre OB et l'horizontale
- ϕ : angle entre BA et OB

Les vitesses et accélérations angulaires associées sont, respectivement : $accent(θ, dot), accent(θ, dot.double), accent(ϕ, dot), accent(ϕ, dot.double)$.

L'objectif de l'analyse cinématique est de déterminer la position, la vitesse et l'accélération linéaires du point $A$, à partir des mouvements angulaires imposés.



== Mouvement de A dans le cas général

À partir de la géométrie du système, la position du point $A$ s'obtient par la somme vectorielle :

$ 
accent(O A, arrow) = accent(O B, arrow) + accent(B A, arrow)
$

Avec les représentations trigonométriques :

$
accent(O B, arrow) = l_1 vec(cos(θ), sin(θ)) quad quad
accent(B A, arrow) = l_2 vec(cos(θ + ϕ), sin(θ + ϕ))
$

Ainsi, les équations générales de position sont :

$
x_A = l_1 cos(θ) + l_2 cos(θ + ϕ) \
y_A = l_1 sin(θ) + l_2 sin(θ + ϕ)
$

Ces formules valent pour tout mouvement, tant que les angles θ et ϕ sont connus.

== Mouvement horizontal de A

Pour le mouvement horizontal, nous considérons uniquement la composante $x$ de la position. En utilisant MATLAB, les courbes de position, vitesse et accélération en fonction de l'angle $θ$ ont été générées. Les équations utilisées sont :

$
x_A = l_1 cos(θ) + l_2 cos(ϕ)
$

où $ϕ$ est calculé comme :

$
ϕ = -θ
$

Les résultats montrent que la position horizontale varie de manière non linéaire avec $θ$, tandis que la vitesse et l'accélération présentent des variations périodiques.

== Mouvement vertical de A

Pour le mouvement vertical, nous considérons uniquement la composante $y$ de la position. Les équations utilisées sont :

$
y_A = l_1 sin(θ) + l_2 sin(ϕ)
$

où $ϕ$ est calculé comme :

$
ϕ = arccos(1 - cos(θ))
$

Les courbes obtenues montrent des variations similaires à celles du mouvement horizontal, mais avec des amplitudes différentes en raison de la dépendance trigonométrique.


== Analyse des courbes obtenues avec MATLAB

es simulations MATLAB ont permis de valider les équations théoriques. Les courbes suivantes ont été générées :

1. *Position / Angle* : La position varie de manière non linéaire avec $θ$.
2. *Vitesse / Angle* : La vitesse présente des oscillations périodiques.
3. *Accélération / Angle* : L'accélération montre des variations périodiques plus marquées.

Ces résultats confirment la cohérence des équations cinématiques et leur adéquation pour modéliser le mouvement du système.


== Relation entre Q et J et les commande de MO et MB

= Statique & Dynamique

== Statique

== Dynamique

== Représentation avec MATLAB


== Analyse des courbes obtenues avec MATLAB
