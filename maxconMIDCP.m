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


function [x, v] = maxconMIDCP(x, y, th)
    
    BigM = 100; 
    [m, n] = size(x); 
    M = n+1:m+n;
    
    f = -[ones(m, 1)];
    A1 = [x, BigM*eye(m)]; 
    A2 = [-x, BigM*eye(m)]; 
    A = [A1; A2]; 
    
    b1 = th + y + BigM*ones(m, 1); 
    b2 = th - y + BigM*ones(m, 1); 
    b = [b1; b2]-10e-4; 
    
    lb = [-100*ones(n, 1)];
    ub = [100*ones(n, 1)];
    
    echo on; 
    cvx_begin
       cvx_precision high
       variable xopt(n)
       variable x(m) binary
       minimize( f' * x )
       subject to
           A * [xopt; x] <= b;
           lb <= xopt <= ub;
    cvx_end

    echo off;  
    v = 1:numel(y); 
    v(x>0.5) = []; 
    x = xopt;
end