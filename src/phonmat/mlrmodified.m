function [r2,adjr2,rmse,rmsec,rmsecv,beta,stats] = multreg(x,y,verbose,dopic);

% MULTREG multiple regression
% 
%    [r2,adjr2,rmse,rmsec,rmsecv,beta,stats] = mlr(x,y,[verbose,dopic]);
%
%    Based on mlr.m by Remund and Eschbach (type 'help mlr') and
%    Modified by Dinoj Surendran (dinoj@cs.uchicago.edu) 
%     so it doesn't print pictures and tables by default. 
%     (It can be asked to - set verbose and dopic to 1 respectively.)
%
% Disclaimer: None of the authors nor the Battelle
% Memorial Institute claim any responsibility for the
% accuracy of results obtained using this function.

if nargin < 3
   verbose = 0;
end
if nargin < 4
   dopic=0;
end

p = size(x,2) + 1; % number of variables plus intercept
n = length(y);

% check to see that n >= # columns (independent vars)
if p>n
error('More variables than samples, use less variables and/or omit intercept')
end

[a,b] = size(y);  % make y a column vector
if a<b
    y = y';
end

x = [ones(n,1) x]; %add intercept
beta = inv(x'*x)*x'*y;
pred = x*beta;

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

if verbose

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

  disp('  ')
  s = sprintf('Root Mean Square Error of Calibration is %g',rmsec);
    disp(s), disp('  ')
  s = sprintf('Root Mean Square Error from ANOVA is %g',rmse);
    disp(s), disp('  ')
  s = sprintf('Root Mean Square Error of Cross Validation = %g', rmsecv);
  disp(s)
end

% Make Plots

if ~dopic, return; end;

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


