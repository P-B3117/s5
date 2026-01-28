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

= Introduction

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
