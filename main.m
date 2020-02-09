%% MATLAB E2018b
clear

%format long e

%% read and plot data
data = zeros(1024,5);
for i=1:5
    filename = strcat('scenario_',num2str(i),'.txt');
    data(:,i) = csvread(filename);
    figure(i)
    plot(1:1024, data(:,i)), xlabel('bins'), ylabel('counts'), title(strcat('scenario',num2str(i))), grid on
end

%% normalization
norm_data = zeros(1024,5);
for i=1:5
    norm_data(:,i) = data(:,i)./max(data(:,i));
end

%% Metrics
ntotal = zeros(1,5);
max8 = zeros(1,5);
bin05 = zeros(1,5);
bin08 = zeros(1,5);
for i=1:5
   ntotal(i) = sum(norm_data(:,i));
   max8(i) = max(norm_data((225:1024),i)); % last 800 bins
   bin05(i) = sum(norm_data(:,i)<0.5);
   bin08(i) = sum(norm_data(:,i)>0.8);
end

%% Use fuzzy
fis = readfis("fuzzy_system.fis");
input = [ntotal' max8' bin05' bin08'];
infer = zeros(1,5);
infer_perc = zeros(1,5);
for i=1:5
    infer(i) = evalfis(fis, input(i,:));
    infer_perc(i) = infer(i)*100; % confidence value (percentage)
end

%% Print
fprintf("\nConfidence values for each scenario:\n")
for i=1:5
    fprintf("%.2f%% \t", infer_perc(i))
end
fprintf("\n==========================\n100%% means certain threat.\n0%%   means there is no threat.\n")