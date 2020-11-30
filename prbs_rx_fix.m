load m8_1;
load ir1; %odpowiedzi impulsowe
tx = out;
msequence = m;
fs = 200000;
fb = 2000;
rank = 8;
fsrx = fs;
nsamprx = fsrx/fb;
nfft = length(tx);
L = 2^rank-1;
b = ones(1,nsamprx);
c = msequence*b;
c = c';
ytx = reshape(c, [] , 1)';
hytx = hilbert(ytx);
receivedsignal = tx;
receivedsignal = receivedsignal./max(abs(receivedsignal));
t = (0:length(receivedsignal)-1)/fsrx;
[b,a] = butter(5,fc/fsrx);
size(receivedsignal);
size(t);
x1 = receivedsignal.*cos(2*pi*fc*t);
x2 = receivedsignal.*sin(2*pi*fc*t);
dx1 = filtfilt(b,a,x1);
dx2 = filtfilt(b,a,x2);
rx1 = dx1; rx2 = dx2;
ary = rx1-j*rx2;
sim = filter(ir,1,ary); %odpowiedzi impulsowe
nfft = length(ary);
r = fliplr(ifft(fft(hytx,nfft) .* conj(fft(ary,nfft)) )); %sim w miejscu ary dla odpowiedzi impulsowych
p = real(r)./max(abs(real(r)));
%p2 = [zeros(1,100) p(1:end-100)]; %dodanie opóŸnienia dla testów z AWGN
seg = reshape(p', L*nsamprx,[]); %zmiana p' na p2' w celu dodania opóŸnienia dla AWGN
wynik = sum(seg);
[Maximum,Imax] = max(seg);
[Minimum,Imin] = min(seg);
for i = 1:1:1000
 if Maximum(i) > abs(Minimum(i))
 I(i) = Imax(i);
 else
 I(i) = Imin(i);
 end
end
wynik(wynik>0) = 1;
wynik(wynik<0) = 0;
wynik = wynik(1:999);
wynik = wynik';
data = (data+1)/2;
[number,ratio] = biterr(wynik,data);