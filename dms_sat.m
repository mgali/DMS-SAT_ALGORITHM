function dms_out = dms_sat(dmspt_in,par_in,paramDMS)

% Calculate DMS concentration using algorithm described in
% 
% Galí, M., Levasseur, M., Devred, E., Simó, R., & Babin, M. (2018)
% Sea-surface dimethylsulfide (DMS) concentration from satellite data
% at global and regional scales. Biogeosciences, 15(11), 3497-3519.
% https://doi.org/10.5194/bg-15-3497-2018
%
% Accepts vector and N-dimension matrix inputs.
% Consistency in matrix sizes is not tested: Matlab will complain.
%
% UNITS OF INPUT AND OUTPUT VARIABLES:
% dmspt_in: total dimethylsulfoniopropionate concentration [micromol m-3]
% par_in: mean daily photosynthetically available radiation [mol photons m-2 d-1]
% dms_out: dissolved dimethylsulfide concentration [micromol m-3]
%
% PARAMETERS KEY:
% paramDMS = DMS sub-algorithm parameters
% If using default global ocean parameters, set param = []


if nargin == 3
    
    % Set default algorithm parameters if they are not provided
    if isempty(paramDMS)
        paramDMS = [-1.237 0.578 0.0180]; % global ocean optimized
        % paramDMS = [-1.300 0.700 0.0200]; % uncomment to use high northern latitudes optimized
    end
    
    % Log-transform dmspt_in
    dmspt_in = real(log10(dmspt_in));
    
    % Calculate DMS
    dms_out = 10.^(paramDMS(1) + paramDMS(2)*dmspt_in + paramDMS(3)*par_in);
    
else
    error('Function requires 3 arguments, but %i arguments were provided',nargin)
end
