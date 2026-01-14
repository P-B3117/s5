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
  auteurs_footer: false
)

= Introduction

Dans le cadre de cet APP, nous étudions le comportement d'un bras robotisé composé de deux segments de longueur identique $l_1 = l_2 = 25 "cm"$ L'objectif est de déterminer, à partir d'un angle d'entrée imposé, les positions, vitesses et accélérations du point terminal $A$, ainsi que les efforts et couples nécessaires pour maintenir ou accélérer le système.

Deux phases sont envisagées :

- Une phase cinématique : basée sur la géométrie et la dérivée des positions.
- Une phase statique et dynamique : basé sur l'analyse des forces et des moments agissant sur le système.

\
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
- φ : angle entre BA et OB

Les vitesses et accélérations angulaires associées sont, respectivement : $accent(θ, dot), accent(θ, dot.double), accent(φ, dot), accent(φ, dot.double)$.

L'objectif de l'analyse cinématique est de déterminer la position, la vitesse et l'accélération linéaires du point $A$, à partir des mouvements angulaires imposés.

\
== Mouvement de A dans le cas général

Étudions dans un premier temps le cas général, sans contrainte particulière sur les angles θ et φ. Il est possible de présenter le système de manière simplifiée comme suit :

#figure(
  image("image-1.jpg", width: 80%),
  caption: "Simplification visuelle du bras robotisé"
)

Il est donc possible de représenter la position du point $A$ par rapport à l'origine $O$ en utilisant la somme vectorielle des positions des segments OB et BA :

\ 
$
accent(O A, arrow) = vec(
  l_1*cos(θ) + l_2*cos(φ), 
  l_1*sin(θ) + l_2*sin(φ),
  0
)
$\

La vitesse du point $A$ s'obtient en dérivant la position par rapport au temps :

\
$
accent(O A, arrow) = vec(
  -l_1*sin(θ)*accent(θ, dot) - l_2*sin(φ)*accent(φ, dot), 
  l_1*cos(θ)*accent(θ, dot) + l_2*cos(φ)*accent(φ, dot),
  0
) 
$\

Et l'accélération en dérivant la vitesse par rapport au temps :

\
$
accent(O A, arrow) = vec(
  -l_1*(cos(θ)*accent(θ, dot)^2 + sin(θ)*accent(θ, dot.double)) - l_2*(cos(φ)*accent(φ, dot)^2 + sin(φ)*accent(φ, dot.double)),
  l_1*(-sin(θ)*accent(θ, dot)^2 + cos(θ)*accent(θ, dot.double)) + l_2*(sin(φ)*accent(φ, dot)^2 + cos(φ)*accent(φ, dot.double)),
  0
) 
$\

#pagebreak()
== Mouvement horizontal de A

Pour analyser le mouvement du point $A$, nous considérons deux cas particuliers basés sur les relations entre les angles $θ$ et $φ$.


$
x_A = l_1 cos(θ) + l_2 cos(φ)
$

où $φ$ est calculé comme :

$
φ = -θ
$\

Donc nous avons :

$
x_A = l_1 cos(θ) + l_2 cos(-θ) = (l_1 + l_2) cos(θ)
$\

La vitesse horizontale de $A$ est obtenue en dérivant la position par rapport au temps :

$
accent(x_A, dot) = -(l_1 + l_2) sin(θ) * accent(θ, dot)
$\

L'accélération horizontale de $A$ est obtenue en dérivant la vitesse par rapport au temps :

$
accent(x_A, dot.double) = -(l_1 + l_2) (cos(θ) * accent(θ, dot)^2 + sin(θ) * accent(θ, dot.double))
$

\
== Mouvement vertical de A

Pour analyser le mouvement vertical du point $A$, nous considérons la relation entre les angles θ et φ qui permet de privilégier un déplacement vertical du point terminal.

La position verticale de $A$ est donnée par :

$
y_A = l_1 sin(θ) + l_2 sin(φ)
$\

Dans cette configuration, l'angle $φ$ est calculé en fonction de $θ$ selon la relation trigonométrique suivante :

$
φ = arccos(1 - cos(θ))
$\

Cette expression résulte de la géométrie du triangle $O B A$ lorsque les longueurs $l_1$ et $l_2$ sont identiques.

La vitesse verticale du point $A$ est la dérivée temporelle de la position $y_A$ :

$
v_(y A) = (d_(y A))/(d t) = l_1*cos(θ)*accent(θ, dot) + l_2*cos(ϕ)*accent(ϕ, dot)​
$

Comme ϕ est une fonction de θ, dsa dérivée temporelle s'écrit :

$
accent(ϕ, dot) = (d ϕ)/(d θ) accent(θ, dot) &= (sin(θ)*accent(θ, dot))/(sqrt(1 - (1 - cos(θ))^2)) accent(θ, dot)\ &= (sin(θ)*accent(θ, dot))/(sqrt(cos(θ)(2 - cos(θ)))) accent(θ, dot)
$\

En substituant cette expression dans celle de la vitesse verticale, on obtient :

$
v_(y A) = l_1*cos(θ)*accent(θ, dot) + l_2*cos(arccos(1 - cos(θ)))*(sin(θ)*accent(θ, dot))/(sqrt(cos(θ)(2 - cos(θ)))) accent(θ, dot)
$\

On obtient ainsi une expression analytique de la vitesse verticale, qui peut être évaluée numériquement pour des valeurs spécifiques de $θ$ et $accent(θ, dot)$.
\ \

L'accélération verticale du point $A$ est la dérivée de la vitesse :

$
a_(y A) &= (d v_(y A))/(d t)\ &= l_1*(-sin(θ)*accent(θ, dot)^2 + cos(θ)*accent(θ, dot.double)) + l_2*(-sin(ϕ)*accent(ϕ, dot)^2 + cos(ϕ)*accent(ϕ, dot.double))​
$\


De nouveau, $ϕ$ et $accent(ϕ, dot)$ dépendent de $θ$ et de ses dérivées.

$
accent(ϕ, dot.double) = (d^2 ϕ)/(d θ^2) accent(θ, dot)^2 + (d ϕ)/(d θ) accent(θ, dot.double)
$

À cause de la complexité de ces expressions, il est courant de calculer numériquement la vitesse et l’accélération verticales à partir des positions $y_A$ discrètes pour chaque pas de temps. Cette approche assure la cohérence avec le mouvement géométrique et permet de valider les simulations MATLAB.

#pagebreak()
== Analyse des courbes obtenues avec MATLAB

Afin de valider les équations cinématiques établies précédemment, des simulations numériques ont été réalisées sous MATLAB.
Les expressions des positions, vitesses et accélérations du point terminal $A$ ont été implémentées pour les deux cas étudiés :

- Mouvement horizontal ($ϕ = -θ$),
- Mouvement vertical ($ϕ = arccos(1 - cos(θ))$).

Les figures suivantes présentent l'évolution de la position, de la vitesse et de l'accélération du point $A$ en fonction de l'angle moteur $θ$.
#figure(
  image("image-2.jpg", width: 80%),
  caption: "Position / Angle - La position de A varie de manière non linéaire avec θ"
)\

#figure(
  image("image-3.jpg", width: 80%),
  caption: "Vitesse / Angle - La vitesse du point A présente un comportement oscillatoire, cohérent avec la dérivée de cos(θ)"
)\

#figure(
  image("image-4.jpg", width: 80%),
  caption: "Accélération / Angle - L'accélération amplifie les variations observées sur la vitesse, comme attendu d'une dérivée seconde"
)\


== Relation entre $θ$ et $φ$ et les commande de $M_O$ et $M_B$

Le robot étudié comporte deux moteurs :

- $M_O$ à la base, qui contrôle l'angle $θ$ du premier segment,
- $M_B$ au coude, qui contrôle l'angle $φ$ du second segment.

Pour imposer un mouvement souhaité au point terminal $A$, les deux angles ne sont parfois plus indépendants : une relation géométrique est définie entre $θ$ et $φ$.

Les deux relations utilisées sont :

- Déplacement horizontal
  
  $
  φ = -θ
  $
  
  Les segments tournent de manière symétrique, ce qui maintient $A$ sur une ligne horizontale.
\
- Déplacement vertical
  
  $
  φ = arccos(1 - cos(θ))
  $
  
  Issue de la géométrie lorsque $l_1 = l_2$, cette relation oriente le mouvement principalement vers le haut.
\

Ainsi, lorsque $θ(t)$ est imposé par $M_O$, le moteur $M_B$ doit suivre automatiquement avec $φ(t) = f(θ(t))$. Les deux moteurs doivent donc être commandés de façon coordonnée pour que le point $A$ suive la trajectoire désirée.

= Statique & Dynamique

L’étude a été réalisée sur le segment $B A$, soumis à son poids propre et à la masse ponctuelle à $A$. Deux cas sont considérés : (1) un robot immobile (statique) et (2) un bras en rotation avec accélération angulaire constante (dynamique).


== Statique

Lorsque le bras est immobile, seules les forces de gravité agissent sur $B A$ et sur la masse ponctuelle $A$. Dans ce cas, les forces et moments sont calculés à partir de l'équilibre :

- Forces projetées sur B

$
F_(B A) = m_(B A) g cos(φ)
$

$
F_A = m_A g cos(φ)
$

$
F_B = F_(B A) + F_A
$\

- Moment au point B

  Le poids du bras est modélisé comme appliqué à son centre de gravité, soit à $l_2/2$ :

  $
  C_{B A} = m_(B A) g (l_2/2\)
  $

  $
  C_A = m_A g l_2
  $

  On obtient le couple externe à la jonction :

  $
  C_B = -(C_(B A) + C_A)
  $\

Ce couple oppose la gravité et doit être appliqué par le moteur pour maintenir le bras immobile.


== Dynamique

== Représentation avec MATLAB


== Analyse des courbes obtenues avec MATLAB
