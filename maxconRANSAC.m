%##########################################################################
%% G L O B A L L Y   O P T I M A L   C O N S E N S U S   M A X I M I S A T I O N
%% This package contains the source code which implements optimal Consensus 
% Maximisation proposed in
% T.J. Chin, P. Purkait, A. Eriksson and D. Suter
% Efficient Globally Optimal Consensus Maximisation with Tree Search, 
% In Proceedings of the IEEE Conference on Computer Vision and Pattern 
% Recognition (CVPR), June 2015, Boston
% 
% Copyright (c) 2015 Pulak Purkait (pulak.purkait@adelaide.edu.au.)
% School of Computer Science, The University of Adelaide, Australia
% The Australian Center for Visual Technologies
% http://www.cs.adelaide.edu.au/directory/pulak.purkait
%% Please acknowledge the authors by citing the above paper in any academic 
%  publications that have made use of this package or part of it.
%##########################################################################

function [P3, v3, trialcount] = maxconRANSAC(x, y, th)

    if nargin == 3
        feedback = 0;
    end
    X = [x, y]'; 
    fittingfn = @myFitTchebycheff;
    distfn    = @lineptdist;
    degenfn   = @isdegenerate;
    
    s = size(x, 2); 
    [L, inliers, trialcount] = ransac(X, fittingfn, distfn, degenfn, s, th, feedback);
    
    v3 = 1:numel(y); 
    v3(inliers) = []; 
    P3 = L; 
end


function [inliers, xn] = lineptdist(xn, XY, t)

    X = XY(1:end-1, :)';  
    Y = XY(end, :)'; 
    d = X*xn - Y; 
    
    inliers = find(abs(d) < t);
%     inliers = find(abs(d/sqrt(1+sum(xn(1:end-1).^2))) < t);
    
end

function r = isdegenerate(X)
    r = 0; 
%     r = norm(X(:,1) - X(:,2)) < eps;
end

