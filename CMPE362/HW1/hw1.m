% Let's create intro of fur elise,
% Intro of fur elise is comprised of these notes: E – D# – E – D# – E – B –
% D – C – A
% Frequencies of notes:
% E = 329.63
% D# = 311.13
% B = 246.94
% D = 293.66
% C = 261.63
% A = 220.00

% assume each of the notes will be played for 0.2 seconds
% there are 9 notes in total, which means in total, our wave will be 1.8
% seconds
srate = 44000;
note_sample1 = 0:1/srate:0.2
note_sample2 = 0:1/srate:0.4
amplitude = 0.25;
note1 = amplitude*sin(note_sample1 * 2 * pi * 300);
note2 = amplitude*sin(note_sample1 * 2 * pi * 2000);
note3 = amplitude*sin(note_sample1 * 2 * pi * 500);
note4 = amplitude*sin(note_sample1 * 2 * pi * 1200);
note5 = amplitude*sin(note_sample2 * 2 * pi * 600);
note6 = amplitude*sin(note_sample2 * 2 * pi * 800);
note7 = amplitude*sin(note_sample2 * 2 * pi * 3000);
note8 = amplitude*sin(note_sample2 * 2 * pi * 100);
note9 = amplitude*sin(note_sample2 * 2 * pi * 6000);


% this is just concatenation
melody = [note1 note2 note3 note4 note5 note6 note7 note8 note9];

plot(melody);

sound(melody, srate)

audiowrite("2019400288.wav", melody, srate);