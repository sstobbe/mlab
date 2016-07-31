# MLab
Instrument control and acquisition from Matlab using the National Instruments VISA Interface. The VISA framework allows for communication over any bus to an instrument/device providing a SCPI interface.

At present only the Windows 32-bit VISA library has been tested in the MLab wrapper.

## Supported Instruments
* DS1054Z Oscilloscope
* E3648A Power Supply
* E3634A Power Supply

## Sample Code
To acquire a waveform from the DS1054Z oscilloscope the following sample Matlab code can be used with MLab's subdirectories in the Matlab path.

```matlab
h = DS1054Z('USB0::0x1AB1::0x04CE::MYSERNUM::INSTR');
```

To acquire channel one's acquisition record:
```matlab
[ y, Fs, ts ] = h.WaveAcquire(1);
```
The resulting values are 

y: Channel Voltage  (N x k)

Fs: Sample Rate (1 x 1)

ts: Sample Times (N x k)

Where N is the memory length and k is the number of channels acquired.

To acquire multiple channels, for instance channels 1, 3, and 4, one would do the following:
```matlab
[ y, Fs, ts ] = h.WaveAcquire([1 3 4]);
```

All of the properites of the DS1054Z handle are feteched over SCPI; no caching is performed. Using the default matlab variable display in the comand window results in the following:
```matlab
h
```

```
 Properties:
          RSRC_ADDR: 'USB0::0x1AB1::0x04CE::MYSERNUM::INSTR'
               vCom: [1x1 VISA32]
                MFG: 'Rigol Technologies.'
                 PN: 'DS1000Z Series'
                 SN: 'MYSERNUM'
             FW_VER: []
          CHAN1_BWL: 0
         CHAN1_COUP: 'DC'
         CHAN1_DISP: 1
          CHAN1_INV: 0
         CHAN1_OFFS: -1.5000
         CHAN1_RANG: 4
         CHAN1_TCAL: 0
         CHAN1_SCAL: 0.5000
         CHAN1_PROB: 1
         CHAN1_UNIT: 'VOLT'
         CHAN1_VERN: 0
          CHAN2_BWL: 0
         CHAN2_COUP: 'DC'
         CHAN2_DISP: 0
          CHAN2_INV: 0
         CHAN2_OFFS: -16.4000
         CHAN2_RANG: 80
         CHAN2_TCAL: 0
         CHAN2_SCAL: 10
         CHAN2_PROB: 10
         CHAN2_UNIT: 'VOLT'
         CHAN2_VERN: 0
          CHAN3_BWL: 0
         CHAN3_COUP: 'DC'
         CHAN3_DISP: 0
          CHAN3_INV: 0
         CHAN3_OFFS: -2.0200
         CHAN3_RANG: 8
         CHAN3_TCAL: 0
         CHAN3_SCAL: 1
         CHAN3_PROB: 10
         CHAN3_UNIT: 'VOLT'
         CHAN3_VERN: 0
          CHAN4_BWL: 0
         CHAN4_COUP: 'AC'
         CHAN4_DISP: 0
          CHAN4_INV: 0
         CHAN4_OFFS: 0
         CHAN4_RANG: 3.2000
         CHAN4_TCAL: 0
         CHAN4_SCAL: 0.4000
         CHAN4_PROB: 20
         CHAN4_UNIT: 'VOLT'
         CHAN4_VERN: 0
          DISP_TYPE: 'VECT'
     DISP_PERS_TIME: NaN
       DISP_WAVE_BR: 100
          DISP_GRID: 'FULL'
       DISP_GRID_BR: 100
            T_SCALE: 1.0000e-003
           T_OFFSET: 0
             T_MODE: 'MAIN'
              SRATE: 250000000
      TRIG_EDGE_CHN: 'CHAN2'
    TRIG_EDGE_SLOPE: 'NEG'
    TRIG_EDGE_LEVEL: 2.2000
         TRIG_SWEEP: 'AUTO'
        TRIG_STATUS: 'AUTO'
          WREC_FEND: 5
          WREC_FMAX: 10
          WREC_FINT: 1.0000e-007
          WREC_PROM: 1
          WREC_OPER: 0
          WREC_ENAB: 0
       WPLAY_FSTART: 1.0000e-007
         WPLAY_FEND: 1
         WPLAY_FMAX: 1
         WPLAY_FINT: 0.0100
         WPLAY_MODE: 'REP'
          WPLAY_DIR: 'FORW'
         WPLAY_OPER: 'STOP'
         WPLAY_FCUR: 1
```
