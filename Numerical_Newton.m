% LES10A230 Engineering Mathematics IV - Project Assignment
% Author: Santeri Saarinen

clear; clc;

% Personal constants
A = 3; B = -2; C = 3;
x0 = 1; y0 = 7;

% Define the function
f = @(x, y) 3*x^2 + 2*x*y + 3*y^2 + x - y;

% Array of h values to test (from 10^-2 down to 10^-10)
h_vals = [1e-2, 1e-3, 1e-4, 1e-5, 1e-6, 1e-7, 1e-8, 1e-9, 1e-10];
tolerance = 1e-6; 
max_iterations = 50;

fprintf(' h value    | Iterations | Final x     | Final y     | Accurate to 5 sig figs?\n');
fprintf('------------------------------------------------------------------------------\n');

for i = 1:length(h_vals)
    h = h_vals(i);
    x = x0; 
    y = y0;
    
    for n = 1:max_iterations
        % 1. Calculate Numerical Gradient (Forward Difference)
        cnx = (f(x + h, y) - f(x, y)) / h;
        cny = (f(x, y + h) - f(x, y)) / h;
        
        grad_mag = sqrt(cnx^2 + cny^2);
        if grad_mag < tolerance
            break;
        end
        
        % 2. Calculate Analytical Gradient for the dynamic alpha formula
        % As per instructions, only the second term in the dot product uses num derivatives
        cx_orig = 6*x + 2*y + 1;
        cy_orig = 2*x + 6*y - 1;
        
        % 3. Calculate optimal alpha
        % derived from dot( grad_analytical(x_new), grad_numerical(x_old) ) = 0
        numerator = cx_orig * cnx + cy_orig * cny;
        denominator = 6*cnx^2 + 4*cnx*cny + 6*cny^2;
        alpha = numerator / denominator;
        
        % 4. Update coordinates
        x_new = x - alpha * cnx;
        y_new = y - alpha * cny;
        
        if abs(x_new - x) < tolerance && abs(y_new - y) < tolerance
            x = x_new; y = y_new;
            break;
        end
        
        x = x_new;
        y = y_new;
    end
    
    % Check if the result matches the true minimum (-0.25, 0.25) to 5 significant figures
    if round(x, 5) == -0.25000 && round(y, 5) == 0.25000
        accurate = 'Yes';
    else
        accurate = 'No';
    end
    
    fprintf(' %.0e      | %2d         | %10.6f  | %10.6f  | %s\n', h, n, x, y, accurate);
end