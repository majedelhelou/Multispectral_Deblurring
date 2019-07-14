function [xDeblur, M1old, M2old, xOld] = deblur_multiscale(guide, im, sigmaInit, Nlevels)
%deblur_multiscale takes the following inputs:
% guide (luminance, type double, with max intensity normalized to 1)
% im (the blurred NIR image, type double, normalized to max 1)
% sigmaInit (defines the search range for sigma) and Nlevels (# of hierarchy levels)
% Created by Zahra Sadeghipoor on 10/29/2014
% All rights reserved for EPFL.

%% Initialization
% parameters
[sigma0,~] = estimate_kernel(guide, im, sigmaInit);
sigmaInit = 0.1;
% gradient filters
f1 = [-1 1]; f2 = f1';
edgesH = f1; edgesV = f2;
% the M masks could be noisy as they are computed using the gradients. blur the masks to mitigate that noise.
Thr = -1; sigmaFixed = 5; kFixed = fspecial('Gaussian',2*3*sigmaFixed+1,sigmaFixed);
lambda = 1;

sigma = sigma0 / (2^Nlevels); % the sigma of the blur kernel should be changed according to the image resolution. 
% compute initial gradient masks, M1, M2:
yB = iirGaussian(imresize(guide,1/(2^(Nlevels)),'bicubic'),sigma,sigma);
z1b = conv2(yB,edgesH,'same'); z2b = conv2(yB,edgesV,'same');
xnow = imresize(im,1/(2^Nlevels),'bicubic'); x1 = conv2(xnow,edgesH,'same'); x2 = conv2(xnow,edgesV,'same');

dom = abs(z1b+x1); dom(dom<1e-4) = 1e-4;  
M1 = 1 - abs(z1b-x1) ./ dom; M1(M1<Thr) = Thr;  
M1 = imfilter(M1,kFixed,'symmetric');

dom = abs(z2b+x2); dom(dom<1e-4) = 1e-4;  
M2 = 1 - abs(z2b-x2) ./ dom; M2(M2<Thr) = Thr;
M2 = imfilter(M2,kFixed,'symmetric');

%% multiscale processing
x = xnow; %this will be overwritten
for count = Nlevels : -1 :  0
    M1old = M1;
    M2old = M2;

    sigma = sigma0 / (2^count);
    kernelSize = ceil(2*3*sigma+1);
    [xx,yy] = meshgrid(-1 * floor(kernelSize/2):floor(kernelSize/2)); k = exp (-1 .* (xx.^2+yy.^2) ./ (2*sigma^2)); k = k ./ sum(k(:)); clear xx yy
    
    yNow = imresize(guide,1/(2^count),'bicubic');
    xnow = imresize(im,1/(2^count),'bicubic');
    
    z1 = conv2(yNow,f1,'same'); z2 = conv2(yNow,f2,'same');
    
    % solve the deblurring optimization problem in the Fourier domain:
    z1 = M1 .* z1; z2 = M2 .* z2;
    z1F = fft2(z1); z2F = fft2(z2);
    f1F = psf2otf(f1,size(z1)); f2F = psf2otf(f2,size(z1)); nom = 1.0 * (abs(f1F).^2 + abs(f2F).^2);
    kF = psf2otf(k,size(z1));
    xnowf = fft2(xnow);
    dom = conj(f1F) .* z1F + conj(f2F) .* z2F;
    xF = (dom + lambda .* conj(kF) .* xnowf) ./ (nom + lambda .* abs(kF).^2 + eps); %ifft2 of the denominator is symmetric, but not circulant
    x = abs(ifft2(xF));
    
    % compute the sigma for the residual blur kernel
    xDeblurUpmsaple = imresize(x,2,'bicubic');
    [sigmaNow,~] = estimate_kernel(yNow,xDeblurUpmsaple,sigmaInit);
    sigmaUpsample = 2 * sigmaNow;
    
    % compute the gradient masks, M1 M2 for the next finer scale of the
    % pyramid
    yB = iirGaussian(imresize(guide,1/(2^(count-1)),'bicubic'), sigmaUpsample, sigmaUpsample);
    z1b = conv2(yB,edgesH,'same'); z2b = conv2(yB,edgesV,'same');
    xDeblurUpmsaple = xDeblurUpmsaple(1:size(yB,1),1:size(yB,2));
    x1 = conv2(xDeblurUpmsaple,edgesH,'same'); x2 = conv2(xDeblurUpmsaple,edgesV,'same');
    
    dom = abs(z1b+x1); dom(dom<1e-4) = 1e-4;  
    M1 = 1 - abs(z1b-x1) ./ dom;     M1(M1<Thr) = Thr;  
    M1 = imfilter(M1,kFixed,'symmetric');

    dom = abs(z2b+x2); dom(dom<1e-4) = 1e-4;  
    M2 = 1 - abs(z2b-x2) ./ dom;     M2(M2<Thr) = Thr;  
    M2 = imfilter(M2,kFixed,'symmetric');
    
    if (count == Nlevels), xOld = xDeblurUpmsaple; end
end

xDeblur = x;