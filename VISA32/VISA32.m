classdef VISA32 < handle
    %VISA32 Wrapper of National Instruments VISA interface
    %   
    %   The National Instruments VISA API provides an instrument interface
    %   agnostic of the employed interface bus (Ethernet, GPIB, USB
    %   GPIB-VXI, VXI, PXI, Serial, etc ).
    %
    %   The VISA32 Class on construction establishes a session with the 
    %   VISA resource manager. 
    %
    %   Following construction, an instrument session can be opened with
    %   a unique resource address such as:
    %       'GPIB0::1::INSTR'
    %       'USB0::0x1AB1::0x04CE::XXX::INSTR'
    %       'TCPIP0::1.2.3.4::999::SOCKET'
    %
    %   At present, only synchronous message based instrument communication 
    %   is implemented in the VISA32 matlab class wrapper.
    %
    %   Also serves as a base class for instrument interfaces.
    %
    %   Example:
    %       h = VISA32();
    %
    %       h.Open('GPIB0::1::INSTR');
    %
    %       id = h.Query('*IDN?')
    %
    %           id = HEWLETT-PACKARD,34401A,0,9-5-2
    %
    %       ms = h.Query('MEAS?')
    %       
    %   Note query is returned as a char array and must be parsed to a
    %   floating point type.
    %
    %           ms = -4.03000000E-07
    %
    %       val = str2double(ms);
    %   
    %   Scott Stobbe
    %
    %   VER 1.0
    
    properties ( SetAccess = private )
        defaultRM = []
        instrument = []
        RSRC_ADDR = []
        findList = []
    end
    
    methods
        % Visa32 Constructor
        %
        % Check if Visa32 dll is loaded if not load
        % 
        % Request comm channel 
        function obj = VISA32(RSRC_ADDR)
            if ( ~libisloaded('visa32') )
                loadlibrary 'C:\WINDOWS\system32\visa32.dll' ...
                    'C:\Program Files (x86)\IVI Foundation\VISA\WinNT\Include\visa.h' ...
                    alias visa32;
            end

            [status, dRM] = calllib('visa32', 'viOpenDefaultRM', 0 );
            obj.RetCodeCheck(status);
            obj.defaultRM = dRM;
            
            if nargin == 1
                obj.Open(RSRC_ADDR);
            end
        end
        
        % Visa32 Destructor
        %
        % Close comm channels
        function delete(obj)
            obj.Close();
            if ~isempty(obj.defaultRM)
                [status] = calllib('visa32', 'viClose', obj.defaultRM);
                obj.RetCodeCheck(status);
                obj.defaultRM = [];
            end
        end 
        
        % VISA32 Open Instrument Connection
        %
        %
        function [] = Open( obj, RSRC_ADDR )
            
            if( isa(RSRC_ADDR, 'char') )
                RSRC_ADDR_INT8 = [ int8(RSRC_ADDR) 0 ]; % char to cstring
            elseif( isa(RSRC_ADDR, 'int8') )
                RSRC_ADDR_INT8 = RSRC_ADDR;
            else
                error( 'Unknow Resource Address Type' );
            end
            
            [status,~,instr] = calllib('visa32', 'viOpen', obj.defaultRM, ...
                RSRC_ADDR_INT8 ,0 , 0, 0);
            obj.RetCodeCheck(status);
            obj.instrument = instr;
            
            % Set Timeout to 5 Seconds as a default
            obj.SetAttribute(VISA_ATTRIBUTE.TMO_VALUE, 5000 );
            
            obj.RSRC_ADDR = RSRC_ADDR;
            
        end
        
        % VISA32 Close Instrument Connection
        %
        %
        function [] = Close( obj )
            if ~isempty(obj.instrument)
                [status] = calllib('visa32', 'viClose', obj.instrument);
                if status ~= 0; warning( 'viClose' ); end
                obj.instrument = [];
            end
            
            obj.RSRC_ADDR = [];
        end
        
        % VISA32 SetAttribute
        %   attr (int32) 
        %   val  (int32)
        function [] = SetAttribute(obj, attr, val )
            
            switch class(attr)
                case 'int32'
                    attr_parse = attr;
                case 'char'
                    warning('parsing as hex string');
                    attr_parse = hex2dec(attr);
                case 'VISA_ATTRIBUTE'
                    attr_parse = uint32(attr);
                otherwise
                    attr_parse = uint32(attr);
                    warning( 'SetAttribute attr be a int32, char, or VISA_ATTRIBUTE');
            end 
            
            if ~isscalar(val)
                error('SetAttribute val must be scalar');
            end

            if ~isinteger(val)
                orgClass = class(val);
                
                % default type in matlab is double, test if val is 
                % approximately integer
                %
                % eps( double(2^31) ) = 4.7684e-007
                % eps( single(2^31) ) = 256
                %
                % Error on singles, as the mantissa is only 23 bits.
                %   Note: Could test for eps(val) < 1/2 for singles but...
                % 
                if val ~= cast( int32(val), orgClass ) || ~isa(val, 'double')
                    error('SetAttribute val must be int32')
                end
            end
                    
            [status] = calllib('visa32', 'viSetAttribute', obj.instrument, ...
                attr_parse, val);
            
            obj.RetCodeCheck(status);
        end
        
        
        % VISA32 SetAttribute
        %   attr (int32) 
        %   val  (int32)
        function [val] = GetAttribute(obj, attr, bufSize )
            
            if nargin < 3
                bufSize = 100;
            end
            
            switch class(attr)
                case 'uint32'
                    attr_parse = attr;
                case 'char'
                    warning('parsing as hex string');
                    attr_parse = hex2dec(attr);
                case 'VISA_ATTRIBUTE'
                    attr_parse = uint32(attr);
                otherwise
                    attr_parse = uint32(attr);
            end
            
            px = libpointer( 'int8Ptr', zeros(1,bufSize));
            
            [status, ~] = calllib('visa32', 'viGetAttribute', obj.instrument, ...
                attr_parse, px);
            
            val = get(px,'Value');
            
            obj.RetCodeCheck(status);
        end
        
        % VISA32 Read
        %   attr (int32) 
        %   val  (int32)
        function [buf] = Read(obj, maxBytes )
            retCount = 0;
            buf = zeros(1,maxBytes);
            [status, buf, retCount ] = calllib('visa32', 'viRead', ...
                obj.instrument, buf, maxBytes, retCount);
            
            obj.RetCodeCheck(status);
            
            buf = buf(1:retCount);
        end
        
        % VISA32 Write
        % 
        %  
        function [] = Write(obj, wrdat, binary )
            
            if nargin < 3
                binary = true;
            end
            
            n = length(wrdat);
            
            switch class(wrdat)
                case 'int8'
                    wrdat = wrdat;
                    
                    if ~binary
                        n = n - 1; % format is assumed cstring
                    end
                    
                case 'char'
                    wrdat = [ int8(wrdat) 0 ]; % convert to cstring
                    
                otherwise
                    error('Not native type of VISA API or char array')
            end
            
            retCount = 0;
            [status, ~, ~ ] = calllib('visa32', 'viWrite', ...
                obj.instrument, wrdat, n, retCount);
            
            obj.RetCodeCheck(status);
        end
        
        
        % VISA32 Query
        % 
        %  
        function [Resp] = Query(obj, Req, maxBytes )
            
            if nargin < 3
                maxBytes = 1000;
            end
            retInChar = false;
            
            switch class(Req)
                case 'int8'
                    Req = Req;
                case 'char'
                    retInChar = true;
                    if( Req(end) ~= 10 )
                        Req(end+1) = 10; % append new line char
                    end
            end
            
            obj.Write(Req);
            Resp = obj.Read(maxBytes);
            
            if retInChar 
                Resp = char(Resp);
            end
        end
        
        % VISA32 StrWrite
        % 
        % if string is cstring style in int8 type do nothing
        % otherwise ensure string ends with new line
        function [] = StrWrite(obj, wrdat )
            switch class(wrdat)
                case 'int8'
                    wrdat = wrdat;
                case 'char'
                    % Conversion to c string happens in write, preserve 
                    % char array type
                    if( wrdat(end) ~= 10 )
                        wrdat(end+1) = 10; % append new line char
                    end
            end
            
            
            obj.Write(wrdat);
        end
        
        
        % VISA32 RetCodeCheck
        %   retcode (int32) 
        %
        %   checks return code against an error dictionary
        function [] = RetCodeCheck(obj, retcode) 
            if int32(retcode) ~= 0
                try 
                    rc = VISA_RETCODE(retcode);      
                catch ME
                    disp(ME)
                    error( 'Unknown Error :(' ); 
                end
                
                if( int32(retcode) > 0 )
                    disp( ['Success: Return Code: ' char(rc) ] )
                else
                    error( ['ERROR: Return Code: ' char(rc) ] )
                end
            end
        end
        
        % VISA32 FindRsrc
        %
        %
        function [RsrcStr, rtnCnt, fList ] = FindRsrc(obj, expr) 
            
            n = length(expr);
            
            switch class(expr)
                case 'int8'
                    expr = expr;
                    
                    if ~binary
                        n = n - 1; % format is assumed cstring
                    end
                    
                case 'char'
                    expr = [ int8(expr) 0 ]; % convert to cstring
                    
                otherwise
                    error('Not native type of VISA API or char array')
            end

            px = int8(zeros(1,256));
            rtnCnt = 0;
            fList = 0;
            
            [status, ~, fList, rtnCnt, RsrcStr ] = calllib('visa32', 'viFindRsrc', obj.defaultRM, ...
                expr, fList, rtnCnt, px);
            
            obj.findList = fList;
            
            RsrcStr = deblank(char(RsrcStr));
            
        end
        
        % VISA32 FindRsrc
        %
        %
        function [ RsrcStr ] = NextRsrc(obj)
            px = int8(zeros(1,256));
            [status, RsrcStr ] = calllib('visa32', 'viFindNext', obj.findList, px);
            
            RsrcStr = deblank(char(RsrcStr));
            
        end
        
        % VISA32 FindModel
        %
        %
        function [ RsrcStr ] = FindModel(obj, ModelName)
            
            % Search for all registered resources
            %[RsrcStr, iCnt ] = obj.FindRsrc('?*');
            [RsrcStr, iCnt ] = obj.FindRsrc('GPIB?*INSTR');
            
            rsrclist = cell(iCnt,1);
            
            for idx = 1:iCnt
                rsrclist{idx} = RsrcStr;
                RsrcStr = obj.NextRsrc();
            end
            
            for idx = 1:iCnt
                found = [];
                
                try
                    obj.Open(rsrclist{idx});
                    resp = obj.Query('*IDN?');
                    found = strfind( upper(resp), upper(ModelName) );
                end
                
                obj.Close();
                
                if ~isempty(found)
                  RsrcStr = rsrclist{idx};
                  break;
                end
            end


        end        
        
    end
    
end

