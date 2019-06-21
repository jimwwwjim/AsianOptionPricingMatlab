%The generalized Black and Scholes formula
function price=GBlackScholes(CallPutFlag, S, X, T , r,b ,v )
%CallPutFlag='c' call option and 'p' put option
%S=asset price
%X=strike price
%T=time to maturity 
%r=riskfree rate
%v=volatility
%b=cost of carry of the underlying asset
%   1.b=r cost of carry on a nondividend-paying stock
%   2.b=r-g cost of carry on a stock with a continous dividend yield g
%   3.b=0   cost of carry on a future contract
 
    d1 = (log(S / X) + (b + v ^ 2 / 2) * T) / (v * sqrt(T));
    d2 = d1 - v * sqrt(T);

    if CallPutFlag == 'c' 
        price= S * exp((b - r) * T) * normcdf(d1) - X * exp(-r * T) * normcdf(d2);
    else if CallPutFlag == 'p' 
        price = X * exp(-r * T) * normcdf(-d2) - S * exp((b - r) * T) * normcdf(-d1);
        end
    end
    