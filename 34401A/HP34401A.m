classdef HP34401A < handle
    %HP34401A Interface for HP 34401A Multimeter
    %   6 - 1/2 Digit DMM
    %   
    %   h = HP34401A( RSC_ADDR )
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
        DISPLAY_ENABLED
        DISPLAY_TEXT
    end
    
    methods
        % E3648A Constructor
        function obj = HP34401A( RADDR )
            if isempty(which( 'VISA32' ))
                error('VISA32 matlab wrapper not in MATLAB''s search path. ')
            end
            
            obj.vCom = VISA32();
            
            if nargin < 1
                RADDR = obj.vCom.FindModel('34401A');
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
        
        % DISPLAY_TEXT getter
        function val = get.DISPLAY_TEXT(obj)
            resp = obj.vCom.Query('DISPLAY:TEXT?');
            [t,~] = regexp(resp, '(")(.*?)\1', 'tokens', 'match');
            val = t{1}{2};
        end   
        
        function [ meas ] = Measure(obj)
            Vresp = obj.vCom.Query('READ?');
            meas = str2double(deblank(Vresp));
        end
        
        %Beep
        function Beep(obj)
            obj.vCom.StrWrite('SYST:BEEP');
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

