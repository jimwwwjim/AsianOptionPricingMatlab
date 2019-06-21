function [bid,offer]=AsianHedgeMCPriceHHM2(CallPutFlag,s,k,T,t1,sigma,r,b,minunit,nsim,steps,maxvol,n,m,SA,zongsousu,TradingUnit,MarginPercent,CommissionPer,VaR,LVaR)

%s=initial asset price
%k=strike price
%T=matruity time
%t1=time to next averaging point
%sigma=volatility
%steps=add "steps" nodes in the time period(
%b=cost of carry of the underlying asset
%   1.b=r cost of carry on a nondividend-paying stock
%   2.b=r-g cost of carry on a stock with a continous dividend yield g
%   3.b=0   cost of carry on a future contract

%n=numbers of fixing
%m=numbers of fixing fixed
%SA=average so far


ProfitLoss=zeros(nsim,1);                                                                        
Tstep=(steps:-1:0)*T/(steps);
dt=(T-t1)/(n-m-1);
Tn=(T-t1:-dt:0);
t=[Tstep,Tn]; t=unique(t); t=sort(t,'descend');

for i=1:nsim
    price=AsianPathLimit(s,sigma,t,b,maxvol);
    ProfitLoss(i)=hedge(CallPutFlag,price,k,r,b,T,t1,Tstep,Tn,t,sigma,minunit,n,m,SA,zongsousu,TradingUnit,MarginPercent,CommissionPer);
end

reset=sort(ProfitLoss);
if VaR==100
   offer=reset(1);      % VaR confidential interval
else
offer=reset(nsim*(100-VaR)/100);      % VaR confidential interval
end
if LVaR==100
   bid=reset(1);      
else
bid=reset(nsim*(100-LVaR)/100);      
end  

 

function totalPL=hedge(CallPutFlag,price,k,r,b,T,t1,Tstep,Tn,t,sigma,minunit,n,m,SA,zongsousu,TradingUnit,MarginPercent,CommissionPer)

Num=length(price);

%初始值
delta(1)=EDiscreteAsianHHM('d', CallPutFlag,price(1),SA,k,t1,T ,n,m ,r,b,sigma);
position(1)=round( zongsousu * delta(1));         
changeP(1)=position(1);                                       
changeP(1)=position(1);                                       
if changeP(1)>0
    huazijia(1)=price(1)+minunit;
elseif changeP(1)<0
    huazijia(1)=price(1)-minunit;
else
    huazijia(1)=price(1);
end

i=1;
if t(1)==Tn(1)
      SA=(SA*m+price(1))/(m+1);
      m=m+1;
      i=i+1;
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c=2;j=2;
while (c<Num)

    if t(c)==Tstep(j)
       t1=t(c)-Tn(i);     
    
    delta(j)=EDiscreteAsianHHM('d', CallPutFlag,price(c),SA,k,t1,t(c) ,n,m ,r,b,sigma);
%     if isnan(delta(j));
%         delta(j)=0;
%     end
    position(j)=round( zongsousu * delta(j));
    changeP(j)=position(j)-position(j-1);
    
        if changeP(j)>0
            huazijia(j)=price(c)+minunit;
        elseif changeP(j)<0
            huazijia(j)=price(c)-minunit;
        else
            huazijia(j)=price(c);
        end 
          j=j+1;
    end
    
    if t(c)==Tn(i)
      SA=(SA*m+price(c))/(m+1);
      m=m+1;
      if i<length(Tn)
         i=i+1; 
      end
    end

    c=c+1;    
end

position(j)=0;
changeP(j)=-position(j-1);
if changeP(j)>0
        huazijia(j)=price(c)+minunit;
    elseif changeP(j)<0
        huazijia(j)=price(c)-minunit;
    else
        huazijia(j)=price(c);
end 

a=length(Tstep);
nodePL(1)=0;  %节点盈亏
for i=2:a
    nodePL(i)=(huazijia(i)-huazijia(i-1))*position(i-1) * TradingUnit*exp(-r*(Tstep(1)-Tstep(i)));
end

for i=1:a
    commission(i)=-abs(changeP(i)) * CommissionPer *exp(-r*(Tstep(1)-Tstep(i)));
end

margin=-abs(position).*huazijia * MarginPercent * TradingUnit;
interest(a)=0;        %利息
for i=1:a-1
    interest(i)=r/365*margin(i)*exp(-r*(Tstep(1)-Tstep(i)));
end

exercisePL=0;    %行权盈亏
if CallPutFlag=='c'
    if SA>k
        exercisePL=(k-SA)* zongsousu *TradingUnit*exp(-r*Tstep(1));
    end
elseif CallPutFlag=='p'
    if SA<k
        exercisePL=(SA-k)* zongsousu *TradingUnit*exp(-r*Tstep(1));
    end
end
                                        
%对冲盈亏、总手续费、总利息、总对冲盈亏、总权利金、总盈亏
%hedging profit &loss ,total commission fees, total interest,
%total hedging cost, total profit &loss
CumNodPL=sum(nodePL);
ToCommission=sum(commission);
ToInterest=sum(interest);
ToCost=CumNodPL+ToCommission+ToInterest;
totalPL=ToCost + exercisePL;


