function price=AsianCurranApprox(CallPutFlag, S , SA, X , t1, T , n , m , r , b , v ) 
%CallPutFlag='c' call option and 'p' put option
%S=asset price
%SA= Realized average so far
%X=strike price
%t1=time to next average point;
%T=time to maturity 
%n=number of fixings
%m=number of fixings fixed
%r=riskfree rate
%v=volatility
%b=cost of carry of the underlying asset
%   1.b=r cost of carry on a nondividend-paying stock
%   2.b=r-g cost of carry on a stock with a continous dividend yield g
%   3.b=0   cost of carry on a future contract

%Curran's approximation(1992)

z=1;
if CallPutFlag=='p'
    z=-1;
end
  
h = (T- t1)/(n - 1);  %n-m-1
if b == 0 
        EA = S;
else
        EA = S / n * exp(b * t1) * (1 - exp(b * h * n)) / (1 - exp(b * h));
end
   
   if m > 0 
        if SA > n / m * X    % Exercise is certain for call, put must be out-of-the-money
            if CallPutFlag == 'p'
                price = 0;
            elseif CallPutFlag == 'c' 
                SA = SA * m / n + EA * (n - m) / n;
                price= (SA - X) * exp(-r * T);
            end   
            return
        end
   end

if m == n - 1  % Only one fix left use Black-Scholes weighted with time
     X = n * X - (n - 1) * SA;
     price= GBlackScholes(CallPutFlag, S, X, T, r, b, v) * 1 / n;
     return
end
    
if m > 0 
    X = n / (n - m) * X - m / (n - m) * SA;
end
    
   vx= v * sqrt(t1 + h * (n-1) *(2 * n -1)/ (6 * n));
   my=log(S)+(b-v *v *0.5) * (t1 + (n-1) * h/2);
   
sum1=0;
for i=1:n
    ti = h*i+t1-h;
    vi = v * sqrt ( t1 + (i-1) * h );
    vxi = v * v * ( t1 + h * ((i-1) -i * (i-1) / (2*n)));
    myi = log(S) + (b - v ^2 * 0.5) * ti;
    sum1 = sum1 + exp( myi + vxi / vx ^2 *(log(X) - my)...
         + (vi^2- vxi^2/vx^2) / 2 );
end

Km=2*X-1/n*sum1;
sum2=0;
for i=1:n
    ti = h * i + t1- h;
    vi = v * sqrt ( t1 + (i-1) * h );
    vxi = v * v * ( t1 + h * ((i-1) -i * (i-1) / (2*n)));
    myi = log(S) + (b - v ^2 * 0.5) * ti;
    sum2 = sum2 + exp( myi + vi ^2 *0.5)...
         *normcdf(z*((my-log(Km))/vx+vxi/vx));
end


price=exp(-r*T)*z*(1/n*sum2-X*normcdf(z*(my-log(Km))/vx))*(n-m)/n;
