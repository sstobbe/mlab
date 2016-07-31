classdef E3634A < handle
    %E3634A Interface for Agilent E3648A Single Output Power Supply
    %   0-25V, 7A  /  0-50V, 4A
    %   
    %   h = E3634A( RSC_ADDR )
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
        V_SET 
        V_STEP
        I_SET
        I_STEP
        V_RANGE
        OUTPUT
        OVP_LEVEL
        OVP_ENABLE
        OVP_TRIP
        OCP_LEVEL
        OCP_ENABLE
        OCP_TRIP
        DISPLAY_ENABLED
        DISPLAY_TEXT
    end
    
    methods
        % E3648A Constructor
        function obj = E3634A( RADDR )
            if isempty(which( 'VISA32' ))
                error('VISA32 matlab wrapper not in MATLAB''s search path. ')
            end
            
            obj.vCom = VISA32();
            
            if nargin < 1
                RADDR = obj.vCom.FindModel('E3634A');
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
        
        
        % V_SET setter
        function obj = set.V_SET(obj,val)      
            if val < 25
                 obj.vCom.StrWrite('VOLT:RANG P25V');
            else
                 obj.vCom.StrWrite('VOLT:RANG P50V');
            end
            
            obj.vCom.StrWrite(['VOLT ' num2str(val, '%10.3e') ] );
        end
        
        % V_SET getter
        function val = get.V_SET(obj)
            resp = obj.vCom.Query('VOLT?');
            val = str2double(deblank(resp));
        end
        
        % V_STEP setter
        function obj = set.V_STEP(obj,val)
            obj.vCom.StrWrite(['VOLT:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % V_STEP getter
        function val = get.V_STEP(obj)
            resp = obj.vCom.Query('VOLT:STEP?');
            val = str2double(deblank(resp));
        end
        
        % I_SET setter
        function obj = set.I_SET(obj,val)
            obj.vCom.StrWrite(['CURR ' num2str(val, '%10.3e') ] );
        end
        
        % I_SET getter
        function val = get.I_SET(obj)
            resp = obj.vCom.Query('CURR?');
            val = str2double(deblank(resp));
        end
        
        % I_STEP setter
        function obj = set.I_STEP(obj,val)
            obj.vCom.StrWrite(['CURR:STEP ' num2str(val, '%10.3e') ] );
        end
        
        % I_STEP getter
        function val = get.I_STEP(obj)
            resp = obj.vCom.Query('CURR:STEP?');
            val = str2double(deblank(resp));
        end
        
            
        % V_RANGE getter
        function val = get.V_RANGE(obj)
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
        
        % OVP_LEVEL setter
        function obj = set.OVP_LEVEL(obj,val)
            obj.vCom.StrWrite(['VOLT:PROT ' num2str(val, '%10.3e') ] );
        end
        
        % OVP_LEVEL getter
        function val = get.OVP_LEVEL(obj)
            resp = obj.vCom.Query('VOLT:PROT?');
            val = str2double(deblank(resp));
        end
        
        % OVP_ENABLE setter
        function obj = set.OVP_ENABLE(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['VOLT:PROT:STAT ' rtxt{val+1} ] );
        end
        
        % OVP_ENABLE getter
        function val = get.OVP_ENABLE(obj)
            resp = obj.vCom.Query('VOLT:PROT:STAT?');
            val = str2double(deblank(resp));
        end
        
        % OVP_TRIP getter
        function val = get.OVP_TRIP(obj)
            resp = obj.vCom.Query('VOLT:PROT:TRIP?');
            val = str2double(deblank(resp));
        end
        
        % OCP_LEVEL setter
        function obj = set.OCP_LEVEL(obj,val)
            obj.vCom.StrWrite(['CURR:PROT ' num2str(val, '%10.3e') ] );
        end
        
        % OCP_LEVEL getter
        function val = get.OCP_LEVEL(obj)
            resp = obj.vCom.Query('CURR:PROT?');
            val = str2double(deblank(resp));
        end
        
        % OCP_ENABLE setter
        function obj = set.OCP_ENABLE(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['CURR:PROT:STAT ' rtxt{val+1} ] );
        end
        
        % OCP_ENABLE getter
        function val = get.OCP_ENABLE(obj)
            resp = obj.vCom.Query('CURR:PROT:STAT?');
            val = str2double(deblank(resp));
        end
        
        % OCP_TRIP getter
        function val = get.OCP_TRIP(obj)
            resp = obj.vCom.Query('CURR:PROT:TRIP?');
            val = str2double(deblank(resp));
        end
        
        % OCP_TRIP setter
        function obj = set.OCP_TRIP(obj,val)
            rtxt = { 'OFF', 'ON' };
            obj.vCom.StrWrite(['DISPLAY ' rtxt{val+1} ] );
        end
        
        % DISPLAY_ENABLED getter
        function val = get.DISPLAY_ENABLED(obj)
            resp = obj.vCom.Query('DISPLAY?');
            val = str2double(deblank(resp));
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
        
        function [ Imeas, Vmeas ] = Measure(obj)
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
            obj.vCom.StrWrite('VOLT:PROT:CLE');
        end
        
        function OCPClear(obj)
            obj.vCom.StrWrite('CURR:PROT:CLE');
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

