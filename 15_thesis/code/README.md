# Multivariate GARCH
This work was done as part of a thesis at EDHEC Business School studying how volatility in China's real estate market is impacting the US. More information can be found [here](https://sites.google.com/site/garthmortensenthesis/).

## Requirements

* Matlab 2011b
  * JPL toolbox
  * UCSD toolbox
* Excel

## Installation
1. To run the files, extract the folder such as:

   > c:\thesis\readme.txt

2. Extract jpl7.zip and Ucsd_garch.zip to your matlab toolbox folder. Install the toolboxes by running 'pathtool' in the Matlab command prompt, and installing with all subfolders.

   ```matlab
   pathtool
   ```

3. Verify they've been installed using 'ver' in the command prompt. Run [GARCH_code.m](https://github.com/garthmortensen/finance/blob/master/code/GARCH_code.m) in Matlab.

   ```cmd
   ver
   ```

## Notes

The code is written to automatically run on price series downloaded directly from Datastream. [market1.xlsx](https://github.com/garthmortensen/finance/blob/master/code/market1.xlsx) and [market2.xlsx](https://github.com/garthmortensen/finance/blob/master/code/market2.xlsx) were downloaded directly from Datastream. Some matlab code is provided to format for Yahoo Finance data. I've removed the EWMA Excel file, but you can find similar work in Carol Alexander's Market Risk Analysis II book.