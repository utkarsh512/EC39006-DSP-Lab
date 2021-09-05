N = 128;
L = 8;
M = N/L;
mean = 0;
var = 1;
a0 = [1 -.9]; a1 = [1 -.9i]; a2 = [1 .9i];
a = conv(a0,conv(a1,a2));
b = 1;
r = normrnd(mean,sqrt(var),[1 N]);
figure
plot(1:N,r)
figure
x = filter(b,a,r);% where y is the filter output
z = (abs(fft(a))).^2/N;
plot(z)