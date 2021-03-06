function out=makePolyDABCD(n,m,p,N,d,param)
% function out = makePolyDABCD(n,m,p,N,d,param)
%
% Make a polytopic discrete system (A,B,C,D) with random stable vertices A1,A2,...,An 
% and the greatest eigvalue radius at d
%
% input:  n -> number of states
%         m -> number of inputs
%         p -> number of outputs
%         N -> number of vertices
%         d -> greatest eigvalue radiu
%         param.dt -> (optional) used for ajust the grid (default dt=0.01)
%         param.n  -> (optional) used for ajust the number of
%         random points in the polytope
%         param.feedforward -> 0: there is; 1: there isn't;
%        
% output: out.N             -> number of vertices
%         out.dim           -> dimension of the system
%         out.clock         -> times took for create the polytope
%         out.eig           -> eigvalues of the convex combination of A{:}
%         out.eigV          -> eigvalues of the vertices A{:}
%         out.r         -> radius of the convex combination of A{:}
%         out.rV          -> radius of the vertices A{:}
%	  out.alpha         -> values of simplex 
%	  out.maxEig        -> gretest eigvalue of A{:}
%         out.alphaMaxEig   -> simplex point of the greatest eigvalue
%
% E.g.
% sys=makePolyDABCD(3,1,2,2,-1)
%
%
% Date: 23/09/2017
% Author: Marcos Rogério Fernandes 
% Email: eng.marofe@hotmail.com

feedforward=1; %default there is feedforward
if nargin==5
    param=0;
else
    if isfield(param,'feedforward')
        feedforward=param.feedforward;
    end
end
%% generate vertices for A stable and randomness
for i=1:N
    A{i}=randn(n,n);
    k=max(real(eig(A{i})));
    if k>0
        A{i}=A{i}/k;
    end
    %% generate vertices for B,C and D randomness
    B{i}=randn(n,m);
    C{i}=randn(p,n);
    if feedforward==1
        D{i}=randn(p,m);
    else
        D{i}=zeros(p,m);
    end
end
poly=checkPolyD(A);
k=poly.maxR/d;
A=gmultiply(A,1/k);
out.A=A;
out.B=B;
out.C=C;
out.D=D;
out.dim=n;
out.input=m;
out.output=p;
out.N=N;
out.feedforward=feedforward;
end