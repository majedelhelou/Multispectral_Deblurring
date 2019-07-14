% Created by Zahra Sadeghipoor on 10/29/2014
% All rights reserved for EPFL.

clc,
clear all,
close all
tic
gamma = 1;

sigma0 = 2; 
Nlevels = 2;


NIR = im2double(imread('nir1.tiff'));
RGB = im2double(imread('rgb.tiff'));
[m,n] = size(NIR);
y = mean(RGB,3);

NIR = NIR ./ max(NIR(:)); y = y ./ max(y(:));

[NIRdeblurMS, M1m, M2m, exNIR] = deblur_multiscale(y, NIR, sigma0, Nlevels);
imwrite(NIRdeblurMS, 'deblurredNIR.tiff', 'tiff');
toc