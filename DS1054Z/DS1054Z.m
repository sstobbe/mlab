classdef DS1054Z < handle
    %DS1054Z Interface for Rigol DS1054Z Oscilloscope 
    %   
    %   h = DS1054Z( RSC_ADDR )
    %
    %   Scott Stobbe 2016
    
    properties (SetAccess = protected)
        RSRC_ADDR
        vCom
        MFG
        PN
        SN
        FW_VER
    end
    
    properties % public 
        CHAN1_BWL
        CHAN1_COUP
        CHAN1_DISP
        CHAN1_INV
        CHAN1_OFFS
        CHAN1_RANG
        CHAN1_TCAL
        CHAN1_SCAL
        CHAN1_PROB
        CHAN1_UNIT
        CHAN1_VERN
        CHAN2_BWL
        CHAN2_COUP
        CHAN2_DISP
        CHAN2_INV
        CHAN2_OFFS
        CHAN2_RANG
        CHAN2_TCAL
        CHAN2_SCAL
        CHAN2_PROB
        CHAN2_UNIT
        CHAN2_VERN
        CHAN3_BWL
        CHAN3_COUP
        CHAN3_DISP
        CHAN3_INV
        CHAN3_OFFS
        CHAN3_RANG
        CHAN3_TCAL
        CHAN3_SCAL
        CHAN3_PROB
        CHAN3_UNIT
        CHAN3_VERN
        CHAN4_BWL
        CHAN4_COUP
        CHAN4_DISP
        CHAN4_INV
        CHAN4_OFFS
        CHAN4_RANG
        CHAN4_TCAL
        CHAN4_SCAL
        CHAN4_PROB
        CHAN4_UNIT
        CHAN4_VERN
        DISP_TYPE
        DISP_PERS_TIME
        DISP_WAVE_BR
        DISP_GRID
        DISP_GRID_BR
        T_SCALE
        T_OFFSET
        T_MODE
        TRIG_HOLD_OFF
        TRIG_EDGE_CHN
        TRIG_EDGE_SLOPE
        TRIG_EDGE_LEVEL
    end
    
    methods
        % DS1054Z Constructor
        function obj = DS1054Z( RADDR )
            if nargin < 1
                RADDR = ''; % TODO add default addr
            end
            
            if isempty(which( 'VISA32' ))
                error('VISA32 matlab wrapper not in MATLAB''s search path. ')
            end
            
            obj.vCom = VISA32();
            
            try
                obj.vCom.Open( RADDR );
                obj.RSRC_ADDR = RADDR;
            catch
                obj.vCom = [];
                error('Could Not Find Resource');
            end
            
            obj.PN = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.MODEL_NAME)));
            obj.SN = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.USB_SERIAL_NUM)));
            obj.MFG = deblank(char(obj.vCom.GetAttribute(VISA_ATTRIBUTE.MANF_NAME)));
        end
        
        % DS1054Z Destructor
        %
        % Close comm channels
        function delete(obj)
            obj.vCom.Close();
        end 
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 1     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN1_BWL getter
        function val = get.CHAN1_BWL(obj)
            resp = obj.vCom.Query(':CHAN1:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN1_BWL setter
       function obj = set.CHAN1_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          obj.vCom.StrWrite([':CHAN1:BWL ' s ] );
       end
       
       
       % CHAN1_COUP getter
        function val = get.CHAN1_COUP(obj)
            resp = obj.vCom.Query(':CHAN1:COUP?');
            val = deblank(resp);
        end
        
        % CHAN1_COUP setter
        function obj = set.CHAN1_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            obj.vCom.StrWrite([':CHAN1:COUP ' deblank(val) ] );
        end
 
        % CHAN1_DISP getter
        function val = get.CHAN1_DISP(obj)
          resp = obj.vCom.Query(':CHAN1:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_DISP setter
        function obj = set.CHAN1_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN1:DISP ' cmd{val+1} ] );
        end
        
        % CHAN1_INV getter
        function val = get.CHAN1_INV(obj)
          resp = obj.vCom.Query(':CHAN1:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_INV setter
        function obj = set.CHAN1_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN1:INV ' cmd{val+1} ] );
        end
        
        % CHAN1_OFFS getter
        function val = get.CHAN1_OFFS(obj)
          resp = obj.vCom.Query(':CHAN1:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_OFFS setter
        function obj = set.CHAN1_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            obj.vCom.StrWrite([':CHAN1:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_RANG getter
        function val = get.CHAN1_RANG(obj)
          resp = obj.vCom.Query(':CHAN1:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_RANG setter
        function obj = set.CHAN1_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            obj.vCom.StrWrite([':CHAN1:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_TCAL getter
        function val = get.CHAN1_TCAL(obj)
          resp = obj.vCom.Query(':CHAN1:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_TCAL setter
        function obj = set.CHAN1_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            obj.vCom.StrWrite([':CHAN1:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_SCAL getter
        function val = get.CHAN1_SCAL(obj)
          resp = obj.vCom.Query(':CHAN1:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_SCAL setter
        function obj = set.CHAN1_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            obj.vCom.StrWrite([':CHAN1:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_PROB getter
        function val = get.CHAN1_PROB(obj)
          resp = obj.vCom.Query(':CHAN1:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN1_PROB setter
        function obj = set.CHAN1_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            obj.vCom.StrWrite([':CHAN1:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN1_UNIT getter
        function val = get.CHAN1_UNIT(obj)
          resp = obj.vCom.Query(':CHAN1:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN1_UNIT setter
        function obj = set.CHAN1_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            obj.vCom.StrWrite([':CHAN1:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN1_VERN getter
        function val = get.CHAN1_VERN(obj)
          resp = obj.vCom.Query(':CHAN1:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN1_VERN setter
        function obj = set.CHAN1_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN1:VERN ' cmd{val+1} ] );
 
        end
 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 1     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN2_BWL getter
        function val = get.CHAN2_BWL(obj)
            resp = obj.vCom.Query(':CHAN2:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN2_BWL setter
       function obj = set.CHAN2_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          obj.vCom.StrWrite([':CHAN2:BWL ' s ] );
       end
       
       
       % CHAN2_COUP getter
        function val = get.CHAN2_COUP(obj)
            resp = obj.vCom.Query(':CHAN2:COUP?');
            val = deblank(resp);
        end
        
        % CHAN2_COUP setter
        function obj = set.CHAN2_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            obj.vCom.StrWrite([':CHAN2:COUP ' deblank(val) ] );
        end
 
        % CHAN2_DISP getter
        function val = get.CHAN2_DISP(obj)
          resp = obj.vCom.Query(':CHAN2:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_DISP setter
        function obj = set.CHAN2_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN2:DISP ' cmd{val+1} ] );
        end
        
        % CHAN2_INV getter
        function val = get.CHAN2_INV(obj)
          resp = obj.vCom.Query(':CHAN2:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_INV setter
        function obj = set.CHAN2_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN2:INV ' cmd{val+1} ] );
        end
        
        % CHAN2_OFFS getter
        function val = get.CHAN2_OFFS(obj)
          resp = obj.vCom.Query(':CHAN2:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_OFFS setter
        function obj = set.CHAN2_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            obj.vCom.StrWrite([':CHAN2:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_RANG getter
        function val = get.CHAN2_RANG(obj)
          resp = obj.vCom.Query(':CHAN2:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_RANG setter
        function obj = set.CHAN2_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            obj.vCom.StrWrite([':CHAN2:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_TCAL getter
        function val = get.CHAN2_TCAL(obj)
          resp = obj.vCom.Query(':CHAN2:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_TCAL setter
        function obj = set.CHAN2_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            obj.vCom.StrWrite([':CHAN2:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_SCAL getter
        function val = get.CHAN2_SCAL(obj)
          resp = obj.vCom.Query(':CHAN2:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_SCAL setter
        function obj = set.CHAN2_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            obj.vCom.StrWrite([':CHAN2:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_PROB getter
        function val = get.CHAN2_PROB(obj)
          resp = obj.vCom.Query(':CHAN2:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN2_PROB setter
        function obj = set.CHAN2_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            obj.vCom.StrWrite([':CHAN2:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN2_UNIT getter
        function val = get.CHAN2_UNIT(obj)
          resp = obj.vCom.Query(':CHAN2:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN2_UNIT setter
        function obj = set.CHAN2_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            obj.vCom.StrWrite([':CHAN2:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN2_VERN getter
        function val = get.CHAN2_VERN(obj)
          resp = obj.vCom.Query(':CHAN2:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN2_VERN setter
        function obj = set.CHAN2_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN2:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 3     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % CHAN3_BWL getter
        function val = get.CHAN3_BWL(obj)
            resp = obj.vCom.Query(':CHAN3:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN3_BWL setter
       function obj = set.CHAN3_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          obj.vCom.StrWrite([':CHAN3:BWL ' s ] );
       end
       
       
       % CHAN3_COUP getter
        function val = get.CHAN3_COUP(obj)
            resp = obj.vCom.Query(':CHAN3:COUP?');
            val = deblank(resp);
        end
        
        % CHAN3_COUP setter
        function obj = set.CHAN3_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            obj.vCom.StrWrite([':CHAN3:COUP ' deblank(val) ] );
        end
 
        % CHAN3_DISP getter
        function val = get.CHAN3_DISP(obj)
          resp = obj.vCom.Query(':CHAN3:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_DISP setter
        function obj = set.CHAN3_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN3:DISP ' cmd{val+1} ] );
        end
        
        % CHAN3_INV getter
        function val = get.CHAN3_INV(obj)
          resp = obj.vCom.Query(':CHAN3:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_INV setter
        function obj = set.CHAN3_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN3:INV ' cmd{val+1} ] );
        end
        
        % CHAN3_OFFS getter
        function val = get.CHAN3_OFFS(obj)
          resp = obj.vCom.Query(':CHAN3:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_OFFS setter
        function obj = set.CHAN3_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            obj.vCom.StrWrite([':CHAN3:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_RANG getter
        function val = get.CHAN3_RANG(obj)
          resp = obj.vCom.Query(':CHAN3:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_RANG setter
        function obj = set.CHAN3_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            obj.vCom.StrWrite([':CHAN3:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_TCAL getter
        function val = get.CHAN3_TCAL(obj)
          resp = obj.vCom.Query(':CHAN3:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_TCAL setter
        function obj = set.CHAN3_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            obj.vCom.StrWrite([':CHAN3:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_SCAL getter
        function val = get.CHAN3_SCAL(obj)
          resp = obj.vCom.Query(':CHAN3:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_SCAL setter
        function obj = set.CHAN3_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            obj.vCom.StrWrite([':CHAN3:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_PROB getter
        function val = get.CHAN3_PROB(obj)
          resp = obj.vCom.Query(':CHAN3:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN3_PROB setter
        function obj = set.CHAN3_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            obj.vCom.StrWrite([':CHAN3:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN3_UNIT getter
        function val = get.CHAN3_UNIT(obj)
          resp = obj.vCom.Query(':CHAN3:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN3_UNIT setter
        function obj = set.CHAN3_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            obj.vCom.StrWrite([':CHAN3:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN3_VERN getter
        function val = get.CHAN3_VERN(obj)
          resp = obj.vCom.Query(':CHAN3:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN3_VERN setter
        function obj = set.CHAN3_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN3:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % CHANNEL 4     Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
        
        % CHAN4_BWL getter
        function val = get.CHAN4_BWL(obj)
            resp = obj.vCom.Query(':CHAN4:BWL?');
            val = logical(~strcmp(deblank(resp), 'OFF'));
        end
 
       % CHAN4_BWL setter
       function obj = set.CHAN4_BWL(obj,val)
          if logical(val) 
              s = '20M';
          else
              s = 'OFF';
          end
          obj.vCom.StrWrite([':CHAN4:BWL ' s ] );
       end
       
       
       % CHAN4_COUP getter
        function val = get.CHAN4_COUP(obj)
            resp = obj.vCom.Query(':CHAN4:COUP?');
            val = deblank(resp);
        end
        
        % CHAN4_COUP setter
        function obj = set.CHAN4_COUP(obj,val)
            if( ~any(strcmpi(deblank(val),{'AC','DC','GND'})) )
                error('INVALID COUPLING');
            end
            obj.vCom.StrWrite([':CHAN4:COUP ' deblank(val) ] );
        end
 
        % CHAN4_DISP getter
        function val = get.CHAN4_DISP(obj)
          resp = obj.vCom.Query(':CHAN4:DISP?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_DISP setter
        function obj = set.CHAN4_DISP(obj,val)
            if ~isscalar(val)
                error('INVALID DISP');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN4:DISP ' cmd{val+1} ] );
        end
        
        % CHAN4_INV getter
        function val = get.CHAN4_INV(obj)
          resp = obj.vCom.Query(':CHAN4:INV?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_INV setter
        function obj = set.CHAN4_INV(obj,val)
            if ~isscalar(val)
                error('INVALID INV');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN4:INV ' cmd{val+1} ] );
        end
        
        % CHAN4_OFFS getter
        function val = get.CHAN4_OFFS(obj)
          resp = obj.vCom.Query(':CHAN4:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_OFFS setter
        function obj = set.CHAN4_OFFS(obj,val)
            if ~isscalar(val)
                error('INVALID OFFS');
            end
            obj.vCom.StrWrite([':CHAN4:OFFS '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_RANG getter
        function val = get.CHAN4_RANG(obj)
          resp = obj.vCom.Query(':CHAN4:RANG?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_RANG setter
        function obj = set.CHAN4_RANG(obj,val)
            if ~isscalar(val)
                error('INVALID RANG');
            end
            obj.vCom.StrWrite([':CHAN4:RANG '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_TCAL getter
        function val = get.CHAN4_TCAL(obj)
          resp = obj.vCom.Query(':CHAN4:TCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_TCAL setter
        function obj = set.CHAN4_TCAL(obj,val)
            if ~isscalar(val)
                error('INVALID TCAL');
            end
            obj.vCom.StrWrite([':CHAN4:TCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_SCAL getter
        function val = get.CHAN4_SCAL(obj)
          resp = obj.vCom.Query(':CHAN4:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_SCAL setter
        function obj = set.CHAN4_SCAL(obj,val)
            if ~isscalar(val)
                error('INVALID SCAL');
            end
            obj.vCom.StrWrite([':CHAN4:SCAL '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_PROB getter
        function val = get.CHAN4_PROB(obj)
          resp = obj.vCom.Query(':CHAN4:PROB?');
          val = str2double(deblank(resp));
        end
        
        % CHAN4_PROB setter
        function obj = set.CHAN4_PROB(obj,val)
            if ~isscalar(val)
                error('INVALID PROB');
            end
            obj.vCom.StrWrite([':CHAN4:PROB '  num2str(val, '%10.3e')] );
        end
        
        % CHAN4_UNIT getter
        function val = get.CHAN4_UNIT(obj)
          resp = obj.vCom.Query(':CHAN4:UNIT?');
          val = deblank(resp);
        end
        
        % CHAN4_UNIT setter
        function obj = set.CHAN4_UNIT(obj,val)
            unitList = {'VOLT','VOLTAGE','WATT','AMP', 'AMPERE', 'UNKN', 'UNKNOWN'};
            
            if ~any(strcmpi(deblank(val),unitList))
                error('INVALID UNITS');
            end
            
            obj.vCom.StrWrite([':CHAN4:UNIT ' upper(deblank(val)) ] );
 
        end
        
        % CHAN4_VERN getter
        function val = get.CHAN4_VERN(obj)
          resp = obj.vCom.Query(':CHAN4:VERN?');
          val = any(strcmpi(deblank(resp), {'ON','1'}));
        end
        
        % CHAN4_VERN setter
        function obj = set.CHAN4_VERN(obj,val)
            if ~isscalar(val) || val < 0 || val > 1
                error('INVALID VERN');
            end
            cmd = { 'OFF', 'ON' };
            obj.vCom.StrWrite([':CHAN4:VERN ' cmd{val+1} ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Assorted      Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
          %% Display Commands
        %
        % Display Clear
        function [] = DispClear(obj)
            obj.vCom.StrWrite(':DISP:CLE');
        end
 
        function [val] = get.DISP_TYPE(obj)
          resp = obj.vCom.Query(':DISP:TYPE?');
          val = deblank(resp);
        end
        function [obj] = set.DISP_TYPE(obj,val)
            if ~any(strcmpi(deblank(val),{'VECT','VECTOR','DOTS'}))
                error('INVALID DISP_TYPE');
            end
            obj.vCom.StrWrite([':DISP:TYPE ' deblank(upper(val)) ] );
        end
        
        % DISP_PERS_TIME getter
        function val = get.DISP_PERS_TIME(obj)
          resp = obj.vCom.Query(':DISP:GRAD:TIME?');
          val = str2double(deblank(resp));
        end
        
        % DISP_PERS_TIME setter
        function obj = set.DISP_PERS_TIME(obj,val)
            if ~isscalar(val)
                error('INVALID DISP_PERS_TIME');
            end
            if val > 10
                cmd = 'INF';
            elseif val < 0.1
                cmd = 'MIN';
            else
                cmd = num2str(val);
            end
            obj.vCom.StrWrite([':DISP:GRAD:TIME ' cmd ] );
 
        end
        
        % DISP_WAVE_BR getter
        function val = get.DISP_WAVE_BR(obj)
          resp = obj.vCom.Query(':DISP:WBR?');
          val = str2double(deblank(resp));
        end
        
        % DISP_WAVE_BR setter
        function obj = set.DISP_WAVE_BR(obj,val)
            if ~isscalar(val) || val < 0 || val > 100 
                error('INVALID DISP_WAVE_BR');
            end
 
            cmd = num2str(round(val));
 
            obj.vCom.StrWrite([':DISP:WBR ' cmd ] );
 
        end
        
        % DISP_GRID getter
        function val = get.DISP_GRID(obj)
          resp = obj.vCom.Query(':DISP:GRID?');
          val = deblank(resp);
        end
        
        % DISP_GRID setter
        function obj = set.DISP_GRID(obj,val)
            if ~any(strcmpi(deblank(val),{'FULL','HALF','NONE'}))
                error('INVALID DISP_TYPE');
            end
            obj.vCom.StrWrite([':DISP:TYPE ' deblank(upper(val)) ] );
 
        end
        
        % DISP_GRID_BR getter
        function val = get.DISP_GRID_BR(obj)
          resp = obj.vCom.Query(':DISP:GBR?');
          val = str2double(deblank(resp));
        end
        
        % DISP_GRID_BR setter
        function obj = set.DISP_GRID_BR(obj,val)
            if ~isscalar(val) || val < 0 || val > 100
                error('INVALID DISP_GRID_BR');
            end
 
            cmd = num2str(round(val));
 
            obj.vCom.StrWrite([':DISP:GBR ' cmd ] );
 
        end
 
        % T_SCALE getter
        function val = get.T_SCALE(obj)
          resp = obj.vCom.Query(':TIM:SCAL?');
          val = str2double(deblank(resp));
        end
        
        % T_SCALE setter
        function obj = set.T_SCALE(obj,val)
            if ~isscalar(val) || val < 0
                error('INVALID T_SCALE');
            end
 
            cmd = num2str((val),'%10.3e');
 
            obj.vCom.StrWrite([':TIM:SCAL ' cmd ] );
 
        end
        
        % T_OFFSET getter
        function val = get.T_OFFSET(obj)
          resp = obj.vCom.Query(':TIM:OFFS?');
          val = str2double(deblank(resp));
        end
        
        % T_OFFSET setter
        function obj = set.T_OFFSET(obj,val)
            if ~isscalar(val)
                error('INVALID T_OFFSET');
            end
 
            cmd = num2str((val),'%10.3e');
 
            obj.vCom.StrWrite([':TIM:OFFS ' cmd ] );
        end
        
        % T_MODE getter
        function val = get.T_MODE(obj)
          resp = obj.vCom.Query(':TIM:MODE?');
          val = deblank(resp);
        end
        
        % T_MODE setter
        function obj = set.T_MODE(obj,val)
            if ~any(strcmpi(deblank(val),{'MAIN','XY','ROLL'})) 
                error('INVALID T_MODE');
            end
            obj.vCom.StrWrite([':TIM:MODE ' deblank(upper(val)) ] );
 
        end   
 
        % TRIG_EDGE_CHN getter
        function val = get.TRIG_EDGE_CHN(obj)
          resp = obj.vCom.Query(':TRIG:EDG:SOUR?');
          val = deblank(resp);
        end
        
        % TRIG_EDGE_CHN setter
        %
        % Can accept a char array or scalar between 1 and 4
        function obj = set.TRIG_EDGE_CHN(obj,val)
            if ( ~any(strcmpi(deblank(val),{'CHAN1','CHAN2','CHAN3','CHAN4','AC'})) ...
                    && ( prod(double(val<1)) || prod(double(val>4)) ) )
                
                error('INVALID TRIG_EDGE_CHN');
            end
            
            if isa(val,'char')
                cmd = val;
            else
                cmd =  [ 'CHAN' num2str(round(val),0) ];
            end
            
            obj.vCom.StrWrite([':TRIG:EDG:SOUR ' deblank(upper(cmd)) ] );
 
        end
        
        % TRIG_EDGE_SLOPE getter
        function val = get.TRIG_EDGE_SLOPE(obj)
          resp = obj.vCom.Query(':TRIG:EDG:SLOP?');
          val = deblank(resp);
        end
        
        % TRIG_EDGE_SLOPE setter
        function obj = set.TRIG_EDGE_SLOPE(obj,val)
            if ~any(strcmpi(deblank(val),{'POS','POSITIVE','NEG','NEGATIVE','RFALI'}))
                error('INVALID TRIG_EDGE_SLOPE');
            end
            
            obj.vCom.StrWrite([':TRIG:EDG:SLOP ' deblank(upper(val)) ] );
 
        end
        
        % TRIG_EDGE_LEVEL getter
        function val = get.TRIG_EDGE_LEVEL(obj)
          resp = obj.vCom.Query(':TRIG:EDG:LEV?');
          val = str2double(deblank(resp));
        end
        
        % TRIG_EDGE_LEVEL setter
        function obj = set.TRIG_EDGE_LEVEL(obj,val)
            if ~isscalar(val)
                error('INVALID TRIG_EDGE_LEVEL');
            end
            
            obj.vCom.StrWrite([':TRIG:EDG:LEV ' num2str(val, '%10.3e') ] );
 
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Functions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        % ScreenShot
        %   ColorInvert: logical, Invert RGB Colors (default: true)
        %
        %   Returns a 480x800x3 CData array 
        %
        %   With no return assignment; Draws screenshot to figure
        function [img] = ScreenShot(obj,ColorInvert)
            
            if nargin < 2
                ColorInvert = 1;
            end
            
            txHeader = 11;
            bitHeader = 54;
            pxBytes = 480*800*3;
            
            resp = obj.vCom.Query(':DISP:DATA?',  txHeader + bitHeader + pxBytes );
            
            % Hard coded pixel indexing for DS1054Z
            % +1 for matlab indexing style
            pxdat = resp((txHeader + bitHeader + 1):end);
            
            % Direct Indexing BMP Read ------------------------------------
            % Elapsed time is 0.151698 seconds.
            %             Bidx = 1:3:length(pxdat);
            %             Gidx = 2:3:length(pxdat);
            %             Ridx = 3:3:length(pxdat);
            %             
            %             Bidx = flipdim(reshape(Bidx,800,480)',1);
            %             Gidx = flipdim(reshape(Gidx,800,480)',1);
            %             Ridx = flipdim(reshape(Ridx,800,480)',1);
            %             
            %             B = pxdat(Bidx);
            %             G = pxdat(Gidx);
            %             R = pxdat(Ridx);
            %             
            %             img = [];
            %             img(:,:,1) = R./255;
            %             img(:,:,2) = G./255;
            %             img(:,:,3) = B./255;
            %  ------------------------------------------------------------
            
 
        
            %  --- Simple BMP Read ----------------------------------------
            % Elapsed time is 0.075029 seconds.
            B = pxdat(1:3:end);
            G = pxdat(2:3:end);
            R = pxdat(3:3:end);
            
            % create matlab CData image
            cimg = reshape([R' G' B']./255,800,480,3);
            
            img = imrotate(cimg,90);
            %  ------------------------------------------------------------
            
            if ColorInvert
                img = imcomplement(img);
            end
 
            if nargout == 0
                figure;
                imshow(img,'Border','tight');
                axis equal
                img = [];
            end
                
        end
        
        
        % WaveAquire
        %   CHNIdx: vector of channels to be acquired
        %       CHNIdx = [ 1 2 3 4 ] acquire all 4 channels return in order
        %
        %       CHNIdx = [ 3 1 ] acquire channels 1 and 3 return with
        %       channel 3 in first column and channel 1 in 2nd column
        %
        %   ScreenMemory: logical, acquire from screen data (<= 1200
        %   Samples) or form acquisition memory
        %
        %   
        function [wave,Fs,ts] = WaveAquire(obj, CHNIdx, ScreenMemory )
            
            if nargin < 3
                ScreenMemory = 0;
            end
            
            resp = obj.vCom.Query(':TRIG:STAT?');
            if strcmpi(deblank(resp), {'STOP'} )
                ReRun = 0;
            else
                obj.vCom.StrWrite(':STOP');
                ReRun = 1;
            end
            
            i = 0;
            resp = [];
            while ~strcmpi(deblank(resp), {'STOP'} )
                resp = obj.vCom.Query(':TRIG:STAT?');
                pause(0.01)
                i = i + 1;
            end
                
            if ScreenMemory
                obj.vCom.StrWrite(':WAV:MODE NORM');
            else
                obj.vCom.StrWrite(':WAV:MODE RAW');
            end
            
            resp = obj.vCom.Query(':WAV:PRE?');
            
            waveSettings =  regexp(deblank(resp), ',', 'split');
 
            Wav_XINC   = str2num(waveSettings{5}); %<xincrement>: the time difference between two neighbouring points in the X direction.
 
            T_LENGTH = 12*obj.T_SCALE;
 
            REC_POINTS = min( floor( T_LENGTH/Wav_XINC ), 12e6 );
 
            fs = 1/Wav_XINC;
            
            wave = zeros(REC_POINTS,length(CHNIdx));
            
            waveProp = zeros(10, length(CHNIdx));
 
            for j = 1:length(CHNIdx)
                CHN = CHNIdx(j);
                obj.vCom.StrWrite(sprintf(':WAV:SOUR CHAN%d', CHN));
                
                resp = obj.vCom.Query(':WAV:PRE?');
            
                waveSettings =  regexp(deblank(resp), ',', 'split');
                
                waveProp(:,j) = str2double(waveSettings)';
 
                % DS1054Z Does not like to read more than somewhere between 
                % 1 MSample to 250 kSamples at a time
                % Iterate reading up to 250 kSample memory blocks
                for i = 1:48
 
                    startidx = 1 + (i-1)*250E3;
                    stopidx = min( i*250E3, REC_POINTS );
 
                    obj.vCom.StrWrite(sprintf(':WAV:STAR %d', startidx));
 
 
                    obj.vCom.StrWrite(sprintf(':WAV:STOP %d', stopidx));
 
 
                    buf = obj.vCom.Query(':WAV:DATA?', 1000020);
 
                    len = stopidx - startidx;
                    
                    if length(buf) < len
                        error('Did not return data')
                    end
                    
                    wave(startidx:stopidx, j) = buf(12:12+len);
 
 
                    if( stopidx >= REC_POINTS )
                        break;
                    end
                end
 
            end
            
            if ReRun            
                obj.vCom.StrWrite(':RUN');
            end
            
            if nargout < 1
                    wave=[];
            else
                    for j = 1:length(CHNIdx)
                        CHN = CHNIdx(j);
                        wave(:,j) = (wave(:,j)-waveProp(10,j)-waveProp(9,j)).*waveProp(8,j);
                    end
                    Fs = fs;
                    ts = 0:1/fs:(REC_POINTS-1)/fs;
            end
            
        end
        
    end
    
end
