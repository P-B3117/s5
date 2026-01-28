#import "template.typ": *
#show: template.with(
  titre: "Éléments de statique et de dynamique",
  cours: "Méchanique pour ingénieurs",
  code: "GEN441",
  auteurs: (
    (nom: "Poulin-Bergevin, Charles", cip: "POUC1302"),
    (nom: "Stéphenne, Laurent", cip: "STEL2002"),
  ),
  date: "28 janvier 2026",
  auteurs_footer: true,
)

= Démarches

== Calculs de la hauteur finale de la trajectoire

La trajectoire est considérée comme étant une fonction polynomiale de degré 4, du type: $$y(x) = a x^4 + b x^3 + c x^2 + d x + e$$

Puisque le but est de trouver la hauteur finale de la glissade. On dérive la fonction, ce qui nous donne l'angle de la pente, puis statuant que l'angle final ($x = 25$) devait être égal à 0:

$ theta = arctan((dif y) / (dif x)) $
$ 0 = arctan((dif ) / (dif x) a x^4 - b x^3 + c x^2 - d x + e) $

Les polynômes suivants pour les coefficients $a$, $b$, $c$, $d$, et $e$ sont trouvés essayant multiples équations (en statuant un nuage de hauteur finale possible dans les marges données dans le devis) jusqu'à trouver celle qui satisfait les conditions :

$a = 0.000567927$
$b = -0.033409$
$c = 0.637314$
$d = -4.62612$
$e = 30$

Ce qui donne une hauteur finale de 12,5m avec l'équation:

$ y(x) = 0.000567927 x^4 - 0.033409 x^3 + 0.637314 x^2 - 4.62612 x + 30 $

== Calculs pour le coefficient de friction ($mu _f$)

Après observation des points, nous avons traités la courbe de coefficient de friction en fonction de l'ouverture de la valve comme étant de degré 2, du type: $f(x) = a x^2 + b x + c$.

Après les calculs, nous avons trouvé les coefficients suivants :

$$a = 5.20979e-05 $$
$$b = -0.00916434 $$
$$c = 0.866783 $$

Ce qui donne :

$ mu(x) = 0.0000520979 x^2 - 0.00916434 x + 0.866783 $

La valeur d'erreur $r m s$ de $mu$ est de: 0.018041 ce qui est acceptable compte tenu qu'il représente 3% d'erreur pour la valeur de $mu$ finale obtenue.

== Calculs de vitesse du de la personne dans la glissade

Afin de calculer la vitesse de la personne descendant la glissade d'eau, nous avons utilisés les formules d'énergies de la manière suivante:

$ E_g = E_p + E_k + W $
$ F_f (x) = mu * m g * cos(theta) * x $
$ W = - integral^x_0 F_f (x) $
$ E_p = m g * h $
$ E_k = (m v²) / 2 $

où h est la hauteur du point x, W est le travail effectué jusqu'au point x et v est la vitesse au point x. En utilisant ces formules, on peut calculer la vitesse de la personne à tout moment x de la manière suivante:

$ v = sqrt(2g(h(0) - h(x) - W(x))) $

Cela est utile afin de déterminer la valeur finale de $mu$, Plusieurs $mu$ possibles sont testés et celui qui minimise l'erreur par rapport à la vitesse finale souhaitée est sélectionné (entre 20 et 25 $frac(k m, h)$). Pour atteindre cela, 22,5 $frac(k m, h)$ est visé et on vérifie que les valeurs minimales et maximales de vitesse arrivent dans les paramètres souhaités. La valeur finale trouvée est:

$ mu = 0.62 $

grâce à une ouverture de la valve de 33,1915%. Cela donne la vitesse finale de: 22.5511 $(k m)/h$ avec les vitesses maximales et minimales étants: 24.9647 $(k m)/h$ et 19.846 $(k m)/h$

== Design de la minuterie de la trappe

Le fonctionnement de la trappe dépend de la collision entre le participant et le "ballon-mouse". L'objectif est de déterminer le temps d'ouverture de la trappe ($Delta t_m$) pour discriminer les cas où le ballon est attrapé (G1) ou rebondit (G2).

=== Modélisation de la collision

On considère une collision unidimensionnelle parfaitement alignée.

1. Conservation de la quantité de mouvement :
  $m_p v_p + m_b v_b = m_p v'_p + m_b v'_b$

2. Coefficient de restitution ($e$) :
  $e = - frac(v'_b - v'_p, v_b - v_p)$

En isolant $v'_b$ dans l'équation de restitution ($v'_b = v'_p + e(v_p - v_b)$) et en substituant dans l'équation de la quantité de mouvement, on trouve la vitesse du participant après l'impact $v'_p$ :

$v'_p = frac(m_p v_p + m_b v_b - m_b e (v_p - v_b), m_p + m_b)$

=== Critères de la minuterie

La trappe de longueur $L_T$ s'ouvre après un délai $Delta t_m$.

- Cas G1 (Ballon attrapé, $e=0$) : Le participant doit avoir *quitté* la trappe avant l'ouverture.
  $Delta t_m > t_"G1" + text("marge") quad "avec" quad t_"G1" = L_T / v'_p(e=0)$

- Cas G2 (Rebond, $e=0.8$) : Le participant doit être *encore sur* la trappe lors de l'ouverture.
  $Delta t_m < t_"G2" - text("marge") quad "avec" quad t_"G2" = L_T / v'_p(e=0.8)$

Une solution viable existe si :
$t_"G1" + 0.02 < Delta t_m < t_"G2" - 0.02$

=== Résultats obtenus

G1 (e=0) : Vitesse après impact = 5.6038 m/s

G1 (e=0) : Temps pour quitter   = 0.5353 s

G2 (e=0.8) : Vitesse après impact = 5.0755 m/s

G2 (e=0.8) : Temps pour quitter   = 0.5911 s


== Design du coussin de trampoline

Pour valider la hauteur de déformation du coussin, nous utilisons le principe de conservation de l'énergie. L'énergie mécanique totale est conservée entre le moment du saut et le moment où la déformation du coussin est maximale (vitesse nulle).

Soit $h_"saut"$ la hauteur du saut, $m$ la masse du participant, $g$ l'accélération gravitationnelle et $k$ la constante de rappel du coussin. On définit $x = Delta h$ comme étant la déformation du coussin.

L'énergie initiale au sommet du saut (état 1) est purement potentielle gravitationnelle (référence $h=0$ à la surface du coussin) :
$ E_1 = m g h_"saut" $

Au moment de la compression maximale (état 2), le participant est à la hauteur $-x$. La vitesse est nulle, donc l'énergie cinétique est nulle. L'énergie est composée de l'énergie potentielle gravitationnelle et de l'énergie potentielle élastique du coussin :
$ E_2 = -m g x + frac(1, 2) k x^2 $

Par conservation de l'énergie ($E_1 = E_2$) :
$ m g h_"saut" = -m g x + frac(1, 2) k x^2 $

En réarrangeant les termes pour former une équation quadratique de la forme $a x^2 + b x + c = 0$ :
$ frac(1, 2) k x^2 - m g x - m g h_"saut" = 0 $

Les coefficients sont donc :
$
  a & = frac(1, 2) k \
  b & = -m g \
  c & = -m g h_"saut"
$

Nous résolvons cette équation pour $x$ et conservons la racine positive physiquement réaliste.

=== Résultats obtenus

La déformation maximale du coussin est de 1.28 m.


== Design du bassin

Les forces appliquées sur le participant sont la gravité, la flottabilité et la traînée hydrodynamique quadratique.

=== Forces appliquées

Par la 2e loi de Newton :
$m frac(d v, d t) = m g - k_f m g - b v^2 = m g(1-k_f) - b v^2$

En utilisant la transformation imposée :
$frac(d v, d t) = v frac(d v, d z)$

on obtient :
$m v frac(d v, d z) = m g(1-k_f) - b v^2$

À l’équilibre, ($frac(d v, d t)=0$), donc :
$m g (1-k_f) - b v_e^2 = 0$

$v_e = sqrt(frac(m g (1-k_f), b))$

=== Linéarisation autour de l’équilibre

On linéarise le terme non linéaire (b v^2) autour de (v=v_e) par développement de Taylor du premier ordre :
$b v^2 approx b v_e^2 + 2 b v_e (v - v_e)$

En remplaçant et en utilisant la relation d’équilibre ($b v_e^2 = m g(1-k_f)$), on obtient :
$m v frac(d v, d z) approx -2 b v_e (v - v_e)$

Pour des vitesses proches de l’équilibre ($v approx v_e$), on obtient :
$frac(d (v-v_e), d z) = -frac(2 b, m)(v-v_e)$

La solution de cette équation différentielle est :
$v(z) = v_e + (v_0 - v_e) e^{- frac(2 b, m) z}$

où (v_0) est la vitesse d’entrée dans l’eau.

=== Vitesse initiale

La chute dans l’air est supposée sans traînée. Par conservation de l’énergie mécanique :
$m g h = frac(12, m v_0^2)$
$v_0 = sqrt(2 g h)$

=== Profondeur sécuritaire du bassin

La profondeur sécuritaire ($Delta z_"bassin"$) est atteinte lorsque :
$v(Delta z_"bassin") = f_"fin",v_e$

En utilisant la solution précédente :
$f_"fin" v_e = v_e + (v_0 - v_e) e^{- frac(2 b, m) Delta z}$

Après isolement :
$Delta z_"bassin" = frac(m, 2 b) ln! frac(v_0 - v_e, (f_"fin"-1) v_e)$

=== Résultats obtenus

Vitesse initiale à l'entrée dans l'eau v_initiale = 14.0071 m/s
Vitesse limite dans l'eau v_equilibre = 0.91373 m/s
Profondeur sécuritaire du bassin Δz = 4.6244 m
