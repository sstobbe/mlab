classdef MP750XXX < handle
    %MP750XXX Interface for Multicomp/uni-t Arb Function Generators 
    %   
    %   h = MP750XXX( )
    %
    %   Scottie Stobbe 2022
    
    properties (SetAccess = protected, Transient = true)
        RSRC_ADDR
        sesid
        MFG
        PN
        SN
        FW_VER
    end
    
    properties (Dependent = true)% public 
        FREQ
        OUT_EN
        INVERT
        SYNC_OUT
        LOAD
        LIMIT_EN
        LIMIT_MIN
        LIMIT_MAX
        WAVEFORM
        AMP_VPP
        AMP_VRMS
        AMP_DBM
        AMP_MIN
        AMP_MAX
    end
    
    methods
        % DS1054Z Constructor
        function obj = MP750XXX( )
            if ( ~libisloaded('uci') )
                loadlibrary '.\uci.dll' ...
                    '.\uci.h' ...
                    addheader '.\ucidef.h'...
                    alias uci;
            end
            
            addr = '[C:SG][D:DDSFG][T:USB][PID:0x1234][VID:0x5345][EI:0x81][EO:0x3][CFG:1][I:0][addr:0][IDN:DDS%**]';
            [status, srtn, sesid] = calllib('uci', 'uci_Open', addr, 0, 0 );
            if status
                warning('no connetion')
            end
            
            obj.sesid = sesid;
            obj.PN = '';
            obj.SN = '';
            obj.MFG = '';
        end
        
        % DS1054Z Destructor
        %
        % Close comm channels
        function delete(obj)
            [status ] = calllib('uci', 'uci_Close',obj.sesid );
            unloadlibrary uci
        end 
        
        function scommand(obj,cmdstr)
            pstrcut = struct;
            pstrcut.CMDString = cmdstr;
            pstrcut.RetCount = 50;
            pstrcut.Timeout = 1000;
            wstruct = libstruct('s_WParams',pstrcut);
            [status ] = calllib('uci', 'uci_Write',obj.sesid,wstruct ,0,0 );
            clear wstruct; % matlab bug for unloadlib
        end
        
        function val = read(obj,cmdstr,n)
            pstrcut = struct;
            pstrcut.CMDString = cmdstr;
            pstrcut.RetCount = n;
            pstrcut.Timeout = 1000;
            pstrcut.ExtraData = [0 1 2 3];
            pstrcut.ExtraDataLen = 4;
            wstruct = libstruct('s_RParams',pstrcut);
            px = libpointer( 'uint8Ptr', zeros(1,n));
            [status, ~, ~ ] = calllib('uci', 'uci_Read',obj.sesid,wstruct ,px,n);
            clear wstruct; % matlab bug for unloadlib
            val = get(px,'Value');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Getters / Setters
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
         function val = get.FREQ(obj)
          val = typecast(obj.read('rp@CH:0@addr:0x8009;',8), 'double');
        end
        
        % FREQ setter
        function obj = set.FREQ(obj,val)
            if ~isscalar(val)
                error('INVALID FREQ');
            end
            cmd = { 'OFF', 'ON' };
            obj.scommand(['wp@CH:0@addr:0x8009@v:' num2str(val) ';' ] );
        end
        
         function val = get.OUT_EN(obj)
          val = typecast(obj.read('KEY:C1@LED?;',4), 'int32');
        end
        
        % OUT_EN setter
        function obj = set.OUT_EN(obj,val)
            if ~isscalar(val)
                error('INVALID FREQ');
            end
            cmd = { 'OFF', 'ON' };
            obj.scommand(['wp@CH:0@addr:0x8001@v:' num2str(val) ';' ] );
        end
        %KEY:C1;
%KEY:C1@LED?;
        
    end
end
