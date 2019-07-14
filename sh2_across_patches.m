function [ patch_S, patch_C ] = sh2_across_patches_fixed(IMG,patch_size)
%sh2_across_patches returns 2 maps of the same size of the input
%but constant over patches of size patch_size
%if image size is not a multiple of patch_size, the remainder is forced
%into an overlap (to get an estimation for the "last border")
%Outputs:
%patch_S patch estimation of Sobel operator sharpness measure
%patch_C patch estimation of Crete sharpness measure

ximage_size = size(IMG,1);
yimage_size = size(IMG,2);

xpatches_total = floor( ximage_size/patch_size );
ypatches_total = floor( yimage_size/patch_size );
patch_C = double(0*IMG);
patch_S = patch_C;

sobel_h = fspecial('sobel');   %detects horizontal edges
sobel_v = fspecial('sobel').'; %detects vertical edges

for pix = 1:xpatches_total
    xi_image = (pix-1)*patch_size + 1;
    xf_image = xi_image + patch_size - 1;
    for piy = 1:ypatches_total
        yi_image = (piy-1)*patch_size + 1;
        yf_image = yi_image + patch_size - 1;
        IMG_patch = IMG(xi_image:xf_image,yi_image:yf_image);
        % Crete sharpness estimate:
        crete_sh = sh_computation( IMG_patch );
        patch_C(xi_image:xf_image,yi_image:yf_image) = repmat( crete_sh, patch_size, patch_size );
        % Sobel sharpness estimate:
        D_Ih = abs( conv2(double(IMG_patch), double(sobel_v), 'same') );
        D_Iv = abs( conv2(double(IMG_patch), double(sobel_h), 'same') );
        sobel = sum(sum( D_Ih + D_Iv ));
        sobel_sh = sobel / patch_size^2;
        patch_S(xi_image:xf_image,yi_image:yf_image) = repmat( sobel_sh, patch_size, patch_size );
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%        EDGES      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For the last horizontal line:
xi_image = ximage_size-patch_size+1;
xf_image = ximage_size;
for piy = 1:ypatches_total
    yi_image = (piy-1)*patch_size + 1;
    yf_image = yi_image + patch_size - 1;
    IMG_patch = IMG(xi_image:xf_image,yi_image:yf_image);
    % Crete sharpness estimate:
    crete_sh = sh_computation( IMG_patch );
    patch_C(xi_image:xf_image,yi_image:yf_image) = repmat( crete_sh, patch_size, patch_size );
    % Sobel sharpness estimate:
    D_Ih = abs( conv2(double(IMG_patch), double(sobel_v), 'same') );
    D_Iv = abs( conv2(double(IMG_patch), double(sobel_h), 'same') );
    sobel = sum(sum( D_Ih + D_Iv ));
    sobel_sh = sobel / patch_size^2;
    patch_S(xi_image:xf_image,yi_image:yf_image) = repmat( sobel_sh, patch_size, patch_size );
end
%For the last vertical line:
yi_image = yimage_size-patch_size+1;
yf_image = yimage_size;
for pix = 1:xpatches_total
    xi_image = (pix-1)*patch_size + 1;
    xf_image = xi_image + patch_size - 1;
    IMG_patch = IMG(xi_image:xf_image,yi_image:yf_image);
    % Crete sharpness estimate:
    crete_sh = sh_computation( IMG_patch );
    patch_C(xi_image:xf_image,yi_image:yf_image) = repmat( crete_sh, patch_size, patch_size );
    % Sobel sharpness estimate:
    D_Ih = abs( conv2(double(IMG_patch), double(sobel_v), 'same') );
    D_Iv = abs( conv2(double(IMG_patch), double(sobel_h), 'same') );
    sobel = sum(sum( D_Ih + D_Iv ));
    sobel_sh = sobel / patch_size^2;
    patch_S(xi_image:xf_image,yi_image:yf_image) = repmat( sobel_sh, patch_size, patch_size );
end
%For the last box:
IMG_patch = IMG(ximage_size-patch_size+1:ximage_size, yimage_size-patch_size+1:yimage_size);
% Crete sharpness estimate:
crete_sh = sh_computation( IMG_patch );
patch_C(xi_image:xf_image,yi_image:yf_image) = repmat( crete_sh, patch_size, patch_size );
% Sobel sharpness estimate:
D_Ih = abs( conv2(double(IMG_patch), double(sobel_v), 'same') );
D_Iv = abs( conv2(double(IMG_patch), double(sobel_h), 'same') );
sobel = sum(sum( D_Ih + D_Iv ));
sobel_sh = sobel / patch_size^2;
patch_S(xi_image:xf_image,yi_image:yf_image) = repmat( sobel_sh, patch_size, patch_size );

