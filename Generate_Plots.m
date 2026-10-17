% LES10A230 Engineering Mathematics IV - Project Assignment
% Plotting Script for Newton's Method (Simplified 2D Contour)
% Author: Santeri Saarinen

clear; clc; close all;

% 1. Run the Analytical Iteration to Gather Data
x = 1; y = 7;
tol = 1e-6; 
max_iter = 50;

% Arrays to store the history of the path
x_hist = x; 
y_hist = y;
f_hist = 3*x^2 + 2*x*y + 3*y^2 + x - y;

for n = 1:max_iter
    cx = 6*x + 2*y + 1;
    cy = 2*x + 6*y - 1;
    grad_mag = sqrt(cx^2 + cy^2);
    
    if grad_mag < tol
        break; 
    end
    
    alpha = (cx^2 + cy^2) / (6*cx^2 + 4*cx*cy + 6*cy^2);
    
    x = x - alpha * cx;
    y = y - alpha * cy;
    
    % Store values for plotting
    x_hist = [x_hist, x];
    y_hist = [y_hist, y];
    f_hist = [f_hist, 3*x^2 + 2*x*y + 3*y^2 + x - y];
end

% --- 2. Figure 1: 2D Convergence Plot ---
figure(1);
plot(0:length(f_hist)-1, f_hist, '-bo', 'LineWidth', 2, 'MarkerFaceColor', 'b');
grid on;
xlabel('Iteration Number', 'FontWeight', 'bold');
ylabel('Objective Function Value f(x,y)', 'FontWeight', 'bold');
title('Convergence of Analytical Newton''s Method', 'FontWeight', 'bold');
set(gca, 'FontSize', 12);

% 3. Figure 2: 2D Contour Map
figure(2);
% Create a mesh grid for the contour map
[X, Y] = meshgrid(-2.5:0.1:2, -1:0.1:8);
Z = 3*X.^2 + 2.*X.*Y + 3*Y.^2 + X - Y;

% Plot the contour map with 30 level lines
contour(X, Y, Z, 30, 'LineWidth', 1);
colormap parula;
colorbar;
hold on;

% Plot the 2D iteration path over the contours
plot(x_hist, y_hist, '-ro', 'LineWidth', 2, 'MarkerSize', 6, 'MarkerFaceColor', 'r');

% Highlight the Start and End points
plot(x_hist(1), y_hist(1), 'gs', 'MarkerSize', 10, 'MarkerFaceColor', 'g'); % Start (Green Square)
plot(x_hist(end), y_hist(end), 'k*', 'MarkerSize', 12, 'LineWidth', 2);     % End (Black Star)

hold off;
grid on;
xlabel('x axis', 'FontWeight', 'bold'); 
ylabel('y axis', 'FontWeight', 'bold'); 
title('Iteration Path on 2D Contour Map', 'FontWeight', 'bold');
legend('Function Contours', 'Iteration Path', 'Start Point', 'Minimum Point', 'Location', 'northeast');
set(gca, 'FontSize', 12);