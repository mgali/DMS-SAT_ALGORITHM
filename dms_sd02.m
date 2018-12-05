function [dms_out,sdcrit] = dms_sd02(chl_in,mld_in,paramSD02)

% Calculate DMS using Simó & Dachs 2002 algorithm
% Simó, R., & Dachs, J. (2002). Global ocean emission of dimethylsulfide
% predicted from biogeophysical data.
% Global Biogeochemical Cycles, 16(4), 26-1.
% https://doi.org/10.1029/2001GB001829

if nargin == 3
    
    % Set default algorithm parameters if they are not provided
    if isempty(paramSD02)
        paramSD02 = [0.02 5.7 55.8 0.6]; % original parameters
    end
    
    % Calculate SD02: separate chl-dependent and chl/mld dependent DMS
    % Make sure mld is positive (larger = deeper)
    sdcrit = chl_in./abs(mld_in) < paramSD02(1);
    
    % Calculate DMS
    dms_out = nan(size(chl_in));
    dms_out(sdcrit) = -log(mld_in(sdcrit)) + paramSD02(2);
    dms_out(~sdcrit) = paramSD02(3)*(chl_in(~sdcrit) ./ mld_in(~sdcrit)) + paramSD02(4);
        
else
    error('Function requires 3 arguments, but %i arguments were provided',nargin)
end
