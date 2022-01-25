[data, fs] = audioread('haha.wav');
f = filter([0.039, 0.2422, 0.4453, 0.2422, 0.039],[1, 0, 0, 0, 0], data);
x = load("sample_out_round.dat")/127;
x2 = load("sample_out_normal.dat")/127;
x = x(2:end);
x2 = x2(2:end);
diff = f-x;
diff2 = f-x2;
hold on;
plot(diff, 'r')
plot(diff2, 'b')
title("Error del filtro real con respecto a uno de precisión infinita")
xlabel('n') 
ylabel('∆e') 
legend({'con redondeo','sin redondeo'},'Location','northeast')
hold off;