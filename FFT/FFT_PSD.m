function [ YSB, f ] = FFT_SBPSD( Vx, Fs, Navg, Fl, Fh, Rl )
%FFT_PSD Compute the PSD of Vx using the FFT alogrithm with a hanning
%window 

if ~exist('Navg','var') || isempty(Navg), Navg = 1; end
if ~exist('Rl','var') || isempty(Rl), Rl = 50; end
if ~exist('Fl','var') || isempty(Fl), Fl = 0; end
if ~exist('Fh','var') || isempty(Fh), Fh = Fs/2; end

len = length(Vx);

usePow2Len = 0;

if usePow2Len
    N = nextpow2(len)-1;
    NFFT = 2^N;
else
    % truncate to greatest even number of samples
    NFFT = len - mod(len,2);
end

% Generate window
window = hann(NFFT);

% Calculate window gain
if NFFT >= 10000
    % window gain error is 10 ppm at NFFT = 10000, converges to zero as
    % NFFT increases
    Wgain = 0.375;
else
    W = fft(window)/NFFT;
    Wgain = sum( W .* conj(W) );
end

% Truncate and window data set
y = detrend( Vx(1:NFFT) ) .* window;

Y = fft(y,NFFT)/NFFT;

f = (Fs/2*linspace(0,1,NFFT/2+1))';

df = Fs/NFFT;

Y = Y(1:NFFT/2+1);

YMAG = (2) * (Y .* conj(Y)) / (Wgain);

YSB = 10*log10(filtfilt( 1/Navg*ones(Navg,1),1,YMAG)) -10*log10(Rl) - 10*log10(df) + 30; % PSD in dbm/Hz (Normalized to 1Hz bin width)

idx_low = max( 0, Fl/df )+1;
idx_high= min( NFFT/2, Fh/df )+1;

YSB = YSB(idx_low:idx_high);
f = f(idx_low:idx_high);

if nargout == 0
    [~,m,ustr]=engunits(Fs/4);
    figure;
    plot( f.*m, YSB );
    grid on
    xlabel( [ 'Frequency [' ustr 'Hz]' ] )
    ylabel( 'Power [dbm/Hz] (1 Hz bin)' )
end

end

