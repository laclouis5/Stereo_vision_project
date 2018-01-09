# Continuous 3D Label Stereo Matching using Local Expansion Moves

![Local Expansion Moves](teaser.png)

This is an implementatioin of a stereo matching method described in

```
@article{Taniai17,
  author    = {Tatsunori Taniai and
               Yasuyuki Matsushita and
               Yoichi Sato and
               Takeshi Naemura},
  title     = {{Continuous 3D Label Stereo Matching using Local Expansion Moves}},
  journal   = {{Transactions on Pattern Analysis and Machine Intelligence (TPAMI)}},
  year      = {2017},
  note      = {(accepted)},
}
```

The code is for research purpose only. If you use our code, please cite the above paper. We also encourage to cite the following conference paper too, where we describe the fundamental idea of our optimization technique.

```
@inproceedings{Taniai14,
  author    = {Tatsunori Taniai and
               Yasuyuki Matsushita and
               Takeshi Naemura},
  title     = {{Continuous Stereo Matching using Locally Shared Labels}},
  booktitle = {{IEEE Conference on Computer Vision and Pattern Recognition (CVPR)}},
  year      = {2014},
  pages     = {1613--1620},
}
```
See also [our project site](http://taniai.space/projects/stereo/) and [preprint](https://arxiv.org/abs/1603.08328).

## Running environment
- Visual Studio 2017 Community (installed with the VC++ 2015 vc140 toolset if using the following OpenCV build)
- OpenCV 3 (OpenCV 3.1.0 package will be automatically installed via NuGet upon the initial build)
- Maxflow code v3.01 by Boykov and Kolmogorov [[Link]](http://vision.csd.uwo.ca/code/)

## How to Run?
1. Download and extract maxflow source code to "maxflow" directory. Modify instances.inc to add the following line
```
template class Graph<float,float,double>;
```
2. Download and extract an example dataset (see Adirondack below) in "data/MiddV3/trainingH/Adirondack".
3. Build the solution with release mode. (Doing this will automatically install OpenCV3 package via NuGet. If not, you need to manually install OpenCV3 binaries for the corresponding version of the platform toolset . For the platform toolset vc140, I installed OpenCV by doing "Install-Package opencvcontrib -Version 3.1.0" on the Package Manager console of VS2017.)
4. Run demo.bat file. Results will be saved in "results/cones", "results/teddy", and "results/Adirondack".

## Options
- -mode MiddV2: Use settings for Middlebury V2.
- -mode MiddV3: Use settings for Middlebury V3. Assume MC-CNN matching cost files (im0.acrt, im1.acrt) in targetDir.
- -targetDir {string}: Directory that contains target image pairs.
- -outputDir {string}: Directory for saving results. disp0.pfm is the primary result. Intermediate results are also saved in "debug" sub-directory.
- -doDual {0,1}: Estimate left and right disparities and do post-processing using consistency check.
- -iterations {int}: Number of main iterations.
- -pmIterations {int}: Number of initial iterations performed before main iterations without smoothness terms (this accelerates inference).
- -ndisp {int}: Define the disparity range [0, ndisp-1]. It not specified, try to retrieve from files (calib.txt or info.txt). 
- -smooth_weight {float}: Smoothness weight (lambda in the paper).
- -filterRedious {int}: The redius of matching windows (ie, filterRedious/2 is the kernel radius of guided image filter).
- -mc_threshold {float}: Parameter tau_cnn in the paper that truncates MC-CNN matching cost values.

## Updates
- The function of initial iterations (option: pmIterations) is added to accelerate the inference.
- The implementation of guided image filter has been improved from the paper, which reduces the running time of our method by half.

## Pre-computed MC-CNN matching costs
We use matching cost volumes computed by [MC-CNN-acrt](https://github.com/jzbontar/mc-cnn).
We provide pre-computed matching cost data for 30 test and training image pairs of Middlebury benchmark V3.
For demonstration, please use Adirondack below that contains image pairs, calibration data, and ground truth.
- [trainingH (15.7 GB)](http://www2.hci.iis.u-tokyo.ac.jp/datasets/data/LocalExpStereo/trainingH.rar)
- [testH (22.0 GB)](http://www2.hci.iis.u-tokyo.ac.jp/datasets/data/LocalExpStereo/testH.rar)
- [Adirondack (1.2 GB)](http://www2.hci.iis.u-tokyo.ac.jp/datasets/data/LocalExpStereo/Adirondack.zip)

Temporary links:
- [trainingH_im0 (9.2 GB)](https://drive.google.com/file/d/0B-VxeI7PlJE1ZnlQMGdwbm9LSTQ/view?usp=sharing)
- [testH_im0 (12.9 GB)](https://drive.google.com/file/d/0B-VxeI7PlJE1UkdjYjZDNHI0Tkk/view?usp=sharing)
- [Adirondack (1.2 GB)](https://drive.google.com/file/d/0B-VxeI7PlJE1eG5GTzVhVlYzRUE/view?usp=sharing)

Here, only left volume (im0.acrt) is provided. Data of right volume can be recovered from left.

Note that these matching costs are raw outputs from CNNs without cross-based filter and SGM aggregation.

## Tips
### Test your own matching costs
By replacing matching cost data files of MC-CNN (im0.acrt and im1.acrt), you can easily use your own matching costs other than MC-CNN without changing the code. These files directly store a 3D float volume and can be read as follows.
```
float volume0[ndisp][height][width];
FILE *file = fopen("im0.acrt", "rb");
fread(volume0, sizeof(float), ndisp*height*width, file);
```
Here, a float value volume0[d][y][x] stores a matching cost between two (left and right) image patches centered at im0(x, y) and im1(x-d, y). The ndisp will be loaded from calib.txt, or can be specified by the -ndisp argument. Note that values of volume0[d][y][x] for x-d < 0 (i.e., where im1(x-d, y) is out of the image domain) are ignored and filled by volume0[d][y][x+d]. If your matching costs provide valid values for these regions, you should modify the code to turn off this interpolation by disabling the fillOutOfView function.

During the inference, the algorithm computes the data term D_p(a,b,c) at p = (x, y) by local 3D aggregation using a plane label (a,b,c) as below.
```
D_p(a,b,c) = sum_{s=(u,v) in window W_p} w_ps * min(volume0[u*a + v*b + c][v][u], options.mc_threshold)
(Equation (6) in the paper)
```
Here, w_ps is the filter kernel of guided image filtering, and volume0[u*a + v*b + c][v][u] is computed with linear interpolation in d-space (because u*a + v*b + c is not integer).


### Possible extensions and references
We suggest possibe extensions of the algorithm and list related references.

#### Use superpixels instead of grid cells
We currently use only regular grid-cells for defining local expansion moves. When extending to use superpixels, following papers will be useful.
+ Taniai et al., "Joint Recovery of Dense Correspondence and Cosegmentation in Two Images" (CVPR 2016)
+ Li et al., "PMSC: PatchMatch-Based Superpixel Cut for Accurate Stereo Matching" (IEEE Trans. Circuits Syst. Video Technol.)
+ Hur and Roth, "MirrorFlow: Exploiting Symmetries in Joint Optical Flow and Occlusion Estimation" (ICCV 2017)

#### Use simultaneous fusion moves (fusion space) instead of expansion moves
Our loca expansion move method is currently based on binary fusion, which combines a current solution with a single candidate label in one fusion operation. This operation can be replaced with simultaneous fusion (or fusion space), which combines combines a current solution with multiple candidate labels in one fusion operation. This technique leads to better avoidance of local minimums. It can be implemented by using TRW-S as shown in the following papers.
+ Ulén and Olsson, "Simultaneous Fusion Moves for 3D-Label Stereo" (EMMCVPR 2013)
+ Liu et al., "Layered Scene Decomposition via the Occlusion-CRF" (CVPR 2016)

#### Apply to other problems than stereo
Our loca expansion move method is also useful for high-dimensional label estimation problems in optical flow and other dense correspondence problems. In the first paper below, we infer 4 DoF motion labels (similrity transformation) by using additional candidate label proposers. The second paper estimates 8 DoF motion labels (homography) using our method.
+ Taniai et al., "Joint Recovery of Dense Correspondence and Cosegmentation in Two Images" (CVPR 2016)
+ Hur and Roth, "MirrorFlow: Exploiting Symmetries in Joint Optical Flow and Occlusion Estimation" (ICCV 2017)
