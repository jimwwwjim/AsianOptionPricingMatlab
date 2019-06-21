function asian_hedge_WW_2(CallPutFlag,k,b,m,SA,OptionPrice,r,sigma,minunit,zongsousu,TradingUnit,MarginPercent,CommissionPer,TraCostPer,RiskCoe,s,T,Tn,s1)
%Whalley-Wilmott Model
%k=strike price ,  option price,  CallPutFlag='c''p';    
%r=interest rate
% sigma=volatility
% minunit= minimum changing unit
% zongsousuone=option cover how many future contract
% TradingUnit= trading unit
% MarginPercentmargin percent
% CommissionPer=commission percent     
% trading cost percent, risk aversion coefficient
% s,T: time serie of hedging point
%  s1,Tn: time serie of observation points 

huazijia(1)=s(1)+minunit;
t=[T,Tn]; 
t=unique(t); 
t=sort(t,'descend');
%%%%%%%%%%%%%%%%%%%%%%%%
t1=T(1)-Tn(1);
n=length(Tn)+m;
delta(1,1)=AsianCurranGreek('d', CallPutFlag,s(1),SA,k,t1,T(1) ,n,m ,r,b,sigma);
gamma=AsianCurranGreek('g', CallPutFlag,s(1),SA,k,t1,T(1) ,n,m ,r,b,sigma);
     
B=(3 * TraCostPer * s(1) * exp(-r*T(1)) * gamma^2 / (2*RiskCoe))^(1/3);
Up=round( zongsousu * (delta(1,1)+B));
Down=round( zongsousu * (delta(1,1)-B));

if  0<Down
    position(1,1)=Down;
elseif 0>Up
    position(1,1)=Up;
else
    position(1,1)=0;
end
changeP(1,1)=position(1,1);

i=1;
if t(1)==Tn(1)
%       SA=(SA*m+s1(1))/(m+1);
      SA=(SA*m+s(1))/(m+1);
      m=m+1;
      i=2;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
c=2;j=2;
while (c<length(t))
    
    if t(c)==T(j)
       t1=T(j)-Tn(i);
       delta(j,1)=AsianCurranGreek('d', CallPutFlag,s(j),SA,k,t1,T(j),n,m ,r,b,sigma);
    %     if isnan(delta(c,1));
    %         delta(c,1)=0;
    %     end
       gamma=AsianCurranGreek('g', CallPutFlag,s(j),SA,k,t1,T(j),n,m ,r,b,sigma);     
       B=(3 * TraCostPer * s(j) * exp(-r*T(j)) * gamma^2 / (2*RiskCoe))^(1/3);
       Up=round( zongsousu * (delta(j,1)+B));
       Down=round( zongsousu * (delta(j,1)-B));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if position(j-1,1)<Down
            position(j,1)=Down;
            changeP(j,1)=Down-position(j-1,1);
            huazijia(j,1)=s(j)+minunit;
        elseif position(j-1,1)>Up
            position(j,1)=Up;
            changeP(j,1)=Up-position(j-1,1);
            huazijia(j,1)=s(j)-minunit;
        else
            position(j,1)=position(j-1,1);
            changeP(j,1)=0;
            huazijia(j,1)=s(j);
        end
          j=j+1;
       end

        if t(c)==Tn(i)
%         SA=(SA*m+s1(i))/(m+1);
         SA=(SA*m+s(c))/(m+1);
          m=m+1;
          i=i+1; 
        end
     c=c+1;
end

% SA=(SA*m+s1(end))/(m+1);
SA=(SA*m+s(end))/(m+1);
delta(j,1)=delta(j-1,1);
huazijia(j,1)=s(j,1)-minunit;
position(j,1)=0;
changeP(j,1)=-position(j-1,1);

a=length(T);
NodePL(1,1)=0;
for i=2:a
    NodePL(i,1)=(huazijia(i,1)-huazijia(i-1,1))*position(i-1,1) * TradingUnit*exp(-r*(T(1)-T(i)));
end

commission=zeros(a,1);
for i=1:a
    commission(i,1)=-abs(changeP(i,1))* CommissionPer*exp(-r*(T(1)-T(i)));
end

margin=abs(position).*huazijia * MarginPercent * TradingUnit;
interest(1,1)=0;
for i=2:a
    interest(i,1)=-(T(i-1)-T(i))/365*r*margin(i)*exp(-r*(T(1)-T(i)));
end

exercisePL=0;
switch CallPutFlag
    case 'c'
      if SA>k
        exercisePL=(k-SA)* zongsousu *TradingUnit*exp(-r*T(1));
      end
     case 'p'
    if SA<k
       exercisePL=(SA-k)* zongsousu *TradingUnit*exp(-r*T(1));
    end 
end
   
CumNodePL=cumsum(NodePL);   
CumCommission=cumsum(commission);
CumInterest=cumsum(interest);
TotalPL=exercisePL+OptionPrice+CumNodePL(end)+CumCommission(end)+CumInterest(end);

disp(num2str([s,delta,position,changeP,NodePL,CumNodePL,margin,commission,interest]))
disp([num2str([SA,k,TotalPL,CumNodePL(end),CumCommission(end),CumInterest(end),OptionPrice])])

subplot(2,2,2),plot(CumNodePL),title('CumNodePL');
subplot(2,2,1),plot(position),title('position');
subplot(2,2,3),plot(s),title('s');
subplot(2,2,4),plot(delta),title('delta');


