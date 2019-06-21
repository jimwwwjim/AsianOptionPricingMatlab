function price=DiscreteAsianHHM(CallPutFlag, S , SA, X , t1, T , n , m , r , b , v ) 
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

%This is a modified version of the Levy formula, this is the formula published in "Asian Pyramid Power" By
% Haug, Haug and Margrabe

  
h = (T- t1)/(n - 1);
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

    if b == 0 
         EA2 = S * S * exp(v * v * t1) / (n * n)...
            * ((1 - exp(v * v * h * n)) / (1 - exp(v * v * h))...
           + 2 / (1 - exp(v * v * h)) * (n - (1 - exp(v * v * h * n)) / (1 - exp(v * v * h))));
    else
    
         EA2 = S * S * exp((2 * b + v * v) * t1) / (n * n)...
            * ((1 - exp((2 * b + v * v) * h * n)) / (1 - exp((2 * b + v * v) * h))...
            + 2 / (1 - exp((b + v * v) * h)) * ((1 - exp(b * h * n)) / (1 - exp(b * h)) ...
            - (1 - exp((2 * b + v * v) * h * n)) / ...
            (1 - exp((2 * b + v * v) * h))));
    end

    vA = sqrt((log(EA2) - 2 * log(EA)) / T);

    OptionValue = 0;
    
    if m > 0 
        X = n / (n - m) * X - m / (n - m) * SA;
    end
    
    d1 = (log(EA / X) + vA ^ 2 / 2 * T) / (vA * sqrt(T));
    d2 = d1 - vA * sqrt(T);

    if CallPutFlag == 'c'
        OptionValue = exp(-r * T) * (EA * normcdf(d1) - X * normcdf(d2));
    elseif CallPutFlag == 'p'
        OptionValue = exp(-r * T) * (X * normcdf(-d2) - EA * normcdf(-d1));
    end

    price= OptionValue * (n - m) / n;
