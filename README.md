# Multispectral_Deblurring
[Majed El Helou](https://majedelhelou.github.io/), Zahra Sadeghipoor, Sabine Süsstrunk

This repository contains the needed code to run the functions of "Correlation-Based Deblurring Leveraging Multispectral 
Chromatic Aberration in Color and Near-Infrared Joint Acquisition". Simply run `DEMO_multispectral_deblur`, it saves intermediate 
results in the folder `ResultsRGBY`. To obtain the correlation maps used in the paper's correlation study, use `corr2_across_patches.m`.

The folder `Guided_Deblurring` contains the demo and code of "Multiscale Guided Deblurring: Chromatic Aberration 
Correction in Color and Near-Infrared Imaging". Simply run `demo`.

To test with different RGB-NIR image pairs, [this dataset can be downloaded](https://ivrl.epfl.ch/research-2/research-downloads/supplementary_material-cvpr11-index-html/).
Replace inside `Guided_Deblurring` the images `rgb.tiff` and `nir.tiff`.


## Citations
Correlation-Based Deblurring Leveraging Multispectral Chromatic Aberration in Color and Near-Infrared Joint Acquisition:
```
@inproceedings{el2017correlation,
  title={Correlation-based deblurring leveraging multispectral chromatic aberration in color and near-infrared joint acquisition},
  author={El Helou, Majed and Sadeghipoor, Zahra and S{\"u}sstrunk, Sabine},
  booktitle={International Conference on Image Processing (ICIP)},
  pages={1402--1406},
  year={2017},
  organization={IEEE}
}
```

Multiscale Guided Deblurring: Chromatic Aberration Correction in Color and Near-Infrared Imaging:
```
@inproceedings{sadeghipoor2015multiscale,
  title={Multiscale guided deblurring: Chromatic aberration correction in color and near-infrared imaging},
  author={Sadeghipoor, Zahra and Lu, Yue M and Mendez, Erick and S{\"u}sstrunk, Sabine},
  booktitle={European Signal Processing Conference (EUSIPCO)},
  pages={2336--2340},
  year={2015},
  organization={IEEE}
}
```

Dataset:
```
@inproceedings{brown2011multi,
  title={Multi-spectral SIFT for scene category recognition},
  author={Brown, Matthew and S{\"u}sstrunk, Sabine},
  booktitle={Computer Vision and Pattern Recognition (CVPR)},
  pages={177--184},
  year={2011},
  organization={IEEE}
}
```
