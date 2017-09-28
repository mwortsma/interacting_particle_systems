function [t,s] = simulate_diffeq(k, lam, d, dt, t_end)
% Simulates the differential equation for s_1,...,s_k.

% Get differential equation.
dsdt = @(t,s) get_dsdt(k, lam, d, s);

% Get initial conditions.
initial_conditions = zeros(k, 1); initial_conditions(1) = 1;

% Solve
[t,s] = ode45(dsdt, 0:dt:t_end, initial_conditions);
end


function out = get_dsdt(k, lam, d, s)
% Returns a k by 1 vector ds/dt where s(i) = ratio of queues with at least
% i items. 

% The assumption ds(k)/dt = 0 is made. It is assumed that k will be
% sufficiently large so that a queue will never be of size k.

out = zeros(k,1);
out(1) = 0; % s(1) for all t

for i = 2:(k-1)
    % s(i-1)^d - s(i)^d is the probably a new item routes to a queue which
    % currently contains i items (and lambda is the rate). s(i) - s(i+1) is
    % the rate at which a queue of length i will serve an item.
    out(i) = lam*(s(i-1)^d - s(i)^d) - (s(i) - s(i+1));
end
end
