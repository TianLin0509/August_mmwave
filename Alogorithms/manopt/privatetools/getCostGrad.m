function [cost, grad, storedb] = getCostGrad(problem, x, storedb)
cost = problem.cost(x);
[grad, storedb] = getGradient(problem, x, storedb);

end

