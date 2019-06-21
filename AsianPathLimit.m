function s=AsianPathLimit(S0,sig,t,b,maxvol)
%steps=路径节点数
%maxvol=最大涨幅、降幅
s(1)=S0;
n=length(t);
for i=1:n-1
    dt=t(i)-t(i+1);
   s(i+1)=s(i)*exp((b-sig^2/2)*dt+sig*sqrt(dt)*randn);    
   limit=s(i)*maxvol;     %limit of increasing or decreasing
     if abs(s(i+1)-s(i))>limit
        if s(i+1)>s(i)
            s(i+1)=s(i)+limit;
        else
           s(i+1)=s(i)-limit;
        end
     end
end