[data, fs] = audioread('haha.wav');
file = fopen('sample_in.dat','w');
fprintf(file, '%d\n', round(data.*127));