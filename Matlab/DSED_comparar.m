x1 = load("sample_out.dat")/127;
x2 = load("sample_out_round.dat");
x3 = load("sample_out_normal.dat");
%sound(x2);
y1 = [0 x1'] - x2';
y2 = [0 x1'] - x3';
hold on;
plot(y1, 'g')
plot(y2, 'b')
hold off;