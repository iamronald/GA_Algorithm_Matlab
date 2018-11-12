%the main thread to run the GA 

% Number of variables
nVars = 3;

% Lower and upper bounds
LB = zeros(1, nVars);
UB = ones(1, nVars);

% Variables with integer constraints (all in this case)
IntCon = 1:nVars;

% Run the GA solver
x = ga(@Fitness_Function, nVars, [], [], [], [], LB, UB, [], IntCon);