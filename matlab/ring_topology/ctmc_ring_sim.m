function [S_vect, Q_vect] = ...
    ctmc_ring_sim(n,lam, k, t_end, make_plot, mm1, num_neighbors)
% Use a continuous time markov chain to simulate the ring topology.
%% Parameters
% n = # of queues to use.
% lam = rate parameter lambda.
% k = # of S values to keep track of (s_i = ratio of queues with size >= i)
% t_end = which value of time to end at.
% make_plot = (bool) true to see animation, false to run fast.
% mm1 = (bool) true if no choice (MM1). false to choose between neighbors.
% maxes = (bool) true if you would like a vector returned of sup_t Q_i(t).

%% Return Values
% S_vect = the vector s_1,...,s_k at the end of the simulation.
% Q_vect = the vector of queue lengths at the end of the simulation.

% example usage ctmc_ring_sim(600,0.95,100,20,true,false,false)

% queues are initially empty. 
% M(i) = # of queues with >= i items.
% S(i) = M/n = ratio of queues with >= i items.
queues = zeros(n,1); M = zeros(k,1); M(1) = n; S = M/n;


% Returns the neighborhood centered around i (taking into account wrapping
% around the ring). E.g. if n = 10 then get_neighbors_index(10) = [9 10 1],
% and get_neighbors_index(5) = [4 5 6].
get_neighbors_index = @(i,nn) 1 + mod(i-nn-1:i+nn-1,n);

% Given a queue of length q and the neighborhood of three queues q_arr of
% which q is a part of, returns the to the queues of length q. Formula is:
% lam * indicator(1 == min(q_arr)) / \sum_{v \in q_arr} indicator(v = q).
% Dividing by the number of queues which also have length q.
get_rate = @(q,q_arr) lam*(q == min(q_arr))/(sum(q == q_arr));

t = 0; 
while t < t_end
    %% get entering rates
    if mm1
        % If M/M/1 is true then the entering rates are lambda for each
        % queue.
        entering_rates = ones(n,1)*lam;
    else
        % If not M/M/1 then there is choice.
        entering_rates = zeros(n,1);
        for i = 1:length(queues)
            % get the neighbor set for queue i.
            for neighbor_set = get_neighbors_index(i,num_neighbors)
                % for each neighbor n in the neighbor set, the neighbors of
                % n will be given by get_neighbors_index(n). Then get_rate
                % will get the rate to queue(i) from those neighbors.
                neighbors = queues(get_neighbors_index(neighbor_set,num_neighbors));
                entering_rates(i) = ...
                    entering_rates(i) + get_rate(queues(i), neighbors);
            end
        end
    end
    
    %% get leaving rates (1(queue length > 0))
    leaving_rates = queues > 0;
    
    %% Wait for ~ exp(\sum rates) seconds
    rates = [entering_rates; leaving_rates];
    sum_rates = sum(rates);
    delta_t = exprnd(1/sum_rates);
    t = t + delta_t;
    
    %% Make Jump
    % Sample each jump with probability distribution rates/sum_rates
   jump = randsample(1:length(rates),1,true,rates/sum_rates);
   
   % There are 2n jumps.
   if jump > n
       % jump > n corresponds to leaving a queue. Update queues and M.
       jump = jump-n;
       M(queues(jump)+1) = M(queues(jump)+1) - 1;
       queues(jump) = queues(jump) - 1;
   else
       % jump <= n corresponds to entering a queue. Update queues and M.
       queues(jump) = queues(jump) + 1;
       M(queues(jump)+1) = M(queues(jump)+1) + 1;
   end
   S = M/n;
   
   
   %% Visualize S if make_plot = true.
   if make_plot
    clf
    plot(S(1:20));
    title(sprintf("t = %.2f", t));
    pause(1e-10)
   end
end

%% Return the state of S and Q.
S_vect = S;
Q_vect = queues;
end
