function [dmspt_out,flags_out] = dmspt_sat(chl_in,zeu_in,mld_in,sst_in,pic_in,param)

% Calculate DMSPt concentration using algorithm described in
% 
% Galí, M., Devred, E., Levasseur, M., Royer, S. J., & Babin, M. (2015)
% A remote sensing algorithm for planktonic dimethylsulfoniopropionate
% (DMSP) and an analysis of global patterns. Remote Sensing of Environment,
% 171, 171-184.
% https://doi.org/10.1016/j.rse.2015.10.012
%
% Accepts vector and N-dimension matrix inputs.
% Consistency in matrix sizes is not tested: Matlab will complain.
%
% UNITS OF INPUT AND OUTPUT VARIABLES (vectors):
% chl_in: Chlorophyll a concentration [mg m-3]
% zeu_in: Euphotic Layer Depth [m], defined as 1% surface PAR
% (or 490 nm radiation) penetration
% mld_in: Mixed Layer Depth [m]
% sst_in: Sea Surface temperature [degree celsius]
% pic_in: Particulate Inorganic Carbon concentration [mol m-3]
% dmspt_out: total dimethylsulfoniopropionate concentration [micromol m-3]
% flags_out (character): stratified ('S'), mixed ('M') or cocco bloom ('C')
%
% PARAMETERS KEY (structure):
% param.S = stratified case
% param.M = mixed case
% param.C = cocco bloom case (only if chl unavailable)
% If using default parameters, set param = []


if nargin == 6
    
    % Set default algorithm parameters if they are not provided
    if isempty(param)
        param.S = [1.70 1.14 0.44 0.063 -0.0024]; % stratified case params
        param.M = [1.74 0.81 0.60]; % mixed case params
        param.C = [-1.05 -3.19 -0.78]; % [cocco bloom & chl absent] params
    end
    
    % Restrict chl range (avoid artifacts at extremely low or high chl)
    % Note that original algorithm was capped at chl = 60
    % Satellite data with known issues in chl retrieval should be capped
    minchl = 0.04;
    maxchl = 30;
    chl_in(chl_in < minchl) = minchl;
    chl_in(chl_in > maxchl) = maxchl;
    
    % Assign sub-algorithms (create flags)
    flags_out = nan(size(chl_in));
    flags_out((zeu_in./mld_in >= 1 | pic_in >= 0.0015) & ~isnan(chl_in) & ~isnan(sst_in)) = 'S';
    flags_out(flags_out ~= 'S' & zeu_in./mld_in < 1 & ~isnan(chl_in)) = 'M';
    flags_out(pic_in >= 0.0015 & isnan(chl_in)) = 'C';
    
    % Log-transform
    chl_in = real(log10(chl_in));
    pic_in = real(log10(pic_in));
    
    % Make sure mld is positive (larger = deeper)
    mld_in = abs(mld_in);
    
    % Calculate DMSPt
    dmspt_out = nan(size(chl_in));
    dmspt_out(flags_out == 'S') = param.S(1) + param.S(2)*chl_in(flags_out == 'S') + param.S(3)*(chl_in(flags_out == 'S').^2)...
        + param.S(4)*sst_in(flags_out == 'S') + param.S(5)*(sst_in(flags_out == 'S').^2);
    dmspt_out(flags_out == 'M') = param.M(1) + param.M(2)*chl_in(flags_out == 'M')...
        + param.M(3)*(real(log10(zeu_in(flags_out == 'M')./mld_in(flags_out == 'M'))));
    dmspt_out(flags_out == 'C') = param.C(1) + param.C(2)*pic_in(flags_out == 'C') + param.C(3)*(pic_in(flags_out == 'C').^2);
    dmspt_out = 10.^dmspt_out;
    
else
    error('Function requires 6 arguments, but %i arguments were provided',nargin)
end
