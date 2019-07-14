function y = iirGaussian(x,Sx,Sy)

normFactorX = 1.6800 * cossum(0.6318/Sx,1.7830/Sx) + 3.7350 * sinsum(0.6318/Sx,1.7830/Sx)...
    - 0.6803 * cossum(1.9970/Sx,1.7230/Sx) - 0.2598 * sinsum(1.9970/Sx,1.7230/Sx);

normFactorX = 2 * real(normFactorX) - 1;

normFactorY = 1.6800 * cossum(0.6318/Sy,1.7830/Sy) + 3.7350 * sinsum(0.6318/Sy,1.7830/Sy)...
    - 0.6803 * cossum(1.9970/Sy,1.7230/Sy) - 0.2598 * sinsum(1.9970/Sy,1.7230/Sy);

normFactorY = 2 * real(normFactorY) - 1;

% g = (1.6800 * cos(0.6318 * n/s) + 3.7350 * sin(0.6318 * n/s)) .* exp(-1.783 * n/s)...
%   - (0.6803 * cos(1.9970 * n/s) + 0.2598 * sin(1.9970 * n/s)) .* exp(-1.723 * n/s);

% Z = ztrans(g);
%
% Z = subs(Z,'z',1/n);
%
% [N,D] = numden(Z);
%
% % save equations N D g
% %
% N1 = subs(N,'s',SS);
% D1 = subs(D,'s',SS);
%

[Apx,Bpx,Anx,Bnx] = computeCoefficients(Sx);
[Apy,Bpy,Any,Bny] = computeCoefficients(Sy);
% 
% 
% S = 0;
% 
% x = padarray(x,[S S],'symmetric','both');

yp  = zeros(size(x));
yn  = zeros(size(x));

for k = 1:size(x,2)
    
    j = size(x,2) - k + 1;
    
    termap0 = Apx(1) * x(:,k);
    
    if k > 1
        termap1 = Apx(2) * x(:,k - 1);
        termbp1 = Bpx(2) * yp(:,k - 1);
        terman1 = Anx(2) * x(:,j + 1);
        termbn1 = Bnx(2) * yn(:,j + 1);
    else
        termap1 = 0;
        termbp1 = 0;
        terman1 = 0;
        termbn1 = 0;
    end
    
    if k > 2
        termap2 = Apx(3) * x(:,k - 2);
        termbp2 = Bpx(3) * yp(:,k - 2);
        terman2 = Anx(3) * x(:,j + 2);
        termbn2 = Bnx(3) * yn(:,j + 2);
    else
        termap2 = 0;
        termbp2 = 0;
        terman2 = 0;
        termbn2 = 0;
    end
    
    if k > 3
        termap3 = Apx(4) * x(:,k - 3);
        termbp3 = Bpx(4) * yp(:,k - 3);
        terman3 = Anx(4) * x(:,j + 3);
        termbn3 = Bnx(4) * yn(:,j + 3);
    else
        termap3 = 0;
        termbp3 = 0;
        terman3 = 0;
        termbn3 = 0;
    end
    
    if k > 4
        termbp4 = Bpx(5) * yp(:,k - 4);
        terman4 = Anx(5) * x(:,j + 4);
        termbn4 = Bnx(5) * yn(:,j + 4);
    else
        termbp4 = 0;
        terman4 = 0;
        termbn4 = 0;
    end
    
    yp(:,k) = termap0 + termap1 + termap2 + termap3 - termbp1 - termbp2 - termbp3 - termbp4;
    yn(:,j) = terman1 + terman2 + terman3 + terman4 - termbn1 - termbn2 - termbn3 - termbn4;
    
end

x = (yp + yn)' / normFactorX;

yp = zeros(size(x));
yn = zeros(size(x));

for k = 1:size(x,2)
    
    j = size(x,2) - k + 1;
    
    termap0 = Apy(1) * x(:,k);
    
    if k > 1
        termap1 = Apy(2) * x(:,k - 1);
        termbp1 = Bpy(2) * yp(:,k - 1);
        terman1 = Any(2) * x(:,j + 1);
        termbn1 = Bny(2) * yn(:,j + 1);
    else
        termap1 = 0;
        termbp1 = 0;
        terman1 = 0;
        termbn1 = 0;
    end
    
    if k > 2
        termap2 = Apy(3) * x(:,k - 2);
        termbp2 = Bpy(3) * yp(:,k - 2);
        terman2 = Any(3) * x(:,j + 2);
        termbn2 = Bny(3) * yn(:,j + 2);
    else
        termap2 = 0;
        termbp2 = 0;
        terman2 = 0;
        termbn2 = 0;
    end
    
    if k > 3
        termap3 = Apy(4) * x(:,k - 3);
        termbp3 = Bpy(4) * yp(:,k - 3);
        terman3 = Any(4) * x(:,j + 3);
        termbn3 = Bny(4) * yn(:,j + 3);
    else
        termap3 = 0;
        termbp3 = 0;
        terman3 = 0;
        termbn3 = 0;
    end
    
    if k > 4
        termbp4 = Bpy(5) * yp(:,k - 4);
        terman4 = Any(5) * x(:,j + 4);
        termbn4 = Bny(5) * yn(:,j + 4);
    else
        termbp4 = 0;
        terman4 = 0;
        termbn4 = 0;
    end
    
    yp(:,k) = termap0 + termap1 + termap2 + termap3 - termbp1 - termbp2 - termbp3 - termbp4;
    yn(:,j) = terman1 + terman2 + terman3 + terman4 - termbn1 - termbn2 - termbn3 - termbn4;
    
end

y = (yp + yn)' / normFactorY;

% y   = y(S+1:end-S,S+1:end-S);

end

function y = cossum(a,b)

j = sqrt(-1);
y = exp(b)*(-1-exp(2*a*j)+2*exp(b+a*j))/(2*(exp(b)-exp(a*j))*(-1+exp(b+a*j)));


end

function y = sinsum(a,b)

j = sqrt(-1);
y = j*exp(b)*(-1+exp(2*a*j))/(2*(-exp(b)+exp(a*j))*(-1+exp(b+a*j)));

end

function [Ap,Bp,An,Bn] = computeCoefficients(s)

Ap = [ 9997*exp(1753/(250*s)), 37350*exp(5229/(1000*s))*sin(3159/(5000*s)) - 3194*exp(5229/(1000*s))*cos(3159/(5000*s)) - 2598*exp(5289/(1000*s))*sin(1997/(1000*s)) - 26797*exp(5289/(1000*s))*cos(1997/(1000*s)), 16800*exp(1783/(500*s)) - 6803*exp(1723/(500*s)) + 19994*exp(1753/(500*s))*cos(1997/(1000*s))*cos(3159/(5000*s)) - 74700*exp(1753/(500*s))*cos(1997/(1000*s))*sin(3159/(5000*s)) + 5196*exp(1753/(500*s))*cos(3159/(5000*s))*sin(1997/(1000*s)), 6803*exp(1723/(1000*s))*cos(1997/(1000*s)) - 16800*exp(1783/(1000*s))*cos(3159/(5000*s)) - 2598*exp(1723/(1000*s))*sin(1997/(1000*s)) + 37350*exp(1783/(1000*s))*sin(3159/(5000*s))];
Bp = [ 10000*exp(1723/(500*s))*exp(1783/(500*s)), - 20000*exp(1783/(500*s))*exp(1723/(1000*s))*cos(1997/(1000*s)) - 20000*exp(1723/(500*s))*exp(1783/(1000*s))*cos(3159/(5000*s)), 10000*exp(1723/(500*s)) + 10000*exp(1783/(500*s)) + 40000*exp(1723/(1000*s))*exp(1783/(1000*s))*cos(1997/(1000*s))*cos(3159/(5000*s)), - 20000*exp(1723/(1000*s))*cos(1997/(1000*s)) - 20000*exp(1783/(1000*s))*cos(3159/(5000*s)), 10000];

Ap(5) = 0;

maxi = Bp(1);

Ap = Ap/maxi;
Bp = Bp/maxi;

Bn = Bp;
An = Ap - Bp * Ap(1);

end