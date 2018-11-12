function out = Fitness_Function(valveSetting)
%FITNESS_FUNCTION Summary of this function goes here
%   Detailed explanation goes here
%   valveSetting will be caculated to find the fitness after run eclipse
%   out is the result

%flow area table
FlowAreaTable = [0.000085, 0.000170, 0.000256, 0.000341, 0.000426, 0.000511 , 0.000597 ,0.000682, 0.000767, 0.000852];


%run eclipse
system("eclrun.exe -q.QUEUE eclipse BOX_ICD");



end

