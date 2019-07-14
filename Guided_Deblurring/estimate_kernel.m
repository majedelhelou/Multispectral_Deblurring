function [sigmaOpt,cost] = estimate_kernel(x,y,sigma0)
% Created by Zahra Sadeghipoor on 10/29/2014
% All rights reserved for EPFL.

% y is blurred compared with x. Compute the sigma value for the kernel that
% models this blurring.

% This function finds the sigma value that matches the sharpness of the
% blurred NIR and the blurred Y image (Y*G)
% x = Y & y = NIR_b

sigmaList = sigma0 : 0.5 : 10; % decrease the step size to increase the estimation accuracy in the cost of added computational complexity
cost = zeros(1,length(sigmaList));

shY = sh_computation(y);
for countS = 1 : length(sigmaList)
    yHat = iirGaussian(x,sigmaList(countS),sigmaList(countS));
    shYHat = sh_computation(yHat);
    cost(1,countS) = abs(shY-shYHat);
end

[~,idx] = min(cost);
sigmaOpt = sigmaList(idx);