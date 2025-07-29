function [tildeK_R_T,tildeK_R_E,memory]=erosive(X_E,X_T,K_R_E,K_R_T,options)
% function [tildeK_R_T,tildeK_R_E,memory] = mlc.hmams.erosive(X_E,Y_E,X_T)
%
% X_E: nfeatures x nTrainInstances matrix of training vectors
% Y_E: nfeatures x nTestInstances matrix of test vectors
% K_R_E: nTrainInstances x nLabels formal context of training decisions

error(nargchk(3, 5, nargin));

if nargin < 5
    options.norm = false;
    options.islog = false;
end

%Do some preprocessing if necessary
if (options.norm)
    if (options.islog)
        %obtain a prototype for features
        proto = mean(X_E,2);%arithmetic mean is geometric max-min-plus mean!
        % proto2 = max(I_D_E,[],2)/(size(I_D_E,1));%the arithmetic max-plus mean makes no sense
        % proto3 = min(I_D_E,[],2)/(size(I_D_E,1));%the arithmetic min-plus mean makes no sense
        % proto4 = sum(I_D_E,2)/(size(I_D_E,1));%the geomerix max-min-plus mean
        diagproto = mmp.inv(mmp.l.diag(proto));%cg conjugate of diagonal matrix,
        X_E = mmp.u.mtimes(diagproto,X_E);%normalized I_D_E
        X_T = mmp.u.mtimes(diagproto,X_T);%normalized I_D_T
    else%if not log we suppose COUNTS
        proto = sum(X_E,2);
        for i = 1:nTrainInstances
            X_E(:,i) = log(X_E(:,i)./proto);
        end
        for i = 1:nTestInstances
            X_T(:,i) = log(X_T(:,i)./proto);
        end
    end
    %
end

%Scale the training decisions
%Y_E_log = mmp.x.Sparse(log(+(full(K_R_E.I.'))));%Initial version, returns
%so-so results
Y_E_log = +(full(K_R_E.I.'));%Second version
Y_E_log(Y_E_log == 0) = -1;%
Y_E_log = Y_E_log * 1000;
%Y_E_log = mmp.x.Sparse(-log(+(full(K_R_E.I.'))));%Third version: RETURNS EMPTY PHI LIST!!

%dilation = mmp.l.mrdivide(R_E_log,I_D_E);%Maybe it needs R_E to be min-plus encoded!!
memory = hmams.erosive.create(X_E,Y_E_log);
%FVA: do this with alternative third
%     veeY_T_log = hmams.dilative.recover(dilation,X_T);

%if requested, return estimated training context!
if (nargout > 1)
    tildeK_R_E = fca.mmp.Context(...
        K_R_E.G,K_R_E.M,...
        (hmams.erosive.recover(memory,X_E)).',...
        sprintf('%s-%s',K_R_E.Name,'erosive-hmam'));
end

%explore the different values of either type of memory!
tildeK_R_T = fca.mmp.Context(...
    K_R_T.G,K_R_T.M,...
    hmams.erosive.recover(memory,X_T).',...
    sprintf('%s-%s',K_R_T.Name,'erosive-hmam'));
return
