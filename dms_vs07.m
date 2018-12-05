function dms_out = dms_vs07(par_in,mld_in,kd490_in,paramVS07)

% Calculate dms using VS07 algorithm. Use satellite daily par_in in mol
% photons m-2 d-1 as input
% Vallina, S. M., & Simó, R. (2007). Strong relationship between DMS and
% the solar radiation dose over the global surface ocean.
% Science, 315(5811), 506-508.
% https://doi.org:10.1126/science.1133680

if nargin == 4
    
    % Set default algorithm parameters if they are not provided
    if isempty(paramVS07)
        paramVS07 = [0.492 0.019]; % original parameters
    end
    
    % Convert par from mol photons m-2 d-1 to shortwave irradiance W m-2
    parfract = 0.43;
    convfact = 2.77e18; % quanta s-1 W-1 % Morel & Smith 1974, in Kirk 2011 (page 5)
    avogadro = 6.022140857e23; % mol-1
    totw = par_in*avogadro/(parfract*convfact*(24*3600)); % par in mol photons m-2 d-1 to total shortwave in W m-2
    
    % Calculate SRD. Make sure mld is positive (larger = deeper)
    mld_in = abs(mld_in);
    srd = totw.*(1./(kd490_in .* mld_in)).*(1 - exp(-kd490_in .* mld_in));
    
    % Calculate DMS
    dms_out = paramVS07(1) + paramVS07(2)*srd;
    
else
    error('Function requires 4 arguments, but %i arguments were provided',nargin)
end
