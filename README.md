# Semi-Global Matching (4-direction)

> **Repository Moved**  
> This repository has been moved to a new location and is no longer maintained here.  
> Please visit the new repository: [Semi-Global Matching (SGM-4, SGM-8, SGM-16)](https://github.com/aposb/stereo-matching-using-semi-global-matching)  
> This repository is archived and kept for reference only.

A Matlab implementation of Semi-Global Matching (SGM) for stereo matching.
It uses the 4-direction version of the algorithm with a small improvement for better results.
The improvement is that in the calculation of the total cost, the matching cost does not add up. Normally it had to add up four times (once for each direction).

## Input Image
The Tsukuba stereo image that used as input.

<p align="center">
  <img src="left.png"> 
</p>

## Output Image
The disparity map that created at the output.

<p align="center">
  <img src="disparity.png"> 
</p>
