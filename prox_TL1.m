function [CHI_m] = prox_TL1(CHI,lambda)



    lambda1 = lambda;
    bb=10;  %30%--->20;20%---->10
    aa=(bb.^2)/(2*(bb+1));
    if lambda1<=aa  
    c=lambda1*((bb+1)/bb);
    else
    c=sqrt(2*lambda1*(bb+1))-(bb/2);   
    end
   
    xz=sqrt(CHI.^2);% 
    xz(xz==0)=0.000001;% 
    
    dd=27*lambda1*bb*(bb+1);
    ee=2.*((bb+xz).^3);
    Z = acos(1-(dd./ee)); %
    
    gg2=cos(Z./3);
    ff2=xz./3-(2/3).*bb;
    
    CHI_m=(((2/3).*(bb+xz)).*gg2+ ff2).*(xz>c); 
    





end


