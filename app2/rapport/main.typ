#import "template.typ": *
#show: template.with(
  titre: "Éléments de statique et de dynamique",
  cours: "Méchanique pour ingénieurs",
  code: "GEN441",
  auteurs: (
    (nom: "Poulin-Bergevin, Charles", cip: "POUC1302"),
    (nom: "Stéphenne, Laurent", cip: "STEL2002")
  ),
  date: "28 janvier 2026",
  auteurs_footer: true,
)

= Introduction

== Design du bassin

Les forces appliquées sur le participant sont la gravité, la flottabilité et la traînée hydrodynamique quadratique.

=== Forces appliquées

Par la 2e loi de Newton :
$m\frac{dv}{dt} = mg - k_f mg - b v^2 = mg(1-k_f) - b v^2$

En utilisant la transformation imposée :
$\frac{dv}{dt} = v\frac{dv}{dz}$

on obtient :
$m v \frac{dv}{dz} = mg(1-k_f) - b v^2$

À l’équilibre, ($\frac{dv}{dt}=0$), donc :
$mg(1-k_f) - b v_e^2 = 0$

$v_e = \sqrt{\frac{m g (1-k_f)}{b}}$

=== Linéarisation autour de l’équilibre

On linéarise le terme non linéaire (b v^2) autour de (v=v_e) par développement de Taylor du premier ordre :
$b v^2 \approx b\left(v_e^2 + 2v_e (v - v_e)\right)$

En remplaçant et en utilisant la relation d’équilibre ($b v_e^2 = mg(1-k_f)$), on obtient :
$m v \frac{dv}{dz} \approx -2 b v_e (v - v_e)$

Pour des vitesses proches de l’équilibre ($v \approx v_e$), on obtient :
$\frac{d(v-v_e)}{dz} = -\frac{2 b v_e}{m}(v-v_e)$

La solution de cette équation différentielle est :
$v(z) = v_e + (v_0 - v_e),e^{-\frac{2 b v_e}{m}z}$

où (v_0) est la vitesse d’entrée dans l’eau.

=== Vitesse initiale

La chute dans l’air est supposée sans traînée. Par conservation de l’énergie mécanique :
$mgh = \frac12 m v_0^2 \quad\Rightarrow\quad \boxed{v_0 = \sqrt{2gh}}$

=== Profondeur sécuritaire du bassin

La profondeur sécuritaire (\Delta z_{\text{bassin}}) est atteinte lorsque :
$v(\Delta z_{\text{bassin}}) = f_{\text{fin}},v_e\quad\text{avec}\quad f_{\text{fin}}=1.10$

En utilisant la solution précédente :
$f_{\text{fin}}v_e = v_e + (v_0 - v_e)e^{-\frac{2 b v_e}{m}\Delta z}$

Après isolement :
$\Delta z_{\text{bassin}} = \frac{m}{2 b v_e} \ln!\left(\frac{v_0 - v_e}{(f_{\text{fin}}-1)v_e}\right)$

=== Résultats obtenus

Vitesse initiale à l'entrée dans l'eau v_initiale = 14.0071 m/s
Vitesse limite dans l'eau v_equilibre = 0.91373 m/s
Profondeur sécuritaire du bassin Δz = 4.6244 m
