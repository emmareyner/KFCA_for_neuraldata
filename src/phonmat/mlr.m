function [beta,stats] = mlr(x,y,int);
%This function performs an MLR model fit and `leave
% one out' cross-validation of the model.  Measures of
% R-squared, Adjusted R-squared, RMSE for
% Calibration, RMSE for Cross-validation are printed.
% IO format: [beta,stats] = mlr(x,y,1);
% where rows are samples and columns are variables
% last parameter: 1 = intercept fit, 0 = no intercept fit
%
% Additional detailed information is included in the file 
% header which can be viewed by opening this file.

% This algorithm is not speedy as the whole psuedo-inverse
% is calculated once for every sample during the leave one out cross
% validation portion of the code.  It may take up to 2 minutes to run
% through a cross validation with 500 samples.
% It does offer a good reference technique from
% which to compare and contrast with pls, espescially the pls algorithm
% in the "PLS Toolbox" as output is very similar.
%
% The true and fitted values are printed along with
% the RPE and upper and lower limits of an approx.
% 95% confidence interval on future observed value
% assuming normality. Draper and Smith's "Applied
% Regression Analysis" Textbook was consulted in
% the process of writing this function.
%
% INPUT: Requires a y vector which is the dependent variable
% (e.g., reference values/gold standard) and an X matrix of
% independent variables (e.g., spectra). If an intercept
% is wanted in the model set int=1 (default value).
% If an intercept is not wanted set int to 0.  The X
% matrix is required to have samples in rows and
% variables in the columns.
%
% OUTPUT: The regression coefficents are returned
% by the function (beta vector). The model prediction
% information is also returned in the 'stats' output.
% The observed y, predicted y, relative percent error (RPE),
% standard error of the mean and standard error of a
% future observation at the given y are contained in
% 'stats' in that order.
%
% IMPORTANT NOTE: To fit an MLR model, the number of
% samples must be greater than the number of independent
% variables.  If this is not the case, PLS or PCR models
% should be fit using MODLMAKER or MODLGUI or some variables
% should be eliminated. As the number of variables
% (with or without intercept) gets closer to the number of
% samples, the X'X inverse matrix may become unstable and
% may not exist (i.e., singular X'X matrix).
%
% Kirk Remund
% Pete Eschbach
% Pacific Northwest National Laboratory - Battelle
% e-mail: km_remund@pnl.gov
%       : pa_eschbach@pnl.gov
% phone:  (509) 372-4729
%               375-2678 (pete)
% fax:    (509) 375-3614
%               372-4725 (pete)
%
% Disclaimer: Neither of the authors nor the Battelle
% Memorial Institute claim any responsibility for the
% accuracy of results obtained using this function.
%
if nargin < 3 % check if int value present in arguments
    int=1;
end

if int == 0
        n = length(y); % number of samples
        p = size(x,2); % number of variables in x block
else p = size(x,2) + 1; % number of variables plus intercept
     n = length(y);
end

% check to see that n >= # columns (independent vars)
if p>n
error('More variables than samples, use less variables and/or omit intercept')
end

[a,b] = size(y);  % make y a column vector
if a<b
    y = y';
end

if int == 0 %fit no intercept
    beta = inv(x'*x)*x'*y;
    pred = x*beta;
end
if int == 1 %fit intercept
    x = [ones(n,1) x]; %add intercept
    beta = inv(x'*x)*x'*y;
        pred = x*beta;
end
differ = abs((y - pred)./y*100);
ybar = mean(y)*ones(n,1);
ssreg = (pred-ybar)'*(pred-ybar);
sse = (pred-y)'*(pred-y);
sstot = (y-ybar)'*(y-ybar);
r2 = ssreg/sstot;
adjr2 = 1 - (1-r2)*((n-1)/(n-p));
r2 = r2*100;
adjr2 = adjr2*100;
rmsec = sqrt(sse/n); % calibration rmse
s2 = sse/(n-p);
rmse = sqrt(s2);
stderry = [];
stderrybar = [];
for i = 1:n
    xi = x(i,:);
stderry = [stderry sqrt(s2*(1 + xi*inv(x'*x)*xi'))]; %s.e. of obs.
stderrybar = [stderrybar sqrt(s2*(xi*inv(x'*x)*xi'))]; %s.e. of mean
end
LLy = pred - 2*stderry';
ULy = pred + 2*stderry';
LLybar = pred - 2*stderrybar';
ULybar = pred + 2*stderrybar';

% Do crossvalidation using `leave one out' method
predi = []; % initialize
for i = 1:n  % calculate model for each i
    xi = [x(1:i-1,:) ; x(i+1:n,:)]; % drop ith sample
    yi = [y(1:i-1) ; y(i+1:n)];
    betai = inv(xi'*xi)*xi'*yi;
    predi = [predi ; x(i,:)*betai];
end
rmsecv = sqrt((predi-y)'*(predi-y)/n); % cross-validation rmse

% Print out all the output
disp('  ')
disp('        Results of MLR Model Fit (first 10 records reported)')
disp('        ----------------------------------------------------')
disp('  ')
s = sprintf('Percent R-squared is %g',r2);
    disp(s), disp('  ')
s = sprintf('Percent Adjusted R-squared is %g',adjr2);
    disp(s), disp('  ')
disp('                                  RPE         Standard Errors')
disp('    Observed     Predicted        (%)       Mean      New Obs')
disp('    --------     ---------       -----     --------------------')
stats = [y pred differ stderrybar' stderry'];
format = '   %9.2e     %9.2e    %7.1f     %9.2e  %9.2e ';
if n>10  % print first 10 records
    z = 10;
else
    z = n;
end
for i = 1:z
  tab = sprintf(format,stats(i,:)); disp(tab)
end
disp('  ')
pause
disp('  ')
s = sprintf('Root Mean Square Error of Calibration is %g',rmsec);
    disp(s), disp('  ')
s = sprintf('Root Mean Square Error from ANOVA is %g',rmse);
    disp(s), disp('  ')
s = sprintf('Root Mean Square Error of Cross Validation = %g',...
      rmsecv);
disp(s)

% Make Plots

% Plot fitted by true from Calibration
plot(y,pred,'+')
hold on
z = axis;
plot(z(1:2),z(1:2),'-g'), hold off
title('Actual VS Predicted Plot from Calibration')
xlabel('Actual Value')
ylabel('Predicted Value'), drawnow
pause; disp('<Hit return to continue>')

% Plot fitted by true from Calibration
% Add +/- 2*S.E. of Mean
plot(y,pred,'+')
hold on
for i = 1:n
    yi = y(i,:);
    plot([yi yi],[LLybar(i,:) ULybar(i,:)],'-r')
end
z = axis;
plot(z(1:2),z(1:2),'-g'), hold off
title('Calibration Predictions with +/- 2*S.E. of Mean')
xlabel('Actual Value')
ylabel('Predicted Value'), drawnow
pause; disp('<Hit return to continue>')

% Plot fitted by true from Calibration
% Add +/- 2*S.E. of New Obs.
plot(y,pred,'*')
hold on
for i = 1:n
        yi = y(i,:);
        plot([yi yi],[LLy(i,:) ULy(i,:)],'-r')
end
z = axis;
plot(z(1:2),z(1:2),'-g'), hold off
title('Calibration Predictions with +/- 2*S.E. of New Obs.')
xlabel('Actual Value')
ylabel('Predicted Value'), drawnow
pause; disp('<Hit return to continue>')

% Plot fitted by true from Cross-validation
plot(y,predi,'+')
hold on
z = axis;
plot(z(1:2),z(1:2),'-g'), hold off
title('Actual VS Predicted Plot from Cross-validation')
xlabel('Actual Value')
ylabel('Predicted Value'), drawnow


