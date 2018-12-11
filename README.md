# DMS-SAT_ALGORITHM
The repository DMS-SAT_ALGORITHM contains Matlab and R code to calculate total dimethylsulfoniopropionate (DMSP) and dissolved dimethylsulfide (DMS) in surface seawater using remote sensing and geophysical data. The DMS-SAT algorithm refers to the ensemble of the DMSP and DMS sub-algorithms as described in the following papers:

# ================================= dmspt_sat.* =================================
Galí, M., Devred, E., Levasseur, M., Royer, S. J., & Babin, M. (2015). A remote sensing algorithm for planktonic dimethylsulfoniopropionate (DMSP) and an analysis of global patterns. Remote Sensing of Environment, 171, 171-184. https://doi.org/10.1016/j.rse.2015.10.012

# ================================= dms_sat.* =================================
Galí, M., Levasseur, M., Devred, E., Simó, R., & Babin, M. (2018). Sea-surface imethylsulfide (DMS) concentration from satellite data at global and regional scales. Biogeosciences, 15(11), 3497-3519. https://doi.org/10.5194/bg-15-3497-2018

In addition, I provide here Matlab and R code for the following DMS algorithms, with which DMS-SAT shares some conceptual bases:

# ================================= dms_sd02.* =================================
Simó, R., & Dachs, J. (2002). Global ocean emission of dimethylsulfide predicted from biogeophysical data. Global Biogeochemical Cycles, 16(4), 26-1. https://doi.org/10.1029/2001GB001829

# ================================= dms_vs07.* =================================
Vallina, S. M., & Simó, R. (2007). Strong relationship between DMS and the solar radiation dose over the global surface ocean. Science, 315(5811), 506-508. https://doi.org:10.1126/science.1133680


I also provide scripts called test_sat_sd02_vs07.* where DMS-SAT (and the other algorithms) can be tested in a range of simple made-up cases.

# ================================== NOTE ======================================
Finally, note that this repository has a sister called DMS-SAT_DATA_DEV_VAL. The latter contains 
1) the curated dataset used to develop and validate DMS-SAT, consisting of the global sea-surface database from PMEL (https://saga.pmel.noaa.gov/dms/), quality controlled and extended with satellite and climatological data (as described by Galí et al. 2015 and 2018).
2) Scripts with useful data analysis tips. Can be used to reproduce the results from the Galí et al. 2015 and 2018 papers.
