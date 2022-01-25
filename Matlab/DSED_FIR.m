[data, fs] = audioread('haha.wav');
f = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
x = load("sample_out_round.dat")/127;
x = x(2:end);
diff = f-x;
hold on;
plot(diff, 'g')
plot(f, 'b');
plot(x, 'r');
hold off;