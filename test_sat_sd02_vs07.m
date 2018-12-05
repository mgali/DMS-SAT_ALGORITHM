% TEST DMS-SAT algorithm(s)
% TEST sd02 and vs07 algorithms and compare to DMS-SAT

% Description: calculate DMS(Pt) in 5 hypothetical scenarios.
% Numbers indicate indices in x vectors:
% 
% 1. stratified, chl available, pic >= 0.0015
% 2. stratified, chl available, pic < 0.0015
% 3. stratified, chl and Kd490 not available, pic >= 0.0015
% 4. "false" mixed: chl available and pic >= 0.0015 set it to stratified
% 5. "true" mixed, pic < 0.0015
% 
%  Requires statistics toolbox for nansum (easy to recode if necesary)

%% Input data
x.chl = [0.1 0.1 NaN 2.0 0.5];
x.sst = [20 20 20 5 5];
x.pic = [0.0016 1.0000e-04 0.0016 0.0016 1.0000e-04];
x.mld = [20 20 20 25 60];
x.kd490 = [0.0544 0.0544 NaN 0.1866 0.1022];
x.zeu = [85 85 NaN 24 45]; % comment if indirect zeu calculation preferred
x.par = [50 50 50 50 10];

% --------------- Alternative: calculate zeu from x.kd490 ----------------
% Calculate euphotic layer depth as 1% penetration of 490 nm radiation
% Use if x.zeu not available
x.zeu = 4.6 ./ x.kd490;

% --------- Alternative: calculate zeu from chl using Morel2007 ----------
% Use if neither x.zeu nor x.kd490 available\
% Morel, A., Huot, Y., Gentili, B., Werdell, P. J., Hooker, S. B.,
% & Franz, B. A. (2007). Examining the consistency of products derived
% from various ocean color sensors in open ocean (Case 1) waters in the
% perspective of a multi-sensor approach.
% Remote Sensing of Environment, 111(1), 69-88.
lchl = real(log10(x.chl));
x.zeuMorel07 = 10.^(1.524 - 0.436*lchl - 0.0145*(lchl.^2) + 0.0186*(lchl.^3));


%% Test DMS-SAT in 2 steps: DMSPt and DMS

% Test dmspt_sat using default parameters
testparam.DMSPt = [];

% % Test dmspt_sat using custom parameters. Note this will affect dms_sat
% testparam.DMSPt.S = [2 1.14 0.44 0.063 -0.0024]; % uncomment to test custom  params
% testparam.DMSPt.M = [1.5 0.81 0.60]; % uncomment to test custom  params
% testparam.DMSPt.C = [-1.05 -3.19 -0.78]; % uncomment to test custom  params

[dmspt_out,flags_out] = dmspt_sat(x.chl,x.zeuMorel07,x.mld,x.sst,x.pic,testparam.DMSPt);

if isempty(testparam.DMSPt)
    % Round to 2 digits (can be done with 'round' function in Matlab >=2014)
    sdigits = 1e2;
    dmspt_out = round(dmspt_out*sdigits)/sdigits;
    dmspt_check = [19.95 19.95 59.11 217.79 26.38];
    if nansum(dmspt_out - dmspt_check) == 0, disp('Well done with DMSPt-SAT!')
    else disp('Something went wrong with DMSPt-SAT!')
    end
else
    disp('Testing your own DMSPt-SAT params')
end

% Test dms_sat using default parameters
testparam.SAT = [];

% % Test dmspt_sat using custom parameters
% testparam.SAT = [-1.400 0.900 0.0100]; % uncomment to test custom params.

dms_out.sat = dms_sat(dmspt_out,x.par,testparam.SAT);

if isempty(testparam.DMSPt) && isempty(testparam.SAT)
    % Round to 2 digits (can be done with 'round' function in Matlab >=2014)
    sdigits = 1e2;
    dms_out.sat = round(dms_out.sat*sdigits)/sdigits;
    dms_check.sat = [2.60 2.60 4.86 10.34 0.58];
    if nansum(dms_out.sat - dms_check.sat) == 0, disp('Well done with DMS-SAT!')
    else disp('Something went wrong with DMS-SAT!')
    end
else
    disp('Testing your own DMS-SAT params')
end


%% Test Simó & Dachs 2002

testparam.sd02 = []; % use default parameters
[dms_out.sd02,sdcrit] = dms_sd02(x.chl,x.mld,testparam.sd02);
if isempty(testparam.sd02)
    % Round to 2 digits (can be done with 'round' function in Matlab >=2014)
    sdigits = 1e2;
    dms_out.sd02 = round(dms_out.sd02*sdigits)/sdigits;
    dms_check.sd02 = [2.70 2.70 NaN 5.06 1.61];
    if nansum(dms_out.sd02 - dms_check.sd02) == 0, disp('Well done with sd02!')
    else disp('Something went wrong with sd02!')
    end
else
    disp('Testing your own sd02 params')
end


%% Test Vallina & Simó 2007

testparam.vs07 = []; % use default parameters
dms_out.vs07 = dms_vs07(x.par,x.mld,x.kd490,testparam.vs07);
if isempty(testparam.vs07)
    % Round to 2 digits (can be done with 'round' function in Matlab >=2014)
    sdigits = 1e2;
    dms_out.vs07 = round(dms_out.vs07*sdigits)/sdigits;
    dms_check.vs07 = [3.88 3.88 NaN 1.67 0.67];
    if nansum(dms_out.vs07 - dms_check.vs07) == 0, disp('Well done with vs07!')
    else disp('Something went wrong with vs07!')
    end
else
    disp('Testing your own vs07 params')
end

