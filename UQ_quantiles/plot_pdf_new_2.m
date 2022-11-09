%% plot pdf new

basename = 'Beam MLMC_TEST_UQ';
read_samples = @(level, qoi) dlmread(strcat(basename, '_samples/', ...
    num2str(qoi), '_1/samples_level_', num2str(level), '.txt'));

nqoi = 641;
nlevel = 3;

% preallocate samples
samples = cell(1, nlevel);
for level = 1:nlevel
    s = read_samples(level-1, 1);
    samples{level} = zeros(length(s), nqoi);
    for qoi = 2:nqoi
        samples{level}(:, qoi) = read_samples(level-1, qoi);
    end
end

%% jitter!

ntries = 10000;
shuffled_samples = zeros(ntries, nqoi);
for level = 1:nlevel
    myperm = randi(size(samples{level}, 1), size(shuffled_samples, 1), 1);
    shuffled_samples = shuffled_samples + samples{level}(myperm, :);
end

%% reinterpret outputs

% x = dlmread('x_values.dat');
% pressure = shuffled_samples(:, 1:90);%*1e5;
% temperature = shuffled_samples(:, 91:180)*370;
% mass_flow = shuffled_samples(:, 181)*20.5;
% pressure_ratio = shuffled_samples(:, 182)*2;
% temperature_ratio = shuffled_samples(:, 183);
% efficiency = shuffled_samples(:, 184);
displacement=shuffled_samples;
%% histograms for point data

% qois = {displacement};
% qoi_names = {'displacement'};
% 
% for qoi = 1:length(qois)
%     mmin = min(qois{qoi})*.98;
%     mmax = max(qois{qoi})*1.02;
%     dm = mmax - mmin;
%     xv = mmin:dm/500:mmax;
%     [heights, locations] = hist(qois{qoi}, xv);
%     width = locations(2) - locations(1);
%     heights = heights / (length(qois{qoi}) * width);
%     pd = fitdist(qois{qoi}, 'Kernel', 'Kernel', 'epanechnikov', 'support', [mmin, mmax]);
%     y = pdf(pd, xv);
%     
%     figure(qoi), clf, hold on
%     histogram(qois{qoi}, 'Normalization','pdf')
%     plot(xv, y, 'LineWidth', 4)
%     xlabel(qoi_names{qoi})
%     ylabel('pdf')
%     
%     dlmwrite(strcat(strjoin(strsplit(qoi_names{qoi}), '_'), '.txt'), vertcat(xv, y)', ' ')
% end

%% uq plots for field data
x=0:5/640:5;

nquantiles = 11;

% pressure ------>
figure(5), clf, hold on
quants = linspace(0, 1.0, nquantiles);
perc=linspace(0, 100, nquantiles);
Q = zeros(length(x), 2*(length(quants)-2)+2);
Q(:, 1) = x;

color = 'b';

for idq = 2:length(quants) - 1
    q = quantile(displacement, [0+quants(idq), 1-quants(idq)], 1);
    shadedErrorBar(x, median(displacement, 1), abs(q' - median(displacement, 1)'), 'lineprops', color, 'patchsaturation', 0.1)
    Q(:, idq) = q(1,:)';
    Q(:, size(Q, 2) - idq + 1) = q(2,:)';
end
plot(x, median(displacement, 1), 'linewidth', 1.5, 'color', color);
ylabel('Total Pressure [-]')
xlabel('relative radius [-]')
box on
grid on
axis([0 1 1.8 2.3])
set(gca,'view',[90 -90])
Q(:, end) = median(displacement, 1);
dlmwrite('pressure_quantiles.txt', Q, ' ')

% temperature ------>
figure(6), clf, hold on
quants = linspace(0, 0.5, nquantiles);
Q = zeros(length(x), 2*(length(quants)-2)+2);
Q(:, 1) = x;

color = 'r';

for idq = 2:length(quants) - 1
    q = quantile(temperature, [0+quants(idq), 1-quants(idq)], 1);
    shadedErrorBar(x, median(temperature, 1), abs(q' - median(temperature, 1)'), 'lineprops', color, 'patchsaturation', 0.1)
    Q(:, idq) = q(1,:)';
    Q(:, size(Q, 2) - idq + 1) = q(2,:)';
end
plot(x, median(temperature, 1), 'linewidth', 1.5, 'color', color);
ylabel('Total Temperature [-]')
xlabel('relative radius [-]')
box on
grid on
axis([0 1 360 385])
set(gca,'view',[90 -90])
Q(:, end) = median(temperature, 1);
dlmwrite('temperature_quantiles.txt', Q, ' ')