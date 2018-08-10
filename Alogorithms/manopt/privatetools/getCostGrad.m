function [cost, grad, storedb] = getCostGrad(problem, x, storedb)

    if isfield(problem, 'costgrad')
    %% Compute the cost/grad pair using costgrad.

		is_octave = exist('OCTAVE_VERSION', 'builtin');
		if ~is_octave
			narg = nargin(problem.costgrad);
		else
			narg = 2;
		end
	
        % Check whether the costgrad function wants to deal with the store
        % structure or not.
        switch narg
            case 1
                [cost, grad] = problem.costgrad(x);
            case 2
                % Obtain, pass along, and save the store structure
                % associated to this point.
                store = getStore(problem, x, storedb);
                [cost, grad, store] = problem.costgrad(x, store);
                storedb = setStore(problem, x, storedb, store);
            otherwise
                up = MException('manopt:getCostGrad:badcostgrad', ...
                    'costgrad should accept 1 or 2 inputs.');
                throw(up);
        end

    else
    %% Revert to calling getCost and getGradient separately
    
        [cost, storedb] = getCost(problem, x, storedb);
        [grad, storedb] = getGradient(problem, x, storedb);
        
    end
    
end
