classdef ERemoteMessage < uint32
    %EModeWaveType enum
    %
    % Scottie Stobbe 2022
    %
    % Enum constructed from list uci program manual
    %
    % General notes: 
    %
    enumeration
        RM_WORK_MODE                    (hex2dec('8000'))
        RM_CH_SW                        (hex2dec('8001'))
        RM_CH_SYNC_SW                   (hex2dec('8002')) 
        RM_CH_REVERTSE                  (hex2dec('8003'))
        RM_CH_LOAD                      (hex2dec('8004'))
        RM_CH_OUTPUT_LIMIT_ENABLE       (hex2dec('8005'))
        RM_CH_OUTPUT_LIMIT_MIN_LEVEL    (hex2dec('8006'))
        RM_CH_OUTPUT_LIMIT_MAX_LEVEL    (hex2dec('8007'))
        RM_BASE_WAVE_TYPE               (hex2dec('8008'))
        RM_BASE_FREQ                    (hex2dec('8009'))
        RM_BASE_PHASE                   (hex2dec('800A'))
        RM_BASE_AMP_VPP                 (hex2dec('800B'))
        RM_BASE_AMP_VRMS                (hex2dec('800C'))
        RM_BASE_AMP_VDBM                (hex2dec('800D'))
        RM_BASE_OFFSET                  (hex2dec('800E'))
        RM_BASE_HIGHT                   (hex2dec('800F'))
        RM_BASE_LOW                     (hex2dec('8010')) 
        RM_BASE_DUTY                    (hex2dec('8011'))
        RM_BASE_RISETIME                (hex2dec('8012'))
        RM_BASE_FALLTIME                (hex2dec('8013'))
        RM_BASE_ARB_PLAY_ENABLE         (hex2dec('8014'))
        RM_BASE_HARMOIC_TYPE            (hex2dec('8080')) 
        RM_BASE_HARMONIC_ONOFF          (hex2dec('8081'))
        RM_HARMONIC_NUM                 (hex2dec('8082'))
        RM_HARMONIC_SN_AMP_N            (hex2dec('8083'))
        RM_HARMONIC_SN_PHASE_N          (hex2dec('8084'))
        RM_HARMONIC_SN_AMP_2            (hex2dec('8085')) 
        RM_HARMONIC_SN_AMP_3            (hex2dec('8086'))
        RM_HARMONIC_SN_AMP_4            (hex2dec('8087'))
        RM_HARMONIC_SN_AMP_5            (hex2dec('8088'))
        RM_HARMONIC_SN_AMP_6            (hex2dec('8089'))
        RM_HARMONIC_SN_AMP_7            (hex2dec('808A'))
        RM_HARMONIC_SN_AMP_8            (hex2dec('808B'))
        RM_HARMONIC_SN_AMP_9            (hex2dec('808C'))
        RM_HARMONIC_SN_AMP_10           (hex2dec('808D'))
        RM_HARMONIC_SN_AMP_11           (hex2dec('808E'))
        RM_HARMONIC_SN_AMP_12           (hex2dec('808F'))
        RM_HARMONIC_SN_AMP_13           (hex2dec('8090'))
        RM_HARMONIC_SN_AMP_14           (hex2dec('8091'))
        RM_HARMONIC_SN_AMP_15           (hex2dec('8092'))
        RM_HARMONIC_SN_AMP_16           (hex2dec('8093'))
        RM_HARMONIC_SN_PHASE_2          (hex2dec('8094'))
        RM_HARMONIC_SN_PHASE_3          (hex2dec('8095'))
        RM_HARMONIC_SN_PHASE_4          (hex2dec('8096'))
        RM_HARMONIC_SN_PHASE_5          (hex2dec('8097'))
        RM_HARMONIC_SN_PHASE_6          (hex2dec('8098'))
        RM_HARMONIC_SN_PHASE_7          (hex2dec('8099'))
        RM_HARMONIC_SN_PHASE_8          (hex2dec('809A'))
        RM_HARMONIC_SN_PHASE_9          (hex2dec('809B'))
        RM_HARMONIC_SN_PHASE_10         (hex2dec('809C'))
        RM_HARMONIC_SN_PHASE_11         (hex2dec('809D'))
        RM_HARMONIC_SN_PHASE_12         (hex2dec('809E'))
        RM_HARMONIC_SN_PHASE_13         (hex2dec('809F'))
        RM_HARMONIC_SN_PHASE_14         (hex2dec('80A0'))
        RM_HARMONIC_SN_PHASE_15         (hex2dec('80A1'))
        RM_HARMONIC_SN_PHASE_16         (hex2dec('80A2'))
        RM_MOD_TYPE                     (hex2dec('8100')) 
        RM_MOD_WAVE                     (hex2dec('8101'))
        RM_MOD_FREQ                     (hex2dec('8102'))
        RM_MOD_RATE                     (hex2dec('8103'))
        RM_MOD_SCOPE                    (hex2dec('8104'))
        RM_MOD_SOURCE                   (hex2dec('8105'))
        RM_MOD_FRE_DEV                  (hex2dec('8106'))
        RM_MOD_PHASE_DEV                (hex2dec('8107'))
        RM_MOD_HOP_FREQ                 (hex2dec('8108'))
        RM_MOD_DATA_SOURCE              (hex2dec('8109'))
        RM_MOD_PSK_PHASE1               (hex2dec('810A'))
        RM_MOD_PSK_PHASE2               (hex2dec('810B'))
        RM_MOD_PSK_PHASE3               (hex2dec('810C'))
        RM_MOD_OSC_TIME                 (hex2dec('810D'))
        RM_MOD_IQ_MAP                   (hex2dec('810E'))
        RM_MOD_DUTY_DEV                 (hex2dec('810F'))
        RM_SWEEP_TYPE                   (hex2dec('8200'))
        RM_SWEEP_SOURCE                 (hex2dec('8201'))
        RM_SWEEP_TIME                   (hex2dec('8202'))
        RM_SWEEP_START_FREQ             (hex2dec('8203'))
        RM_SWEEP_STOP_FREQ              (hex2dec('8204'))
        RM_SWEEP_SYNC_FREQ              (hex2dec('8205'))
        RM_SWEEP_TIRG_OUT               (hex2dec('8206'))
        RM_BURST_TYPE                   (hex2dec('8307'))
        RM_BURST_SOURCE                 (hex2dec('8308')) 
        RM_BURST_TIRG_OUT               (hex2dec('8309'))
        RM_BURST_PERIOD                 (hex2dec('830A'))
        RM_BURST_PHASE                  (hex2dec('830B'))
        RM_BURST_CYCLES                 (hex2dec('830C'))
        RM_BURST_TIRG_EDGE              (hex2dec('830D'))
    end
end

