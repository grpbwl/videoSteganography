%% Create random data
data = uint8(randi([0 255], 10 , 1));

%% Bitshifting >> 4 bits
tic;
out1 = bitshift(data,-4,4); % Gets MSB
toc;

%% Dividing by 2^4 
tic;
out2 = data./(2^4);
toc;

%% Bitshifting << 4 bits then >> 4 bits
tic;
out3 = bitshift(data,0,4); % Gets LSB
toc;

%% Multiply by 2^4 then divide by 2^4
tic;
out4 = (bitshift(data,4,8))./(2^4);
toc;

%% Vars
depth = 4;
seeded_carrier = 163;
seed = 9;

%% Perform bit embedding one at a time
tic;
for lsb=1:depth
    seeded_carrier = bitset(seeded_carrier,lsb, bitget(seed,lsb));
end
toc;

%% Perform bit embedding one at a time
tic;
for lsb=1:depth
    seeded_carrier = bitset(seeded_carrier,lsb, 0);
end
seeded_carrier = bitor(seeded_carrier,seed);
toc;


%% Perform bit embedding using bitshifting
tic;
seeded_carrier = bitor(bitshift(bitshift(seeded_carrier,-depth),depth),seed);
toc;


