load data;
load m8_1;
msequence = m;
fs = 200000;
fb = 2000;
rank = 8;
d = msequence;
nsamp = fs/fb
b = ones(1,nsamp);
c = d*b;
c = c';
ytx = reshape(c, [] , 1);
clear d b;
data = data*2-1;
DSTABLE = [];
for i = 1:length(data)
 DSTABLE = [DSTABLE ytx*data(i)];
end
dsss_table = reshape(DSTABLE,[],1)';
data = data(2:1000);
fc = 30000;
t = (0:length(dsss_table)-1)/fs;
mod_cos = cos(2*pi*t*fc);
out = dsss_table.*mod_cos;
SNR = 20;
out = awgn(out,SNR,'measured');