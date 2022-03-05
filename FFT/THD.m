function [ THD, REFPow, REFLevel ] = THD( Vx, Fs, EnPlot, Navg, Fl, Fh, Rl, winfun, usePow2Len, logPlot )
%FFT_PSD Compute the one-sided PSD of Vx using the FFT alogrithm with a 
%   window function
%
%   Vx      Real/Complex samples in time domain, if multichannel [ n x m ]
%               should be arranged column-major, n: samples, m: channels
%               assumed to be units of [Volts]
%
%   Fs      Sample rate of Vx [Hz]
%
%   Navg    Zero-Phase moving average filter of PSD, default N = 1
%               Similar to video bandwidth
%
%   Fl      lower edge of bandwidth of interest     [Hz]
%
%   Fh      upper edge of bandwidth of interest     [Hz]
%
%   Rl      Load resistance, default to 50 [Ohm]
%
%   winfun  Any windowing function can be provided with prototype winfun(N)
%               defaults to hanning
%
% Scott Stobbe 2016
if ~exist('EnPlot','var') || isempty(EnPlot), EnPlot = 1; end
if ~exist('Navg','var') || isempty(Navg), Navg = 4; end
if ~exist('Rl','var') || isempty(Rl), Rl = 50; end
if ~exist('Fl','var') || isempty(Fl), Fl = 0; end
if ~exist('Fh','var') || isempty(Fh), Fh = Fs/2; end
if ~exist('usePow2Len','var') || isempty(usePow2Len), usePow2Len = 0; end
if ~exist('logPlot','var') || isempty(logPlot), logPlot = 0; end
if ~exist('winfun','var') || isempty(winfun)
    if exist('hann'), winfun = @hann; elseif exist('hanning'),winfun = @hanning; end
end

len = size(Vx,1);

if usePow2Len
    N = nextpow2(len)-1;
    NFFT = 2^N;
else
    % truncate to greatest even number of samples
    NFFT = len - mod(len,2);
end

% Generate window
window = winfun(NFFT);

% Calculate window gain
if NFFT >= 10000 && any(strcmpi(func2str(winfun),{'hann', 'hanning'}))
    % window gain error is 10 ppm at NFFT = 10000, converges to zero as
    % NFFT increases
    Wgain = 0.375;
else
    W = fft(window)/NFFT;
    Wgain = sum( W .* conj(W) );
end

% Truncate and window data set
y = detrend( Vx(1:NFFT,:), 0 ) .* repmat( window, 1, size(Vx,2) );

Y = fft(y,NFFT)/NFFT;

f = (Fs/2*linspace(0,1,NFFT/2+1))';

df = Fs/NFFT;

Y = Y(1:NFFT/2+1, :);

YMAG = (2) * (Y .* conj(Y)) / (Wgain);

if Navg == 1
    YSB = 10*log10( YMAG );
else
    % Zero phase moving average filter on power sepectrum
    % Total spectral power is conserved 
    % Noise floor converges as N increases
    % A single frequency bin tone is spread over N bins with its peak power
    % reduced by 10log10(N), but total power is still conserved across N bins.
    YMAG = filtfilt( 1/Navg*ones(Navg,1),1,YMAG);
    YSB = 10*log10( YMAG );
end


% PSD in dbm/bin
YLogScale = -10*log10(Rl) + 30; % - 10*log10(df)

YSB = YSB + YLogScale;

% index the bandwidth of interest
idx_low = max( 0, Fl/df )+1;
idx_high= min( NFFT/2, Fh/df )+1;

YSB = YSB(idx_low:idx_high, :);
YMAG= YMAG(idx_low:idx_high, :);
f = f(idx_low:idx_high);

maxPeak = max(YSB);
noiseFloor = median(YSB);
minPeak = min(maxPeak - 80, noiseFloor + 35 );

[ pk, ik ] = findpeaks(YSB, 'MINPEAKHEIGHT', minPeak, 'MINPEAKDISTANCE', ceil(len/1000), 'THRESHOLD',0.0);


toneIdx = zeros(size(ik,1),2);
tonePow = zeros(size(ik,1),1);


for i = 1:length(pk)
   PeakLevel = pk(i);
   PeakIDX = ik(i);
   lowIdx = PeakIDX:-1:(max(PeakIDX-100,1));   
   
   lf = find( YSB(lowIdx) < PeakLevel - 20, 1, 'first' );
   if isempty(lf)
       %try -15 dB
       lf = find( YSB(lowIdx) < PeakLevel - 20, 1, 'first' );
       
       if isempty(lf)
           warning('Nondistintc harmonic')
           lf = 1;
       end
   end
   
   toneIdx(i,1) = PeakIDX - lf + 1;
   
   highIdx = PeakIDX:1:(min(PeakIDX+100,length(YSB)));
   
   hf = find( YSB(highIdx) < PeakLevel - 20, 1, 'first' );
   if isempty(hf)
       %try -15 dB
       hf = find( YSB(highIdx) < PeakLevel - 20, 1, 'first' );
       
       if isempty(hf)
           warning('Nondistintc harmonic')
           hf = 1;
       end
   end
   
   toneIdx(i,2) = PeakIDX + hf - 1;
   
   tonePow(i) = sum(YMAG(toneIdx(i,1):toneIdx(i,2)));
end

tonedB = 10*log10(tonePow) + YLogScale

REFTone = max(tonePow)

REFPow = 10*log10(REFTone) + YLogScale

THD = 10*log10( sum( tonePow( tonePow ~= REFTone ) ) / REFTone ) 

REFLevel = sqrt(REFTone)

fprintf('%0.3f kHz, %0.3f mVrms\n', [f(ik)'/1000; 1000*sqrt(tonePow)'])

if EnPlot
    figure;
    % for no return arguments plot onesided frequency spectrum
    [~,m,ustr]=engunits(mean([Fl Fh]));
    if logPlot
        semilogx(f, max(YSB,-200) );
        xlabel( [ 'Frequency [Hz]' ] )
    else
        plot( f.*m, max(YSB,-200) );
        xlabel( [ 'Frequency [' ustr 'Hz]' ] )
        hold all
        %plot( f(ik).*m, tonedB, 'rsq' )
    end
    grid on

    ylabel( [ 'Power [dBm] (' num2str(df,'%1.1f') ' Hz FFT bin)' ] )
end

% clear YSB for the default ans = 
YSB = [];



end



