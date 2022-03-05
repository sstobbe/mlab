function [player] = PlayTone( Amp, Ftone, Tdur, Fs )
%PlayTone 
%   
if ~exist('Ftone','var') || isempty(Ftone), error('Ftone'); end
if ~exist('Fs','var') || isempty(Fs), Fs = 48000; end

SRateOptions = [ 8000, 11025, 22050, 44100, 48000, 96000 ];

t = 0:1/Fs:((Tdur*Fs)-1)/Fs;

Y = Amp.*sin(2*pi*Ftone*t);

player = audioplayer(Y,Fs,16,5);


player.play();

end

