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

Le présent rapport présente les résultats obtenus lors de l'analyse et de la synthèse d'un signal musical. Des filtres coupes bandes et passes bas RIF à coefficients égaux ont été utilisés pour extraire les paramètres du signal conformément au demandes.

= Schémas bloc

== Extraction des paramètres

Le signal de la note de guitare d'entrée est traité de deux façons. La première applique une fenêtre de Hanning puis une FFT pour extraire les $K = 32$ harmoniques dominantes (fréquences $f_k$, amplitudes $A_k$, phases $phi_k$). La seconde prend la valeur absolue du signal puis le filtre avec un filtre RIF passe-bas pour obtenir l'enveloppe temporelle normalisée.

#figure(
  image("fig_schema_extraction.svg"),
  caption: [Schéma bloc de l'extraction des paramètres],
)

== Synthèse du signal

Pour générer le signal de la note, il faut faire une somme de cosinus pondérés avec les 3 composants extraits, puis multiplier le résultat par l'enveloppe temporelle pour reproduire l'attaque et la décroissance de la note originale. Les fréquences extraites sont optionnellement décalées pour produire différentes notes.

#figure(
  image("fig_schema_synthese.svg"),
  caption: [Schéma bloc de la synthèse du signal],
)

= Analyse

== Spectres des signaux

TODO: affichage spectres de fourier guitare et basson. originaux et apres synthese. dB/Hz

#figure(
  image("fft-basson-avant-apres.svg",  height: 40%),
  caption: [Spectre de fourrier du basson avant et après synthèse],
) <fig-fft-basson>

#figure(
  image("fft-guitare-avant-apres.svg", height: 50%),
  caption: [Spectre de fourrier de la guitare avant synthèse],
) <fig-fft-guitare>

#figure(
  image("fft-basson-avant-apres.svg",  height: 40%),
  caption: [Spectre de fourrier du basson avant et après synthèse],
) <fig-fft-basson>

#figure(
  image("fft-guitare-avant-apres.svg", height: 50%),
  caption: [Spectre de fourrier de la guitare avant synthèse],
) <fig-fft-guitare>

== Harmoniques extraites

Le <tab-harmoniques> présente les fréquences, amplitudes et phases des 32 harmoniques les plus significatives extraites du signal de guitare. On remarque que les fréquences sont approximativement des multiples entiers de la fondamentale (466.08 Hz), ce qui est caractéristique d'un son musical harmonique. Le bruit du signal provient probablement du fait que l'enregistrement ne commence pas avec la note déjà en train de sonner, ce qui affecte notre résultat de fft (discontinuité du signal).

#figure(
  columns(2, gutter: 8pt)[
    #table(
      columns: (auto, auto, auto, auto),
      inset: 10pt,
      align: horizon,
      table.header([*$k$*], [*$F_k$*], [*$A_k$*], [*$phi_k$*]),
      [*1*], [466.08], [713.04], [-2.11],
      [*2*], [465.25], [639.08], [2.61],
      [*3*], [932.44], [269.34], [-0.60],
      [*4*], [931.61], [103.50], [0.64],
      [*5*], [462.77], [62.19], [0.64],
      [*6*], [2332.06], [58.21], [0.30],
      [*7*], [1865.43], [48.61], [1.01],
      [*8*], [1399.35], [35.31], [-1.62],
      [*9*], [933.82], [33.45], [0.81],
      [*10*], [463.88], [21.72], [-1.69],
      [*11*], [414.26], [20.61], [-2.63],
      [*12*], [2799.25], [17.59], [-1.80],
      [*13*], [230.97], [15.81], [-2.71],
      [*14*], [468.56], [15.29], [2.19],
      [*15*], [277.00], [12.41], [2.49],
      [*16*], [155.18], [9.62], [2.45],
    )

    #colbreak()

    #table(
      columns: (auto, auto, auto, auto),
      inset: 10pt,
      align: horizon,
      table.header([*$k$*], [*$F_k$*], [*$A_k$*], [*$phi_k$*]),

      [*17*], [469.67], [9.47], [0.96],
      [*18*], [461.67], [7.40], [0.26],
      [*19*], [206.99], [7.34], [2.31],
      [*20*], [470.49], [7.29], [0.21],
      [*21*], [621.53], [7.21], [1.49],
      [*22*], [1397.42], [6.82], [1.56],
      [*23*], [115.49], [6.40], [1.63],
      [*24*], [2329.31], [6.26], [-2.17],
      [*25*], [3733.89], [6.01], [-1.36],
      [*26*], [4201.90], [5.94], [1.28],
      [*27*], [1863.23], [5.08], [-1.96],
      [*28*], [471.87], [4.89], [-1.45],
      [*29*], [471.32], [4.81], [-0.67],
      [*30*], [936.30], [4.66], [-0.64],
      [*31*], [929.13], [4.28], [-1.81],
      [*32*], [472.42], [4.20], [-1.90],
    )
  ],
  caption: [Fréquences, amplitudes et phases des 32 harmoniques retenues],
) <tab-harmoniques>

== Enveloppe temporelle

#figure(
  image("enveloppe-basson.svg",  height: 50%),
  caption: [enveloppe temporelle du signal de basson avant filtrage coupe-bande],
) <fig-env-basson>

#figure(
  image("enveloppe-guitare.svg", height: 50%),
  caption: [enveloppe temporelle du signal de guitare],
) <fig-env-guitare>


= Filtre RIF et enveloppe

TODO: calculs et expliquer la longuer N du filtre

TODO: graphique de la réponse en fréquence du filtre

= Filtre RIF coupe-bande

== Équations

L'équation aux différences d'un filtre RIF d'ordre $N - 1$ est:
$ y(n) = sum_(k=0)^(N-1) h(k) dot x(n - k) $

La réponse impulsionnelle du filtre coupe-bande est construite à partir de la réponse impulsionnelle d'un filtre passe-bas. Le filtre passe-bas $h_("PB")$ de longueur $N$ centré sur la fréquence de coupure $f_c$ est défini par:
$
  h_("PB") (n) = cases(
    K / N & "si" n = 0,
    sin(K pi n \/ N) / (pi n \/ N dot N) & "si" n eq.not 0
  )
  "avec" K = 2 N f_c / F_e + 1
$

Le filtre coupe-bande est ensuite obtenu par modulation:
$ h_("CB") (n) = delta(n) - 2 dot h_("PB") (n) dot cos(omega_0 n) "avec" omega_0 = 2 pi f_c / F_e $

Les valeurs numériques des coefficients sont calculées avec $N = 6000$, $f_c = 1000$ Hz et $F_e = 44100$ Hz:
$ K = (2 times 6000 times 1000) / 44100 + 1 approx 273 $
$ omega_0 = (2 pi times 1000) / 44100 approx 0.1425 "rad/éch" $

Le filtrage est appliqué trois fois en cascade afin d'augmenter l'atténuation à la fréquence coupée.

== Graphiques et résultats

La @fig-hn présente la réponse impulsionnelle $h(n)$ du filtre coupe-bande. On observe une forme oscillante centrée autour de $n = 0$ dont l'amplitude décroit progressivement. La longueur du filtre ($N = 6000$ échantillons) détermine la sélectivité fréquentielle: plus $N$ est grand, plus la bande rejetée est étroite.

La @fig-1000hz montre l'effet du filtre sur une sinusoïde pure à 1000 Hz (exactement la fréquence à rejeter). Le signal d'entrée a une amplitude constante, alors que le signal de sortie est fortement atténué une fois le régime transitoire passé, confirmant le bon fonctionnement du filtre à cette fréquence.

La @fig-freq illustre la réponse en fréquence du filtre. Le graphique d'amplitude montre une atténuation marquée autour de 1000 Hz (creux étroit), tandis que les autres fréquences sont transmises sans modification significative (gain de 0 dB). Le graphique de phase montre la phase déroulée, qui reste linéaire en dehors de la bande rejetée, caractéristique d'un filtre RIF à phase linéaire.

La @fig-spectres compare les spectres d'amplitude du signal de basson avant et après filtrage. On constate la disparition de la composante parasite à 1000 Hz dans le signal filtré, alors que le reste du contenu spectral du basson est préservé. On voit aussi une grande quantité de bruit de 0 à 2000Hz, dû à l'effet du filtre.

#figure(
  image("fig_hn.svg"),
  caption: [Réponse impulsionnelle $h(n)$ du filtre coupe-bande],
) <fig-hn>

#figure(
  image("fig_reponse_1000hz.svg"),
  caption: [Réponse du filtre à un signal sinusoïdal de 1000 Hz],
) <fig-1000hz>

#figure(
  image("fig_amplitude_phase.svg"),
  caption: [Amplitude et phase de la réponse en fréquence du filtre coupe-bande],
) <fig-freq>

#figure(
  image("fig_spectres_basson.svg"),
  caption: [Spectres d'amplitude du signal de basson avant et après filtrage coupe-bande],
) <fig-spectres>

= Conclusion

Les performances des filtres et de la synthèse utilisée étaient satisfaisantes pour la problématique, mais la synthèse aurait vraiment pu sonner plus naturelle si on avait utilisées 100 harmoniques ou plus plutôt que 32. De plus, certains calculs auraient pu être optimisés pour améliorer les performances du système, mais cela ne faisait pas l'objet de cette problématique.
