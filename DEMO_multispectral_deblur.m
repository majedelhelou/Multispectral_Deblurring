clearvars; clc; close all;

%% Generate all the deblurring results
% Note: if the results were already generated, imwrite can give an error 
% when access permission is not given
tic
gamma = 1;

sigma0 = 2; 
Nlevels = 2;

NIR = im2double(imread('Guided_Deblurring/nir.tiff'));
RGB = im2double(imread('Guided_Deblurring/rgb.tiff'));
[m,n] = size(NIR);
y = mean(RGB,3); r = RGB(:,:,1); g = RGB(:,:,2); b = RGB(:,:,3);

NIR = NIR ./ max(NIR(:)); 
y = y ./ max(y(:)); r = r ./ max(r(:)); g = g ./ max(g(:)); b = b ./ max(b(:));

[NIRdeblurMS, ~, ~, ~] = deblur_multiscale(y, NIR, sigma0, Nlevels);
imwrite(NIRdeblurMS, 'ResultsRGBY/deblurredNIR_y.tiff', 'tiff');

[NIRdeblurMS, ~, ~, ~] = deblur_multiscale(r, NIR, sigma0, Nlevels);
imwrite(NIRdeblurMS, 'ResultsRGBY/deblurredNIR_r.tiff', 'tiff');

[NIRdeblurMS, ~, ~, ~] = deblur_multiscale(g, NIR, sigma0, Nlevels);
imwrite(NIRdeblurMS, 'ResultsRGBY/deblurredNIR_g.tiff', 'tiff');

[NIRdeblurMS, ~, ~, ~] = deblur_multiscale(b, NIR, sigma0, Nlevels);
imwrite(NIRdeblurMS, 'ResultsRGBY/deblurredNIR_b.tiff', 'tiff');

toc


%% To read
% DataPath is the directory where NIR deblurring results are saved
% It contains deblurred images with an added r/g/b or y based on which guide was used to deblur
DataPath = 'ResultsRGBY/';

list = dir([DataPath '*.tiff']);
total_images = length(list);

%% Recombine
image_count = 0;
sobel_h = fspecial('sobel');   %detects horizontal edges
sobel_v = fspecial('sobel').'; %detects vertical edges
for group_idx = 1:4:total_images

    tic
    image_count = image_count + 1;
    imageName = list(group_idx).name;
    imageName = imageName(1:length(imageName)-6);

    clear result;
    result(:,:,1) = im2double(imread([DataPath imageName 'r.tiff']));
    result(:,:,2) = im2double(imread([DataPath imageName 'g.tiff']));
    result(:,:,3) = im2double(imread([DataPath imageName 'b.tiff']));
    result(:,:,4) = im2double(imread([DataPath imageName 'y.tiff']));

    % Evaluate sharpness for each channel
    patch_S = zeros(size(result));
    patch_C = zeros(size(result));
    parfor ch = 1:4
        [ patch_S(:,:,ch), patch_C(:,:,ch) ] = sh2_across_patches(result(:,:,ch),10);
    end

    % Re-combine based on best Sobel and Crete sharpness results
    x_size = size(result,1);
    y_size = size(result,2);
    bestRecombS = zeros(x_size,y_size);
    bestRecombC = zeros(x_size,y_size);
    for px = 1:x_size
        for py = 1:y_size
            [~,I] = max(patch_S(px,py,:));
            chM = I(1);
            bestRecombS(px,py) = result(px,py,chM);
            [~,I] = max(patch_C(px,py,:));
            chM = I(1);
            bestRecombC(px,py) = result(px,py,chM);
        end
    end

    %% Evaluate the new results
    % UNCOMMENT the following lines to evaluate with Sobel sharpness assessment
%     % Evaluate sharpness through Sobel differentiation imgradient
%     np = size(result,1) * size(result,2);
%     for ch = 1:4
%         D_Ih = abs( conv2(result(:,:,ch), sobel_v, 'same') );
%         D_Iv = abs( conv2(result(:,:,ch), sobel_h, 'same') );
%         sobel(image_count,ch) = sum(sum( D_Ih + D_Iv ));
%         sobel(image_count,ch) = sobel(image_count,ch) / np;
%     end
%     % And for the recombined using Sobel:
%     D_Ih = abs( conv2(bestRecombS, sobel_v, 'same') );
%     D_Iv = abs( conv2(bestRecombS, sobel_h, 'same') );
%     sobel = sum(sum( D_Ih + D_Iv ));
%     sobel(image_count,5) = sobel / np;
%     % And for the recombined using Crete:
%     D_Ih = abs( conv2(bestRecombC, sobel_v, 'same') );
%     D_Iv = abs( conv2(bestRecombC, sobel_h, 'same') );
%     sobel = sum(sum( D_Ih + D_Iv ));
%     sobel(image_count,6) = sobel / np;

    % Evaluate sharpness through sharpness function (Crete 2007)
    parfor ch = 1:4
        crete(image_count,ch) = sh_computation(result(:,:,ch));
    end
    crete(image_count,5) = sh_computation(bestRecombS);
    crete(image_count,6) = sh_computation(bestRecombC);

    toc
end

%% Crete sharpness results
% 'crete' holds the sharpness values of:
% NIR deblurred with r
% NIR deblurred with g
% NIR deblurred with b
% NIR deblurred with y
% NIR deblurred with recombination, based on Sobel merging
% NIR deblurred with recombination, based on Crete merging

figure;
subplot(121); imshow(result(:,:,1)); title('NIR deblurred with r');
subplot(122); imshow(bestRecombC); title('NIR deblurred with multispectral merging');
crete
disp('Precentage improvement with Sobel merging relative to deblurring with y:');
disp(100*(crete(5)-crete(4))/crete(4))
disp('Precentage improvement with Crete merging relative to deblurring with y:');
disp(100*(crete(6)-crete(4))/crete(4))
save('crete.mat','crete')
