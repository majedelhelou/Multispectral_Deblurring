function [ patch_corr ] = corr2_across_patches(IMG1, IMG2, patch_size)
%corr2_across_patches returns a map of the same size of the input
%but constant over patches of size patch_size
%if image size is not a multiple of patch_size, the remainder is forced
%into an overlap (to get an estimation for the "last border")
%Output:
%patch_corr patch estimation of normalized cross correlation between IMG1
%and IMG2

ximage_size = size(IMG1,1);
yimage_size = size(IMG1,2);

xpatches_total = floor( ximage_size/patch_size );
ypatches_total = floor( yimage_size/patch_size );
patch_corr = 0*IMG1;

for pix = 1:xpatches_total
    xi_image = (pix-1)*patch_size + 1;
    xf_image = xi_image + patch_size - 1;
    for piy = 1:ypatches_total
        yi_image = (piy-1)*patch_size + 1;
        yf_image = yi_image + patch_size - 1;
        IMG_patch1 = IMG1(xi_image:xf_image,yi_image:yf_image);
        IMG_patch2 = IMG2(xi_image:xf_image,yi_image:yf_image);
        corrValue = corr2(IMG_patch1, IMG_patch2);
        patch_corr(xi_image:xf_image,yi_image:yf_image) = repmat( corrValue, patch_size, patch_size );
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%        EDGES      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For the last horizontal line:
xi_image = ximage_size-patch_size+1;
xf_image = ximage_size;
for piy = 1:ypatches_total
    yi_image = (piy-1)*patch_size + 1;
    yf_image = yi_image + patch_size - 1;
    IMG_patch1 = IMG1(xi_image:xf_image,yi_image:yf_image);
    IMG_patch2 = IMG2(xi_image:xf_image,yi_image:yf_image);
    corrValue = corr2(IMG_patch1, IMG_patch2);
    patch_corr(xi_image:xf_image,yi_image:yf_image) = repmat( corrValue, patch_size, patch_size );
end
%For the last vertical line:
yi_image = yimage_size-patch_size+1;
yf_image = yimage_size;
for pix = 1:xpatches_total
    xi_image = (pix-1)*patch_size + 1;
    xf_image = xi_image + patch_size - 1;
    IMG_patch1 = IMG1(xi_image:xf_image,yi_image:yf_image);
    IMG_patch2 = IMG2(xi_image:xf_image,yi_image:yf_image);
    corrValue = corr2(IMG_patch1, IMG_patch2);
    patch_corr(xi_image:xf_image,yi_image:yf_image) = repmat( corrValue, patch_size, patch_size );
end
%For the last box:
IMG_patch1 = IMG1(ximage_size-patch_size+1:ximage_size, yimage_size-patch_size+1:yimage_size);
IMG_patch2 = IMG2(ximage_size-patch_size+1:ximage_size, yimage_size-patch_size+1:yimage_size);
corrValue = corr2(IMG_patch1, IMG_patch2);
patch_corr(xi_image:xf_image,yi_image:yf_image) = repmat( corrValue, patch_size, patch_size );

