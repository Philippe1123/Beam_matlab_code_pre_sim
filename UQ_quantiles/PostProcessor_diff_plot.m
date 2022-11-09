function [  ] = PostProcessor_diff_plot(  )
%POSTPROCESSOR Summary of this function goes here
%   Detailed explanation goes here
% close all
clear all
clc


basename = 'Beam MLMC_Het_Lin_Ref22-01-2020-T:14:01:39';
read_samples = @(level, qoi) dlmread(strcat(basename, '/Samples/', ...
    num2str(qoi), '_1/samples_level_', num2str(level), '.txt'));

nqoi = 641;
nlevel = 4;

% preallocate samples
samples = cell(1, nlevel);
for level = 1:nlevel
    s = read_samples(level-1, 1);
    samples{level} = zeros(length(s), nqoi);
    for qoi = 1:nqoi
        samples{level}(:, qoi) = read_samples(level-1, qoi);
    end
end

%% jitter!

ntries = 10000;
shuffled_samples = zeros(ntries, nqoi);
for level = 1:nlevel
    myperm = randi(size(samples{level}, 1), size(shuffled_samples, 1), 1);
    shuffled_samples = shuffled_samples + abs(samples{level}(myperm, :));
end



x_in=0:5/640:5;


pdf=shuffled_samples';

pdf=pdf(1:nqoi,:);


Foldername='test';
x_in=x_in(2:end-1);

pdf=pdf(2:end-1,:);

pdfVisualisation_diff_plot(x_in,  pdf,-1,Foldername);

end

