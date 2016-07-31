classdef E3648A < handle
    %E3648A Interface for Agilent E3648A Dual Output Power Supply
    %   0-8V, 5A  /  0-20V, 2.5A
    %   
    %   h = E3648A( RSC_ADDR )
    %
    %   Scott Stobbe 2016
    properties (SetAccess = protected, Transient = true)
        RSRC_ADDR
        vCom
        MFG
        PN
        SN
        FW_VER
        CAL_NOTE
        CAL_COUNT
    end
    
    properties (Dependent = true)% public 
        V1_SET 
        V1_STEP
        I1_SET
        I1_STEP
        V2_SET
        V2_STEP
        I2_SET
        I2_STEP
        V1_RANGE
        V2_RANGE
        OUTPUT
        OUTPUT_TRACK
        OVP1_LEVEL
        OVP1_ENABLE
        OVP1_TRIP
        OVP2_LEVEL
        OVP2_ENABLE
        OVP2_TRIP
        DISPLAY_ENABLED
        DISPLAY_MODE
        DISPLAY_TEXT
    end
    
    methods
        % E3648A Constructor
        function obj = E3648A( RADDR )

            
            if isempty(which( 'VISA32' ))
                error('VISA32 matlab wrapper not in MATLAB''s search path. ')
            end
            
            obj.vCom = VISA32();
            
            if nargin < 1
                RADDR = obj.vCom.FindModel('E3648A');
            end
            
            try
                obj.vCom.Open( RADDR );
                obj.RSRC_ADDR = RADDR;
            catch
                obj.vCom = [];
                error('Could Not Find Resource');
            end
            
            resp = obj.vCom.Query('*IDN?');
            
            IDNfields = regexp(deblank(resp), ',', 'split');
            obj.PN = IDNfields{2};
            obj.FW_VER = IDNfields{4};
            obj.MFG = IDNfields{1};
        end
        
        % E3648A Destructor
        %
        % Close comm channels
        function delete(obj)
            obj.vCom.Close();
        end 
        
        
        % V1_SET setter
        function obj = set.V1_SET(obj,val)
            obj.Intrument(1);
            
            if val < 8
                 obj.vCom.StrWrite('VOLT:RANG P8V');
            else
                 obj.vCom.StrWrite('VOLT:RANG P20V');
            end
            
            obj.vCom.StrWrite(['VOLT ' num2str(val, '%10.3e') ] );
        end
        
        % V1_SET getter
        function val = get.V1_SET(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('VOLT?');
            val = str2double(deblank(resp));
        end
        
        % V1_STEP setter
        function obj = set.V1_STEP(obj,val)
            obj.Intrument(1);
            obj.vCom.StrWrite(['VOLT:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % V1_STEP getter
        function val = get.V1_STEP(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('VOLT:STEP?');
            val = str2double(deblank(resp));
        end
        
        % I1_SET setter
        function obj = set.I1_SET(obj,val)
            obj.Intrument(1);
            obj.vCom.StrWrite(['CURR ' num2str(val, '%10.3e') ] );
        end
        
        % I1_SET getter
        function val = get.I1_SET(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('CURR?');
            val = str2double(deblank(resp));
        end
        
        % I1_STEP setter
        function obj = set.I1_STEP(obj,val)
            obj.Intrument(1);
            obj.vCom.StrWrite(['CURR:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % I1_STEP getter
        function val = get.I1_STEP(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('CURR:STEP?');
            val = str2double(deblank(resp));
        end
        
        
        % V2_SET setter
        function obj = set.V2_SET(obj,val)
            obj.Intrument(2);
            obj.vCom.StrWrite(['VOLT ' num2str(val, '%10.3e') ] );
        end
        
        % V2_SET getter
        function val = get.V2_SET(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT?');
            val = str2double(deblank(resp));
        end
        
        % V2_STEP setter
        function obj = set.V2_STEP(obj,val)
            obj.Intrument(2);
            obj.vCom.StrWrite(['VOLT:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % V2_STEP getter
        function val = get.V2_STEP(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:STEP?');
            val = str2double(deblank(resp));
        end
        
        
        % I2_SET setter
        function obj = set.I2_SET(obj,val)
            obj.Intrument(2);
            obj.vCom.StrWrite(['CURR ' num2str(val, '%10.3e') ] );
        end
        
        % I2_SET getter
        function val = get.I2_SET(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('CURR?');
            val = str2double(deblank(resp));
        end
        
        % I2_STEP setter
        function obj = set.I2_STEP(obj,val)
            obj.Intrument(2);
            obj.vCom.StrWrite(['CURR:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % I2_STEP getter
        function val = get.I2_STEP(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('CURR:STEP?');
            val = str2double(deblank(resp));
        end
        
        % V1_RANGE getter
        function val = get.V1_RANGE(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('VOLT:RANG?');
            val = (deblank(resp));
        end
        
        % V2_RANGE getter
        function val = get.V2_RANGE(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:RANG?');
            val = (deblank(resp));
        end
        
        % OUTPUT setter
        function obj = set.OUTPUT(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['OUTPUT ' rtxt{val+1} ] );
        end
        
        % OUTPUT getter
        function val = get.OUTPUT(obj)
            resp = obj.vCom.Query('OUTPUT?');
            val = str2double(deblank(resp));
        end
        
        % OUTPUT_TRACK setter
        function obj = set.OUTPUT_TRACK(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['OUTPUT:TRACK ' rtxt{val+1} ] );
        end
        
        % OUTPUT_TRACK getter
        function val = get.OUTPUT_TRACK(obj)
            resp = obj.vCom.Query('OUTPUT:TRACK?');
            val = str2double(deblank(resp));
        end
        
        % OVP1_LEVEL setter
        function obj = set.OVP1_LEVEL(obj,val)
            obj.Intrument(1);
            obj.vCom.StrWrite(['VOLT:PROT ' num2str(val, '%10.3e') ] );
        end
        
        % OVP1_LEVEL getter
        function val = get.OVP1_LEVEL(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('VOLT:PROT?');
            val = str2double(deblank(resp));
        end
        
        % OVP1_ENABLE setter
        function obj = set.OVP1_ENABLE(obj,val)
            obj.Intrument(1);
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['VOLT:PROT:STAT ' rtxt{val+1} ] );
        end
        
        % OVP1_ENABLE getter
        function val = get.OVP1_ENABLE(obj)
            obj.Intrument(1);
            resp = obj.vCom.Query('VOLT:PROT:STAT?');
            val = str2double(deblank(resp));
        end
        
        % OVP1_TRIP getter
        function val = get.OVP1_TRIP(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:PROT:TRIP?');
            val = str2double(deblank(resp));
        end
        
        % OVP2_LEVEL setter
        function obj = set.OVP2_LEVEL(obj,val)
            obj.Intrument(2);
            obj.vCom.StrWrite(['VOLT:PROT ' num2str(val, '%10.3e') ] );
        end
        
        % OVP2_LEVEL getter
        function val = get.OVP2_LEVEL(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:PROT?');
            val = str2double(deblank(resp));
        end
        
        % OVP2_ENABLE setter
        function obj = set.OVP2_ENABLE(obj,val)
            obj.Intrument(2);
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['VOLT:PROT:STAT ' rtxt{val+1} ] );
        end
        
        % OVP2_ENABLE getter
        function val = get.OVP2_ENABLE(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:PROT:STAT?');
            val = str2double(deblank(resp));
        end
        
        % OVP2_TRIP getter
        function val = get.OVP2_TRIP(obj)
            obj.Intrument(2);
            resp = obj.vCom.Query('VOLT:PROT:TRIP?');
            val = str2double(deblank(resp));
        end
        
        % DISPLAY_ENABLED setter
        function obj = set.DISPLAY_ENABLED(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['DISPLAY ' rtxt{val+1} ] );
        end
        
        % DISPLAY_ENABLED getter
        function val = get.DISPLAY_ENABLED(obj)
            resp = obj.vCom.Query('DISPLAY?');
            val = str2double(deblank(resp));
        end
        
        % DISPLAY_MODE setter
        function obj = set.DISPLAY_MODE(obj,val)
            if ~any(strcmpi(deblank(val),{'VI','VV','II'}))
                error('INVALID DISPLAY_MODE');
            end
            obj.vCom.StrWrite(['DISPLAY:MODE ' upper(deblank(val)) ] );
        end
        
        % DISPLAY_MODE getter
        function val = get.DISPLAY_MODE(obj)
            resp = obj.vCom.Query('DISPLAY:MODE?');
            val = (deblank(resp));
        end
        
        % DISPLAY_TEXT setter
        function obj = set.DISPLAY_TEXT(obj,val)
            
            obj.vCom.StrWrite(['DISPLAY:TEXT "' val '"' ] );
            if isempty(val)
                obj.vCom.StrWrite('DISPlAY:TEXT:CLEAR');
            end
                
        end
        
        % DISPLAY_MODE getter
        function val = get.DISPLAY_TEXT(obj)
            resp = obj.vCom.Query('DISPLAY:TEXT?');
            [t,~] = regexp(resp, '(")(.*?)\1', 'tokens', 'match');
            val = t{1}{2};
        end   
        
        function [ Imeas, Vmeas ] = Measure(obj,chn)
            
            if nargin < 2
                chn = 1;
            end
            obj.Intrument(chn);
            Vresp = obj.vCom.Query('MEAS:VOLT?');
            Vmeas = str2double(deblank(Vresp));
            Iresp = obj.vCom.Query('MEAS:CURR?');
            Imeas = str2double(deblank(Iresp));
            
        end
        
        %Beep
        function Beep(obj)
            obj.vCom.StrWrite('SYST:BEEP');
        end
        
        function OVPClear(obj)
            obj.Intrument(1);
            obj.vCom.StrWrite('VOLT:PROT:CLE');
            obj.Intrument(2);
            obj.vCom.StrWrite('VOLT:PROT:CLE');
        end
        
        function Intrument(obj,n)
             obj.vCom.StrWrite(['INSTrument:NSEL ' num2str(n) ] );
        end
        
        % CAL_NOTE getter
        function val = get.CAL_NOTE(obj)
            resp = obj.vCom.Query('CAL:STR?');
            val = (deblank(resp));
        end
        
        % CAL_COUNT getter
        function val = get.CAL_COUNT(obj)
            resp = obj.vCom.Query('CAL:COUN?');
            val = str2double(deblank(resp));
        end
    end
    
end

