function [ offsetEstimates ] = fftFreqEst(modulationOrder,sampleRateHz, offsetData)
%% Estimation of error
fftOrder = 2^10; k = 1;
frequencyRange = linspace(-sampleRateHz/2,sampleRateHz/2,fftOrder);
% Precalculate constants
offsetEstimates = zeros(floor(length(offsetData)/fftOrder),1);
indexToHz = sampleRateHz/(modulationOrder*fftOrder);
for est=1:length(offsetEstimates)
    % Increment indexes
    timeIndex = (k:k+fftOrder-1).';
    k = k + fftOrder;
    % Remove modulation effects
    sigNoMod = offsetData(timeIndex).^modulationOrder;
    % Take FFT and ABS
    freqHist = abs(fft(sigNoMod));
    % Determine most likely offset
    [~,maxInd] = max(freqHist);
    offsetInd = maxInd - 1;
    if maxInd>=fftOrder/2 % Compensate for spectrum shift
        offsetInd = offsetInd - fftOrder;
    end
    % Convert to Hz from normalized frequency index
    offsetEstimates(est) = offsetInd * indexToHz;
end


end

