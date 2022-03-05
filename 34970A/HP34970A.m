classdef HP34970A < handle
    %HP34970A Interface for HP HP34970A Scanner/Multimeter
    %   6 - 1/2 Digit DMM
    %   
    %   h = HP34970A( RSC_ADDR )
    %
    %   Scott Stobbe 2017
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
        SLOT_1_ID
        SLOT_2_ID
        SLOT_3_ID
        SLOT_1_CHAN_COUNT
        SLOT_2_CHAN_COUNT
        SLOT_3_CHAN_COUNT
        SLOT_1_STATUS
        SLOT_2_STATUS        
        SLOT_3_STATUS
        SCAN_LIST
        SCAN_ACTIVE
        MONITOR_CHAN
        MONITOR_EN
        MONITOR_CONFIG
        MONITOR_FUNC
        MONITOR_RANGE
        MONITOR_RES
        MONITOR_VAL
        NPLC
        INPUT_IMPEDANCE
        TEMP_UNIT
        TEMP_TRANSDUCER
        FORMAT_TIMESTAMP
        TIMESTAMP_EN 
        FORMAT_UNITS
        FORMAT_ALARM
        FORMAT_CHAN
        TRIG_SOURCE
        TRIG_TIME
        TRIG_COUNT
        MEM_START_DATE
        MEM_COUNT
    end
    
    methods
        % 34970A Constructor
        function obj = HP34970A( RADDR )
            if isempty(which( 'VISA32' ))
                error('VISA32 matlab wrapper not in MATLAB''s search path. ')
            end
            
            obj.vCom = VISA32();
            
            if nargin < 1
                RADDR = obj.vCom.FindModel('34970A');
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
        
        % 34970A Destructor
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
            meas = str2double(deblank(Vresp(1:16)));
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
        %SCAN_LIST setter
        function obj = set.SCAN_LIST(obj,val)
            slist  = int32(val(:));
            
            if ~isempty(slist) 
                sliststr = sprintf('%i,',slist');
                sliststr = sliststr(1:end-1);

                obj.vCom.StrWrite(['ROUT:SCAN (@' sliststr ')' ] );
            end
        end
        % SCAN_LIST getter
        function val = get.SCAN_LIST(obj)
            resp = obj.vCom.Query('ROUT:SCAN?');
            [t,~] = regexp(resp, '[0-9]+', 'match');
            slist = str2num(char(t));
            if length(slist) > 1
                val = slist(2:end); 
            else
                val = [];
            end
        end
        
        
        %MONITOR_CHAN setter
        function obj = set.MONITOR_CHAN(obj,val)
            slist  = int32(val(:));
            
            if ~isempty(slist) 
                obj.vCom.StrWrite(['ROUT:MON (@' num2str(slist(1)) ')' ] );
            end
            obj.SCAN_LIST = slist;
        end
        % MONITOR_CHAN getter
        function val = get.MONITOR_CHAN(obj)
            resp = obj.vCom.Query('ROUT:MON?');
            [t,~] = regexp(resp, '[0-9]+', 'match');
            slist = str2num(char(t));
            if length(slist) > 1
                val = slist(2); 
            else
                val = [];
            end
        end
        %MONITOR_EN setter
        function obj = set.MONITOR_EN(obj,val)
            idx  = logical(val)+1;
            
            txt = { 'OFF', 'ON' };
            
            obj.vCom.StrWrite(['ROUT:MON:STAT ' txt{idx} ] );
            
        end
        % MONITOR_EN getter
        function val = get.MONITOR_EN(obj)
            resp = obj.vCom.Query('ROUT:MON:STAT?');
            val = logical(str2double(deblank(resp)));
        end
        
        %MONITOR_CONFIG
        function val = get.MONITOR_CONFIG(obj)
            resp = obj.vCom.Query(sprintf('CONF? (@%d)',obj.MONITOR_CHAN));
            resp(resp == '"') = ' ';
            val = strtrim(resp);
        end
        
        % TEMP_TRANSDUCER getter
        function val = get.TEMP_TRANSDUCER(obj)
            if strcmpi('TEMP',obj.MONITOR_FUNC)
                transducer = deblank(obj.vCom.Query('TEMP:TRAN:TYPE?'));
                if ~isempty(transducer)
                    resp = deblank(obj.vCom.Query(['TEMP:TRAN:' transducer ':TYPE?']));
                    val = [ transducer ' ' resp ];
                end
            else
                val = '';
            end
        end
                
        %TIMESTAMP_FORMAT setter
        function obj = set.FORMAT_TIMESTAMP(obj,val)
                        
            txt = { 'ABS', 'REL' };
            
            idx  = find(strcmpi(val,txt));
            if ~isempty(idx) 
                obj.vCom.StrWrite(['FORM:READ:TIME:TYPE ' txt{idx} ] );
            end
            
        end
        % TIMESTAMP_FORMAT getter
        function val = get.FORMAT_TIMESTAMP(obj)
            resp = obj.vCom.Query('FORM:READ:TIME:TYPE?');
            val = deblank(resp);
        end
        
        %TIMESTAMP_EN setter
        function obj = set.TIMESTAMP_EN(obj,val)
            idx  = logical(val)+1;
            
            txt = { 'OFF', 'ON' };
            
            obj.vCom.StrWrite(['FORM:READ:TIME ' txt{idx} ] );
            
        end
        % TIMESTAMP_EN getter
        function val = get.TIMESTAMP_EN(obj)
            resp = obj.vCom.Query('FORM:READ:TIME?');
            val = logical(str2double(deblank(resp)));
        end
        
        % SLOT_1_ID getter
        function val = get.SLOT_1_ID(obj)
            resp = obj.vCom.Query('SYST:CTYP? 100');
            val = deblank(resp);
        end
        % SLOT_2_ID getter
        function val = get.SLOT_2_ID(obj)
            resp = obj.vCom.Query('SYST:CTYP? 200');
            val = deblank(resp);
        end
        % SLOT_3_ID getter
        function val = get.SLOT_3_ID(obj)
            resp = obj.vCom.Query('SYST:CTYP? 300');
            val = deblank(resp);
        end
        % SLOT_1_STATUS getter
        function val = get.SLOT_1_STATUS(obj)
            n = 101;
            m = n + obj.SLOT_1_CHAN_COUNT - 1;
            
            if m > n
                resp = obj.vCom.Query(sprintf('ROUT:CLOS? (@%d:%d)',n,m));
                d = textscan(deblank(resp),'%d,');
                val = logical(d{1});
            else
               val = []; 
            end
           
        end
        % SLOT_2_STATUS getter
        function val = get.SLOT_2_STATUS(obj)
            n = 201;
            m = n + obj.SLOT_2_CHAN_COUNT - 1;
            
            if m > n
                resp = obj.vCom.Query(sprintf('ROUT:CLOS? (@%d:%d)',n,m));
                d = textscan(deblank(resp),'%d,');
                val = logical(d{1});
            else
               val = []; 
            end
           
        end
        % SLOT_3_STATUS getter
        function val = get.SLOT_3_STATUS(obj)
            n = 301;
            m = n + obj.SLOT_3_CHAN_COUNT - 1;
            
            if m > n
                resp = obj.vCom.Query(sprintf('ROUT:CLOS? (@%d:%d)',n,m));
                d = textscan(deblank(resp),'%d,');
                val = logical(d{1});
            else
               val = []; 
            end
           
        end
        
        function val = ChannelsInCard(obj,card)
            clist = { '34901A', '34902A', '34903A', '34904A' };
            count = [ 22, 16, 20, 32 ];
            
            idx =  find(strcmpi(card,clist));
            if ~isempty(idx)
                val = count(idx);
            else
                val = 0;
            end
        end
        % SLOT_1_CHAN_COUNT getter
        function val = get.SLOT_1_CHAN_COUNT(obj)
            tok = regexp(obj.SLOT_1_ID, ',', 'split');
            val = obj.ChannelsInCard(tok{2});
        end
        % SLOT_2_CHAN_COUNT getter
        function val = get.SLOT_2_CHAN_COUNT(obj)
            tok = regexp(obj.SLOT_2_ID, ',', 'split');
            val = obj.ChannelsInCard(tok{2});
        end
        % SLOT_3_CHAN_COUNT getter
        function val = get.SLOT_3_CHAN_COUNT(obj)
            tok = regexp(obj.SLOT_3_ID, ',', 'split');
            val = obj.ChannelsInCard(tok{2});
        end
        % MEM_START_DATE getter
        function val = get.MEM_START_DATE(obj)
            resp = obj.vCom.Query('SYSTem:TIME:SCAN?');
            val = datestr(datenum(resp,'yyyy,mm,dd,hh,MM,ss'));
        end
        % MEM_COUNT getter
        function val = get.MEM_COUNT(obj)
            resp = obj.vCom.Query('DATA:POIN?');
            val = str2double(deblank(resp));
        end
        % SCAN_ACTIVE getter
        function val = get.SCAN_ACTIVE(obj)
            resp = obj.vCom.Query('STAT:OPER:COND?');
            reg = str2double(deblank(resp));
            val = logical(bitand(16,reg));
        end
        
        % Scan
        function val = Run(obj)
            obj.vCom.StrWrite('INIT');
        end
        
        % Stop Scan
        function val = Stop(obj)
            obj.vCom.StrWrite('ABOR');
        end
        
        function [ val, time ] = ReadScan(obj)
            val = nan(obj.MEM_COUNT,1);
            time = nan(obj.MEM_COUNT,1);
            
            for i = 1:length(val)
                resp = obj.vCom.Query('R? 1');
                d = textscan(deblank(resp(5:end)),'%f,');
                val(i) = d{1}(1);
                time(i) = d{1}(2);
            end
        end
        
        function [ valo, timeo ] = AppendScan(obj,vali,timei)
            val = nan(obj.MEM_COUNT,1);
            time = nan(obj.MEM_COUNT,1);
            
            for i = 1:10:length(val)
                resp = obj.vCom.Query('R? 10');
                idx = 3 + int32(resp(2))-48;
                d = textscan(resp(idx:end),'%f,');
                len = length(d{1})/2;
                dat = reshape(d{1},2,len)';
                
                val(i:i+len-1) = dat(:,1);
                time(i:i+len-1) = dat(:,2);
            end
            
            valo = [ vali; val ];
            timeo = [ timei; time ];
        end
        
        
        %TRIG_SOURCE setter
        function obj = set.TRIG_SOURCE(obj,val)
            txt = { 'BUS', 'IMM', 'EXT', 'TIM' };
            idx  = find(strcmpi(val,txt));
            
            if ~isempty(idx)
                obj.vCom.StrWrite(['TRIG:SOUR ' txt{idx} ] );
            end
            
        end
        % TRIG_SOURCE getter
        function val = get.TRIG_SOURCE(obj)
            resp = obj.vCom.Query('TRIG:SOUR?');
            val = deblank(resp);
        end
        %TRIG_TIME setter
        function obj = set.TRIG_TIME(obj,val)
            obj.vCom.StrWrite(['TRIG:TIM ' num2str(val) ] );
        end
        % TRIG_TIME getter
        function val = get.TRIG_TIME(obj)
            resp = obj.vCom.Query('TRIG:TIM?');
            val = str2double(deblank(resp));
        end
        %TRIG_COUNT setter
        function obj = set.TRIG_COUNT(obj,val)
            
            if isnumeric(val)
                if val(1) > 50000
                    warning('Trig Count Too Large!');
                    val = 50e3;
                end
                obj.vCom.StrWrite(['TRIG:COUN ' num2str(val(1)) ] );
                
            else
                txt = { 'MIN', 'MAX', 'INF' };
                idx = find(strcmpi(val,txt));
                if ~isempty(idx)
                    obj.vCom.StrWrite(['TRIG:COUN ' txt{idx} ] );
                end
            end
            
            
        end
        % TRIG_COUNT getter
        function val = get.TRIG_COUNT(obj)
            resp = obj.vCom.Query('TRIG:COUN?');
            val = str2double(deblank(resp));
        end
        
        
        % MONITOR_VAL getter
        function val = get.MONITOR_VAL(obj)
            resp = obj.vCom.Query('ROUT:MON:DATA?');
            val = str2double(deblank(resp));
        end
                
        
        
        % MONITOR_FUNC getter
        function val = get.MONITOR_FUNC(obj)
            tok = regexp(obj.MONITOR_CONFIG, '[,]|[ ]', 'split');
            val = tok{1};
        end
        % MONITOR_RANGE getter
        function val = get.MONITOR_RANGE(obj)
            tok = regexp(obj.MONITOR_CONFIG, '[,]|[ ]', 'split');
            val = str2double(tok{end-1});
        end
        % MONITOR_RES getter
        function val = get.MONITOR_RES(obj)
            tok = regexp(obj.MONITOR_CONFIG, '[,]|[ ]', 'split');
            val = str2double(tok{end});
        end
        
        function [] = ClockSync(obj)
            obj.vCom.StrWrite(['SYST:DATE ' datestr(now, 'yyyy,mm,dd')]);
            obj.vCom.StrWrite(['SYST:TIME ' datestr(now, 'HH,MM,ss')]);
        end
        
        %INPUT_IMPEDANCE setter
        function obj = set.INPUT_IMPEDANCE(obj,val)
            if strcmpi('VOLT', obj.MONITOR_FUNC) && obj.MONITOR_RANGE <= 10
                idx = isempty(strfind(val,'10'))+1;
                txt = { 'OFF', 'ON' };
                obj.vCom.StrWrite(sprintf('INP:IMP:AUTO %s, (@%d)',txt{idx},obj.MONITOR_CHAN));
            end
        end
        % INPUT_IMPEDANCE getter
        function val = get.INPUT_IMPEDANCE(obj)
            if any(strcmpi(obj.MONITOR_FUNC,{'VOLT','VOLT:AC'}))
                resp = obj.vCom.Query(sprintf('INP:IMP:AUTO? (@%d)',obj.MONITOR_CHAN));
                idx = logical(str2double(deblank(resp)))+1;
                txt = { '10Meg', 'Hi-Z' };
                val = txt{idx};
            elseif strcmpi(obj.MONITOR_FUNC,'CURR')
                if obj.MONITOR_RANGE < 1
                    val = '5 Ohms';
                else
                    val = '100 mOhms';
                end
            end
        end
        %NPLC setter
        function obj = set.NPLC(obj,val)
            if strcmpi('VOLT', obj.MONITOR_FUNC) && obj.MONITOR_RANGE <= 10
                idx = isempty(strfind(val,'10'))+1;
                txt = { 'OFF', 'ON' };
                obj.vCom.StrWrite(sprintf('INP:IMP:AUTO %s, (@%d)',txt{idx},obj.MONITOR_CHAN));
            end
        end
        % NPLC getter
        function val = get.NPLC(obj)
            if any(strcmpi(obj.MONITOR_FUNC,{'VOLT', 'VOLT:AC','CURR','CURR:AC','RES','TEMP'}))
                
                if any(strcmpi(obj.MONITOR_FUNC,{'VOLT','CURR'}))
                    func = [obj.MONITOR_FUNC ':DC'];
                else
                    func = obj.MONITOR_FUNC;
                end
                resp = obj.vCom.Query(sprintf('%s:NPLC? (@%d)',func,obj.MONITOR_CHAN));
                val = str2double(resp);
            end
        end
    end
    
end

