% On cherche la déformation maximale du coussin.
% On peut ignorer la vitesse, car elle est nulle à l'impact.

m_participant = 80;
h_saut = 5;
a_gravite = 9.81;
k_coussin = 6000;

% e_initiale = m_participant * a_gravite * h_saut;
% e_finale = 1/2 * k_coussin * delta_h_coussin^2 - m_participant * a_gravite * delta_h_coussin;
% Donc (1/2 * k_coussin * x^2) - (m_participant * a_gravite * x) - (m_participant * a_gravite * h_saut) = 0
% On soustrait l'énergie potentielle du participant sur le coussin car on assume que h=0 à la surface du coussin.

% --- Résolution ---
a = 1/2 * k_coussin;
b = -1 * m_participant * a_gravite;
c = -1 * m_participant * a_gravite * h_saut;

solutions = roots([a, b, c]);

% On filtre pour garder la solution physiquement réaliste.
delta_h_coussin = solutions(solutions > 0 & solutions < h_saut);

if isempty(delta_h_coussin)
    disp("Aucune solution physique trouvée.");
else
    fprintf("La déformation maximale du coussin est de %.2f m.\n", delta_h_coussin);
end
