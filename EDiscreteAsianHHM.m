
function p=EDiscreteAsianHHM(OutPutFlag, CallPutFlag,S,SA,X,t1,T ,n,m ,r,b,v,dS)      
    if nargin<13
        dS = 0.01;
    end
    
    switch OutPutFlag
        case  'p' 
        %Value
        p=DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v);
         case  'd' 
         %Delta
         p=(DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v) - DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v)) / (2 * dS);
         case 'e' 
         %Elasticity
         p=(DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v) - DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v)) / (2 * dS) * S / DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v);
         case 'g' 
        %Gamma
        p=(DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) + DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v)) / dS ^ 2;
        case 'gv' 
        %DGammaDVol
        p= (DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v + 0.01) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v + 0.01) + DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v + 0.01)...
      - DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v - 0.01) + 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v - 0.01) - DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v - 0.01)) / (2 * 0.01 * dS ^ 2) / 100;
        case 'gp'
        %GammaP
        p= S / 100 * (DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) + DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v)) / dS ^ 2;
        case 'dddv'
        %DDeltaDvol 
        p= 1 / (4 * dS * 0.01) * (DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v + 0.01) - DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v - 0.01) ...
        - DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v + 0.01) + DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v - 0.01)) / 100;
        case 'v'
        %Vega 
        p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v + 0.01) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v - 0.01)) / 2;
        case 'vv' 
        %DvegaDvolVomma
        p=(DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v + 0.01) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) + DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v - 0.01)) / 0.01 ^ 2 / 10000;
        case 'vp'
         %VegaP 
         p= v / 0.1 * (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v + 0.01) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v - 0.01)) / 2;
        case 'dvdv' 
        %DvegaDvol
        p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v + 0.01) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) + DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v - 0.01));
        case 't' 
         if t1 > 1 / 365 && T > 1 / 365 
           %Theta 
           p= DiscreteAsianHHM(CallPutFlag, S, SA, X, t1 - 1 / 365, T - 1 / 365, n, m, r, b, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v);
         end
     case 'r' 
         %Rho 
         p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r + 0.01, b + 0.01, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r - 0.01, b - 0.01, v)) / (2);
    case 'fr' 
       %FuturesOptionsRho
       p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r + 0.01, b, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r - 0.01, b, v)) / (2);
     case 'f' 
         %Rho2 
         p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b - 0.01, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b + 0.01, v)) / (2);
    case 'b' 
        %Carry
        p= (DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b + 0.01, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b - 0.01, v)) / (2);
    case  's' 
        %Speed 
        p= 1 / dS ^ 3 * (DiscreteAsianHHM(CallPutFlag, S + 2 * dS, SA, X, t1, T, n, m, r, b, v) - 3 * DiscreteAsianHHM(CallPutFlag, S + dS, SA, X, t1, T, n, m, r, b, v)...
                                + 3 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) - DiscreteAsianHHM(CallPutFlag, S - dS, SA, X, t1, T, n, m, r, b, v));
      case 'dx' 
         %StrikeDelta
         p= (DiscreteAsianHHM(CallPutFlag, S, SA, X + dS, t1, T, n, m, r, b, v) - DiscreteAsianHHM(CallPutFlag, S, SA, X - dS, t1, T, n, m, r, b, v)) / (2 * dS);
     case 'dxdx' 
        %Gamma
        p= (DiscreteAsianHHM(CallPutFlag, S, SA, X + dS, t1, T, n, m, r, b, v) - 2 * DiscreteAsianHHM(CallPutFlag, S, SA, X, t1, T, n, m, r, b, v) + DiscreteAsianHHM(CallPutFlag, S, SA, X - dS, t1, T, n, m, r, b, v)) / dS ^ 2;
    end
