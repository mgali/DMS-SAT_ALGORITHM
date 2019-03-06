dmspt_sat <- function(chl_in,zeu_in,mld_in,sst_in,pic_in,param) {
  
  # Calculate DMSPt concentration using algorithm described in
  # 
  # Galí, M., Devred, E., Levasseur, M., Royer, S. J., & Babin, M. (2015)
  # A remote sensing algorithm for planktonic dimethylsulfoniopropionate
  # (DMSP) and an analysis of global patterns. Remote Sensing of Environment,
  # 171, 171-184.
  # https://doi.org/10.1016/j.rse.2015.10.012
  #
  # Accepts vector and 2-dimension matrix inputs.
  # Consistency in matrix sizes is not tested.
  #
  # INPUT VARIABLES:
  #   chl_in: Chlorophyll a concentration [mg m-3]
  #   zeu_in: Euphotic Layer Depth [m], defined as 1% surface PAR
  #   (or 490 nm radiation) penetration
  #   mld_in: Mixed Layer Depth [m]
  #   sst_in: Sea Surface temperature [degree celsius]
  #   pic_in: Particulate Inorganic Carbon concentration [mol m-3]
  #   param: NULL (default) or custom parameters
  #   PARAMETERS KEY (list):
  #     param$S = stratified case
  #     param$M = mixed case
  #     param$C = cocco bloom case (only if chl unavailable)
  # 
  # OUTPUT VARIABLES:
  #   dmspt_out: total dimethylsulfoniopropionate concentration [micromol m-3]
  #   flags_out (data frame with boolean values): stratified, mixed, cocco bloom
  
  
  # Set default algorithm parameters if they are not provided
  if (is.null(param)) {
    param <- list()
    param$S <- c(1.70, 1.14, 0.44, 0.063, -0.0024) # stratified regime, chl-based
    param$M <- c(1.74, 0.81, 0.60) # mixed regime, chl-based
    param$C <- c(-1.05, -3.19, -0.78) # stratified regime, pic-based
  }
  
  # Restrict chl range (avoid artifacts at extremely low or high chl)
  # NOTE: original algorithm was capped at chl = 60
  # Satellite data with known issues in chl retrieval should be capped
  minchl <- 0.04;
  maxchl <- 30;
  chl_in[chl_in < minchl] <- minchl;
  chl_in[chl_in > maxchl] <- maxchl;
  
  # Assign sub-algorithms, create flags_out
  strat <- !is.na(chl_in) & !is.na(sst_in) & ((!is.na(zeu_in) & !is.na(mld_in) & zeu_in>=mld_in) | (!is.na(pic_in) & pic_in>=0.0015))
  mix <- !is.na(chl_in) & !is.na(zeu_in) & !is.na(mld_in) & zeu_in<mld_in & !strat
  cocc <- is.na(chl_in) & !is.na(pic_in) & pic_in>=0.0015
  flags_out <- list(strat=strat,mix=mix,cocc=cocc)
  
  # Log-transform
  chl_in <- log10(chl_in);
  pic_in <- log10(pic_in);
  
  # Make sure mld is positive (larger = deeper)
  mld_in <- abs(mld_in);
  
  # Calculate DMSPt
  dmspt_out <- rep(NA,length(chl_in))
  dmspt_out[strat] <- param$S[1] + param$S[2]*chl_in[strat] + param$S[3]*(chl_in[strat])^2 + param$S[4]*sst_in[strat] + param$S[5]*sst_in[strat]^2    
  dmspt_out[mix] <- param$M[1] + param$M[2]*chl_in[mix] + param$M[3]*(log10(zeu_in[mix]/mld_in[mix]))  
  dmspt_out[cocc] <- param$C[1] + param$C[2]*pic_in[cocc] + param$C[3]*(pic_in[cocc])^2
  dmspt_out <- 10^dmspt_out
  
  # Reshape into original dimensions of chl_in
  if (is.matrix(chl_in)) {
    dmspt_out <- matrix(dmspt_out, ncol = dim(chl_in)[2])
  }
  
  # Return outputs
  return(list(dmspt_out=dmspt_out,flags_out=flags_out))
  
}
