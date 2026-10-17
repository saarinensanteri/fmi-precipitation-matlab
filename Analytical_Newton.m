% LES10A230 Engineering Mathematics IV - Project Assignment
% Part 1: Analytical Newton's Method with Dynamic Alpha
% Author: Santeri Saarinen

clear; clc;

% Initialize Parameters (my personal ones)
A = 3; 
B = -2; 
C = 3;

% Initial starting coordinates (my personal ones)
x = 1; 
y = 7;

% Setup convergence criteria
tolerance = 1e-6; % Sufficient to guarantee 5 significant figures
max_iterations = 50;

% Print table header for the report data
fprintf('Iter |       x       |       y       |    f(x,y)     |     alpha     |   Grad Mag    \n');
fprintf('---------------------------------------------------------------------------------------\n');

% Optimization Loop
for n = 1:max_iterations
    
    % Step A: Calculate the current function value
    f_val = 3*x^2 + 2*x*y + 3*y^2 + x - y;
    
    % Step B: Calculate the exact Analytical Gradient (cx, cy)
    cx = 6*x + 2*y + 1;
    cy = 2*x + 6*y - 1;
    
    % Calculate the magnitude of the gradient to check for convergence
    grad_mag = sqrt(cx^2 + cy^2);
    
    % Step C: Calculate the optimal dynamic step length (alpha)
    % This is derived exactly from the condition that the dot product
    % of the new gradient and the current gradient equals zero:
    % dot( grad_f(x - alpha*cx, y - alpha*cy), [cx, cy] ) = 0
    numerator = cx^2 + cy^2;
    denominator = 6*cx^2 + 4*cx*cy + 6*cy^2;
    alpha = numerator / denominator;
    
    % Print the current state to the console (useful for the report table)
    fprintf('%4d | %13.6f | %13.6f | %13.6f | %13.6f | %13.6f\n', n-1, x, y, f_val, alpha, grad_mag);
    
    % Step D: Check for convergence
    % If the gradient is extremely close to 0, we have reached the minimum
    if grad_mag < tolerance
        fprintf('\nMinimum reached successfully!\n');
        break;
    end
    
    % Step E: Update coordinates for the next iteration
    % x_new = x_old - alpha * gradient_x
    x_new = x - alpha * cx;
    y_new = y - alpha * cy;
    
    % Alternative convergence check using step size (5 significant figures)
    if abs(x_new - x) < tolerance && abs(y_new - y) < tolerance
        x = x_new; 
        y = y_new;
        fprintf('\nConverged based on step size limits.\n');
        break;
    end
    
    % Apply updates
    x = x_new;
    y = y_new;
end

% --- 3. Final Output ---
fprintf('---------------------------------------------------------------------------------------\n');
fprintf('Final Minimum Point: x = %.6f, y = %.6f\n', x, y);
fprintf('Final Function Value: f(x,y) = %.6f\n', 3*x^2 + 2*x*y + 3*y^2 + x - y);