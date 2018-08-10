function [grad, storedb] = getGradient(problem, x, storedb)

  
        
        [egrad, storedb] = getEuclideanGradient(problem, x, storedb);
        grad = problem.M.egrad2rgrad(x, egrad);

    
end
