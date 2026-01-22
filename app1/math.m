A = [1 1 1 1];
B = [3 1];

result = A\B;
disp('division de matrice');
disp(result);

result = inv(A) * B;
disp('inversion de matrice')
disp(result)
