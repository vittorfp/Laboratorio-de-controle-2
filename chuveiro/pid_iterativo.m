i = 1000;
y = zeros(i,1);
u = zeros(i,1);
e = zeros(i,1);
d = zeros(i,1);
a = zeros(i,1);
c = zeros(i,1);
r = zeros(i,1);
g = zeros(i,1);
f = zeros(i,1);
ref = zeros(i,1);
setpoint = [zeros(200,1); 2000*ones(200,1); zeros(200,1); 2000*ones(200,1); zeros(200,1)];
modo = zeros(i); %0 é MANUAL e 1 é AUTO

LS = 10225;
LI= -23000;
kc = -6.42;
Td = 1;
alpha = 0.5;
Ti = 42;
t = 0.5;
th = 9.5;
[nd, dd] = c2dm(-0.15, [68 1], t, 'zoh');

for k = 30:i
    y(k) = -dd(2)*y(k-1) + nd(2)*u(k-1-uint8((th/t)));
    d(k) = ((y(k) * Td) + (d(k-1) * alpha * Td) - (y(k-1) * Td))/(t + alpha * Td);
    
    e(k) = kc * (setpoint(k) - y(k));
    %e2(k) = kc * e(k);
    
    if modo(k)
        r(k) = ref(k);
    else 
        r(k) = g(k-1);
    end

    a(k) = ((r(k) * t) + (a(k-1) * Ti))/ (t + Ti);
    g(k) = a(k) + e(k);
    
    if g(k) > LI
        g(k) = LI;
    elseif g(k) < LS
        g(k) = LS;
    end
    
    if modo(k)
        f(k) = d(k) * kc;
        u(k) = g(k) - f(k);
    else 
        u(k) = ref(k);
    end
    
    if u(k) > LI
        u(k) = LI;
    elseif u(k) < LS
        u(k) = LS;
    end
end

plot(y);
hold on
plot(setpoint);
