
%Load and Preprocess the Data
rawData = readtable('niinisalo_data.csv'); 

%Extract dates and precipitation 
dates = datetime(rawData.Year, rawData.Month, rawData.Day); 
precip = rawData{:, 6}; 

TT = timetable(dates, precip);
TT_patched = fillmissing(TT, 'linear');
TT_clean = TT_patched(timerange('2008-04-01', '2026-03-31'), :);
monthly_data = retime(TT_clean, 'monthly', 'sum');

y = monthly_data.precip; 
t = (1:height(monthly_data))'; 


%Calculate the Long-Term Trends (Testing 1st vs 2nd Degree)
% Primary Model: 1st-degree (Linear)
trend_coeffs_1 = polyfit(t, y, 1);
trend_line_1 = polyval(trend_coeffs_1, t);

% Test Model: 2nd-degree (Quadratic) to see if MSE improves
trend_coeffs_2 = polyfit(t, y, 2);
trend_line_2 = polyval(trend_coeffs_2, t);


%% 3. Calculate the Seasonal Cycle (Fourier Series)
% We fit the Fourier series to the primary linear detrended data
detrended_y_1 = y - trend_line_1;
omega = 2 * pi / 12; 
X_fourier = [ones(length(t), 1), cos(omega * t), sin(omega * t)];

fourier_coeffs_1 = X_fourier \ detrended_y_1;
seasonal_wave_1 = X_fourier * fourier_coeffs_1;

% Fit a second Fourier series for the quadratic test model
detrended_y_2 = y - trend_line_2;
fourier_coeffs_2 = X_fourier \ detrended_y_2;
seasonal_wave_2 = X_fourier * fourier_coeffs_2;


%% 4. Combine Models and Compare Error (MSE)
% Model 1 (Linear)
predicted_y_1 = trend_line_1 + seasonal_wave_1;
MSE_1 = mean((y - predicted_y_1).^2);
fprintf('MSE (Linear Trend + Fourier): %.2f\n', MSE_1);

% Model 2 (Quadratic)
predicted_y_2 = trend_line_2 + seasonal_wave_2;
MSE_2 = mean((y - predicted_y_2).^2);
fprintf('MSE (Quadratic Trend + Fourier): %.2f\n', MSE_2);


%% 5. Forecast the Target (Next April) using the Primary Model
target_t = max(t) + 4; 

predicted_april_trend = polyval(trend_coeffs_1, target_t);
X_target = [1, cos(omega * target_t), sin(omega * target_t)];
predicted_april_season = X_target * fourier_coeffs_1;

predicted_april_total = predicted_april_trend + predicted_april_season;
fprintf('Forecasted April precipitation: %.2f mm\n', predicted_april_total);


%% 6. Plot the Final Results with Residuals
figure('Position', [100, 100, 800, 600]); 

% Top Plot: Main Forecast
subplot(3, 1, [1 2]); % Takes up the top 2/3 of the window
hold on; grid on;
bar(t, y, 'FaceColor', [0.7 0.8 1], 'EdgeColor', 'none', 'DisplayName', 'Actual Data');
plot(t, predicted_y_1, 'r-', 'LineWidth', 2, 'DisplayName', 'Linear + Fourier Model');
plot(target_t, predicted_april_total, 'g*', 'MarkerSize', 10, 'LineWidth', 2, 'DisplayName', 'April Forecast');
title('Kankaanpää Niinisalo: Monthly Precipitation Forecast');
ylabel('Precipitation (mm)');
legend('Location', 'best');
hold off;

% Bottom Plot: Residuals
subplot(3, 1, 3); 
hold on; grid on;
residuals = y - predicted_y_1;
scatter(t, residuals, 15, 'blue', 'filled'); % Plot the errors as black dots
yline(0, 'r--', 'LineWidth', 1.5); % Draw a red zero-error line
title('Model Residuals (Actual Data - Predicted Data)');
xlabel('Time (Months)');
ylabel('Error (mm)');
hold off;

%% Check the Climate Trend Direction
% Extract the slope from the linear fit
slope = trend_coeffs_1(1);

% Print the exact numerical rate of change
fprintf('Climate Trend Slope: %f mm/month\n', slope);

% Determine and print if it is getting wetter or drier
if slope > 0
    fprintf('Conclusion: The climate is getting WETTER over time.\n');
elseif slope < 0
    fprintf('Conclusion: The climate is getting DRIER over time.\n');
else
    fprintf('Conclusion: The climate is perfectly STABLE (No change).\n');
end