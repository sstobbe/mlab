classdef EModeWaveType < int32
    %EModeWaveType enum
    %
    % Scottie Stobbe 2022
    %
    % Enum constructed from list uci program manual
    %
    % General notes: 
    %
    enumeration
        MOD_WAVE_SINE      (0)
        MOD_WAVE_SQUARE    (1)
        MOD_WAVE_UPRAMP    (2)
        MOD_WAVE_DNRAMP    (3)
        MOD_WAVE_NOISE     (4)
        MOD_WAVE_ARB       (5) 
    end
end

