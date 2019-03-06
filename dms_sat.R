dms_sat <- function (dmspt_in,par_in,paramDMS) {
  
  # Calculate DMS concentration using algorithm described in
  # 
  # Galí, M., Levasseur, M., Devred, E., Simó, R., & Babin, M. (2018)
  # Sea-surface dimethylsulfide (DMS) concentration from satellite data
  # at global and regional scales. Biogeosciences, 15(11), 3497-3519.
  # https://doi.org/10.5194/bg-15-3497-2018
  #
  # Accepts vector and 2-dimension matrix inputs.
  # Consistency in input matrix sizes is not tested.
  #
  # INPUT VARIABLES:
  #   dmspt_in: total dimethylsulfoniopropionate concentration [micromol m-3]
  #   par_in: mean daily photosynthetically available radiation [mol photons m-2 d-1]
  #   param: NULL (default) or custom parameters
  #   PARAMETERS KEY:
  #     paramDMS = DMS sub-algorithm parameters
  # 
  # OUTPUT VARIABLES:
  #   dms_out: dissolved dimethylsulfide concentration [micromol m-3]
  
  
  # Set default algorithm parameters if they are not provided
  if (is.null(paramDMS)) {
    paramDMS = c(-1.237, 0.578, 0.0180); # global ocean optimized
    # paramDMS = c(-1.300, 0.700, 0.0200); # uncomment to use high northern latitudes optimized
  }
  
  # Log-transform dmspt_in
  dmspt_in <- log10(dmspt_in);
  
  # Calculate DMS
  dms_out <- 10^(paramDMS[1] + paramDMS[2]*dmspt_in + paramDMS[3]*par_in);
  
  return(dms_out)
  
}
