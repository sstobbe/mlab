% E3648A Dual Output Power Supply
vs = E3648A('GPIB0::5::INSTR');

% Ensure Output is disabled
vs.OUTPUT = 0;

% Configure Output Channel 1
%   Voltage Setpoint 5 VDC
%   Current Limit 1 ADC
vs.V1_SET = 5;
vs.I1_SET = 1;

% Configure Output Channel 2
%   Voltage Setpoint 15 VDC
%   Current Limit 100 mADC
vs.V2_SET = 15;
vs.I2_SET = .1;

% Enable Output
vs.OUTPUT = 1;

% Measure Channel 1 Load State
% Note voltage is measure at front panel terminals unless sense leads
% are connected to rear interface.
[ I1meas, V1meas ] = vs.Measure(1);

% Measure Channel 2 Load State
[ I2meas, V2meas ] = vs.Measure(2);