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

clear;
close all;
N = 100;    % Number of Points
sig = 0.03; % Inlier Varience
osig = 1;   % Outlier Varience
th = 0.09;  % Inlier Threshold

n = 2; % Dimension of space
m = rand(n-1, 1); 
c = randn; 

% Generate data 
xo = rand(n-1,N); 
yo = m'*xo + repmat(c,1,N); 

% Corrupt data 
x = xo + sig*randn(n-1,N);
y = yo + sig*randn(1,N); 

% Add outliers.
t = 10; 
t = round(N*t/100); 

sn = sign(y(1:t) - m'*xo(:, 1:t)-c); 
y(1:t) = y(1:t) + double(sn-~sn)*osig.*rand(1, t);
x = x'; 
y = y';

%% Rewrite the equation of lines
x = [x, ones(N, 1)]; 
x0 = rand(n, 1); 

v1 = 1:N; 
trial = 0; 
notrial = 1; 
vpt = 0; 
tic;
for i=1:notrial
    [P1, v1, trialtmp] = maxconRANSAC(x, y, th);
    vpt = vpt + numel(v1); 
    trial = trial + trialtmp; 
end
t1 = toc/notrial;
vpt = vpt/notrial; 
trial =trial/notrial; 

tic;
v2 = zeros(1, t);
% [P2, v2] = maxconMIDCP(x, y, th); 
% To make sure the Global Solution, you need to have cvx "Gurobi" installed
t2 = toc; 

%%
tic;
v5 = zeros(1, t);
[P5, val5, v5, mcnum5,mxnum5] = maxconASTAR(x, y, x0, th);
t5 = toc;

% To check the global solution or not || find(abs(x*P5 - y) > th) ||

fprintf(' RANSAC time %f, ASTAR time %f\n',t1, t5);
disp('    Model     RANSAC    ASTAR');
disp([[m;c], P1, P5]); 
disp('Number of Inliers:'); 
disp(['RANSAC = ' num2str(N - numel(v1))]); 
disp(['ASTAR = ' num2str(N - numel(v5))]); 

if n == 2
    h = figure(1);
    clf; 
    hold on;
    plot(x(:, 1),y,'b*');
    a = [min(x(:, 1)) max(x(:, 1))]; 
    axis([a, min(y)-0.1, max(y)+0.1]);

    lineplot(h, a, P1, 'r');
    lineplot(h, a, P5, 'g');
    plot(x(v1, 1),y(v1),'ro','MarkerSize',12);
    plot(x(v5, 1),y(v5),'go','MarkerSize',16);
    hold off; 

    legend('Points', 'RANSAC Solution', 'ASTAR Solution', 'RANSAC Outliers', 'ASTAR Outliers'),
    title('RANSAC Vs ASTAR');
end
