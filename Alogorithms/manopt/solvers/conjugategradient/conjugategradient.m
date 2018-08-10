function [x, cost, info, options] = conjugategradient(problem, x)

options.minstepsize = 1e-5;
options.maxiter = 50;
options.tolgradnorm = 1e-5;
options.storedepth = 2;
options.beta_type = 'H-S';
options.orth_value = Inf;
options.linesearch = @linesearch_adaptive;

% for convenience
inner = problem.M.inner;
lincomb = problem.M.lincomb;

% Create a store database
storedb = struct();

% If no initial point x is given by the user, generate one at random.
if ~exist('x', 'var') || isempty(x)
    x = problem.M.rand();
end

% Compute objective-related quantities for x
[cost grad storedb] = getCostGrad(problem, x, storedb);
gradnorm = problem.M.norm(x, grad);
[Pgrad storedb] = getPrecon(problem, x, grad, storedb);
gradPgrad = inner(x, grad, Pgrad);

% Iteration counter (at any point, iter is the number of fully executed
% iterations so far)
iter = 0;

% Save stats in a struct array info and preallocate,
% see http://people.csail.mit.edu/jskelly/blog/?x=entry:entry091030-033941
stats = savestats();
info(1) = stats;
info(min(10000, options.maxiter+1)).iter = [];

% Initial linesearch memory
lsmem = [];


% if options.verbosity >= 2
%     % fprintf(' iter\t                cost val\t     grad. norm\n');
% end

% Compute a first descent direction (not normalized)
desc_dir = lincomb(x, -1, Pgrad);


% Start iterating until stopping criterion triggers
while true
    
    % Display iteration information
%     if options.verbosity >= 2
%         % fprintf('%5d\t%+.16e\t%.8e\n', iter, cost, gradnorm);
%     end
    
    % Start timing this iteration
    timetic = tic();
    
    % Run standard stopping criterion checks
    [stop reason] = stoppingcriterion(problem, x, options, info, iter+1);
    
    % Run specific stopping criterion check
    if ~stop && abs(stats.stepsize) < options.minstepsize
        stop = true;
        reason = 'Last stepsize smaller than minimum allowed. See options.minstepsize.';
    end
    
    if stop
%         if options.verbosity >= 1
%             %   fprintf([reason '\n']);
%         end
        break;
    end
    
    
    % The line search algorithms require the directional derivative of the
    % cost at the current point x along the search direction.
    df0 = inner(x, grad, desc_dir);
    
    % If we didn't get a descent direction: restart, i.e., switch to the
    % negative gradient. Equivalent to resetting the CG direction to a
    % steepest descent step, which discards the past information.
    if df0 >= 0
        
        % Or we switch to the negative gradient direction.
%         if options.verbosity >= 3
%             %             fprintf(['Conjugate gradient info: got an ascent direction '...
%             %                      '(df0 = %2e), reset to the (preconditioned) '...
%             %                      'steepest descent direction.\n'], df0);
%         end
        % Reset to negative gradient: this discards the CG memory.
        desc_dir = lincomb(x, -1, Pgrad);
        df0 = -gradPgrad;
        
    end
    
    
    % Execute line search
    [stepsize newx storedb lsmem lsstats] = options.linesearch(...
        problem, x, desc_dir, cost, df0, options, storedb, lsmem);
    
    
    % Compute the new cost-related quantities for x
    [newcost newgrad storedb] = getCostGrad(problem, newx, storedb);
    newgradnorm = problem.M.norm(newx, newgrad);
    [Pnewgrad storedb] = getPrecon(problem, x, newgrad, storedb);
    newgradPnewgrad = inner(newx, newgrad, Pnewgrad);
    
    
    % Apply the CG scheme to compute the next search direction.
    %
    % This paper https://www.math.lsu.edu/~hozhang/papers/cgsurvey.pdf
    % by Hager and Zhang lists many known beta rules. The rules defined
    % here can be found in that paper (or are provided with additional
    % references), adapted to the Riemannian setting.
    %
    if strcmpi(options.beta_type, 'steep') || ...
            strcmpi(options.beta_type, 'S-D')              % Gradient Descent
        
        beta = 0;
        desc_dir = lincomb(x, -1, Pnewgrad);
        
    else
        
        oldgrad = problem.M.transp(x, newx, grad);
        orth_grads = inner(newx, oldgrad, Pnewgrad)/newgradPnewgrad;
        
        % Powell's restart strategy (see page 12 of Hager and Zhang's
        % survey on conjugate gradient methods, for example)
        if abs(orth_grads) >= options.orth_value,
            beta = 0;
            desc_dir = lincomb(x, -1, Pnewgrad);
            
        else % Compute the CG modification
            
            desc_dir = problem.M.transp(x, newx, desc_dir);
            
            if strcmp(options.beta_type, 'F-R')  % Fletcher-Reeves
                beta = newgradPnewgrad / gradPgrad;
                
            elseif strcmp(options.beta_type, 'P-R')  % Polak-Ribiere+
                % vector grad(new) - transported grad(current)
                diff = lincomb(newx, 1, newgrad, -1, oldgrad);
                ip_diff = inner(newx, Pnewgrad, diff);
                beta = ip_diff/gradPgrad;
                beta = max(0, beta);
                
            elseif strcmp(options.beta_type, 'H-S')  % Hestenes-Stiefel+
                diff = lincomb(newx, 1, newgrad, -1, oldgrad);
                ip_diff = inner(newx, Pnewgrad, diff);
                beta = ip_diff / inner(newx, diff, desc_dir);
                beta = max(0, beta);
                
            elseif strcmp(options.beta_type, 'H-Z') % Hager-Zhang+
                diff = lincomb(newx, 1, newgrad, -1, oldgrad);
                Poldgrad = problem.M.transp(x, newx, Pgrad);
                Pdiff = lincomb(newx, 1, Pnewgrad, -1, Poldgrad);
                deno = inner(newx, diff, desc_dir);
                numo = inner(newx, diff, Pnewgrad);
                numo = numo - 2*inner(newx, diff, Pdiff)*...
                    inner(newx, desc_dir, newgrad)/deno;
                beta = numo/deno;
                
                % Robustness (see Hager-Zhang paper mentioned above)
                desc_dir_norm = problem.M.norm(newx, desc_dir);
                eta_HZ = -1/(desc_dir_norm * min(0.01, gradnorm));
                beta = max(beta,  eta_HZ);
                
            else
                error(['Unknown options.beta_type. ' ...
                    'Should be steep, S-D, F-R, P-R, H-S or H-Z.']);
            end
            desc_dir = lincomb(newx, -1, Pnewgrad, beta, desc_dir);
        end
        
    end
    
    % Make sure we don't use too much memory for the store database.
    storedb = purgeStoredb(storedb, options.storedepth);
    
    % Update iterate info
    x = newx;
    cost = newcost;
    grad = newgrad;
    Pgrad = Pnewgrad;
    gradnorm = newgradnorm;
    gradPgrad = newgradPnewgrad;
    
    % iter is the number of iterations we have accomplished.
    iter = iter + 1;
    
    % Log statistics for freshly executed iteration
    stats = savestats();
    info(iter+1) = stats; %#ok<AGROW>
    
end


info = info(1:iter+1);

% if options.verbosity >= 1
%     % fprintf('Total time is %f [s] (excludes statsfun)\n', info(end).time);
% end


% Routine in charge of collecting the current iteration stats
    function stats = savestats()
        stats.iter = iter;
        stats.cost = cost;
        stats.gradnorm = gradnorm;
        if iter == 0
            stats.stepsize = nan;
            stats.time = 0;
            stats.linesearch = [];
            stats.beta = 0;
        else
            stats.stepsize = stepsize;
            stats.time = info(iter).time + toc(timetic);
            stats.linesearch = lsstats;
            stats.beta = beta;
        end
        stats = applyStatsfun(problem, x, storedb, options, stats);
    end

end


