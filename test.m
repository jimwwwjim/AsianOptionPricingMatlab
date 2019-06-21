
%%
CallPutFlag1='c';
%S=1970;
SA=0;
%X=2160;
%t1=1/365;
% T=365/365;
% n=10;
m=0;
r=0.065;
b=0;
% v=0.15;
% price2=DiscreteAsianHHM(CallPutFlag, S , SA, X , t1, T , n , m , r , b , v) 
% price1=AsianCurranApprox(CallPutFlag, S , SA, X , t1, T , n , m , r , b , v ) 
%%
w=windmatlab;
CallPutFlag2='p';
% k=1955;
b=0;
m=0;
SA=0;
r=0.065;
steps=139;

startT='2017-10-1';
startT1='2017-10-1 09:00:00';
startT2='2017-10-1 09:00:00';
endT1='2017-10-31 15:00:00';
% startT2='16-September-2015 15:00';
% endT2='16-November-2015 15:00';
contractname='A.DCE';
%Historical volatility
[data,codes,close,times,w_wsd_errorid,w_wsd_reqid]=w.wsd(contractname,'close','ED-139D',startT,'Fill=Previous');
n=length(data);
logreturn=log(data(2:n)./data(1:n-1));
v=std(logreturn)*sqrt(241); 
%sigma=v+0.02;
sigma=0.1631;

%品种合约区别
zongsousu=100;           %期权总手数
MarginPercent=0.13;   %保证金比率         
CommissionPer=2*2;       %手续费比率
[unit,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(contractname,'tunit');
TradingUnit=10;        
[min,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(contractname,'mfprice');
minunit=1;            
[maxvol,w_wss_codes,w_wss_fields,w_wss_times,w_wss_errorid,w_wss_reqid]=w.wss(contractname,'changelt');
maxvol=maxvol/100;

TraCostPer=0.003;    RiskCoe=210;  

[s,w_wsi_codes,w_wsi_fields,date,w_wsi_errorid,w_wsi_reqid]=w.wsi(contractname,'close',startT1,endT1,'BarSize=30');
for i=1:length(date)
    T(i)=(date(end)-date(i))/365;
end  
[s1,w_wsd_codes,w_wsd_fields,date1,w_wsd_errorid,w_wsd_reqid]=w.wsd(contractname,'close',startT2',endT1,'Fill=Previous');
%[s1,w_wsd_codes,w_wsd_fields,date1,w_wsd_errorid,w_wsd_reqid]=w.wsd(contractname,'close',startT1',endT1,'Fill=Previous','Period=W');
%date1=(datenum(startT2):1:datenum(endT2))';
for i=1:length(date1)
    Tn(i)=(date1(end)-date1(i))/365;
end  

nsim=10000;
n=length(Tn)+m;
k=s(1);

[bid1,OptionPrice1]=AsianHedgeMCPriceHHM2(CallPutFlag2,3950,3950,steps/365,T(1)-Tn(1),sigma,r,b,minunit,nsim,steps,maxvol,n,m,SA,zongsousu,TradingUnit,MarginPercent,CommissionPer,25,5);
%asian_hedge_WW(CallPutFlag2,k,b,m,SA,-OptionPrice1,r,sigma,minunit,zongsousu,TradingUnit,MarginPercent,CommissionPer,TraCostPer,RiskCoe,s,T,Tn);

%price2=DiscreteAsianHHM('c', s(1) , SA, k , T(1)-Tn(1), steps/365 , steps, m , r , b , sigma) 
%price1=AsianCurranApprox('c', s(1) , SA, k , T(1)-Tn(1), steps/365 , steps , m , r , b , sigma ) 

%[bid2,OptionPrice2]=AsianHedgeMCPriceHHM(CallPutFlag2,s(1),k,steps/365,T(1)-Tn(1),sigma,r,b,minunit,nsim,steps,maxvol,n,m,SA,zongsousu,TradingUnit,MarginPercent,CommissionPer,95,5);
%asian_hedge_WW(CallPutFlag2,k,b,m,SA,-OptionPrice2,r,sigma,minunit,zongsousu,TradingUnit,MarginPercent,CommissionPer,TraCostPer,RiskCoe,s,T,Tn);

% [bid3,offer1]=euro_price(CallPutFlag1,s(1),k,steps/365,sigma,b,r,minunit,nsim,steps,maxvol,MarginPercent,CommissionPer,zongsousu,TradingUnit,95,5);
% [bid4,offer2]=euro_price(CallPutFlag2,s(1),k,steps/365,sigma,b,r,minunit,nsim,steps,maxvol,MarginPercent,CommissionPer,zongsousu,TradingUnit,95,5);
% disp([num2str([-offer1,-offer2])]);