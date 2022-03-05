classdef EModeType < int32
    %EModeWaveType enum
    %
    % Scottie Stobbe 2022
    %
    % Enum constructed from list uci program manual
    %
    % General notes: 
    %
    enumeration
        MT_AM      (0)
        MT_FM      (1)
        MT_PM      (2)
        MT_ASK     (3)
        MT_FSK     (4)
        MT_PSK     (5)
        MT_BPSK    (6)
        MT_QPSK    (7)
        MT_OSK     (8)
        MT_QAM     (9)
        MT_PWM     (10)
        MT_SUM     (11) 
    end
end

