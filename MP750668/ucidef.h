/********************************************************************
    created:	2014/12/23
    author:		M.Yang
    purpose:	UCI
    modify:
*********************************************************************/
#ifndef ucidef_h__
#define ucidef_h__

#if (defined(WIN32) || defined(_WIN32) || defined(__WIN32__) || defined(__NT__)) && !defined(_NI_mswin16_)
#define _UCIAPI   __stdcall
#define _UCICallBack   __stdcall
#endif

#define _in
#define _out
#define _in_out

#ifdef __cplusplus
namespace uci {
#endif 
#ifdef _CVI_
#define u_inline static
#else
#define u_inline inline
#endif 
#ifndef MAX_PATH
#define MAX_PATH          260
#endif 	
#ifdef _UNICODE
	#define u_tchar       wchar_t
#else
	#define u_tchar       char
#endif 
#if defined(_WIN64)
	typedef unsigned __int64 u_unit_ptr;
	typedef __int64 u_long_ptr;
#else
	typedef unsigned int u_unit_ptr;
	typedef long u_long_ptr;
#endif   

	#define u_bool       bool
	#define u_byte       unsigned char
	#define u_char       char
	#define u_buf        void*
	#define u_object     void
	#define u_short      short
	#define u_ushort     unsigned short
	#define u_int16      u_short
	#define u_uint16     u_ushort
	#define u_int32      int
	#define u_uint32     unsigned int
	#define u_status     u_int32
	#define u_size       u_uint32
	#define u_session    u_uint32
	#define u_string     u_tchar*
	#define u_cstring    const u_tchar*
	#define u_attr       u_int32
	#define u_attr_v     u_int32
	#define u_word       u_ushort
	#define u_dword      u_uint32
	#define u_wparam     u_unit_ptr
	#define u_lparam     u_long_ptr
	
			#define UCI_SUCCESS                  (0)
	#define UCI_ERR                      (-1000)
		#define UCIERR(r)                    (r < 0)
#define UCISUCCESS(r)                (!UCIERR(r))

		typedef enum _UCIErr {
		NoError = 0,

				InitResourceError = UCI_ERR - 20,
				Invalid_Session,
				Timeout,
				Failed,
				Unsupported,
				Insufficient_Memory,
				Busy,
				COMExpection,
				ChannelNotOpened,
				API_Failed,

				Unknown = UCI_ERR - 40 - 1,

				Connect_InvalidAddress = UCI_ERR - 40,
				Connect_NotBuild,
				Connect_Break,
				Connect_Unsupported_COMType,

				Device_NoFound = UCI_ERR - 60,
				Device_Unsupported,
				Device_QueryFirst,
				Device_NotMatch,

				Query_LANNodesFailed,

						AddrValid_AfterQueryDeviceOper,

				UDisk_NotFound,
				Key_Locked,

				CMD_Invalid_StringFormat = UCI_ERR - 80,
				CMD_OnlySupportSingle,
				CMD_OnlySupportSingleAttr,
				CMD_Unsupported,
				CMD_SendFailed,
				CMD_Invalid_ProtocolFormat,
				CMD_WriteFileToFlash_Failed,
				CMD_NoFound_Valid_Reply_Data,
				CMD_Error_Message,
				CMD_Invalid_Expression,
				CMD_Cannot_LoadARB_InCurrent_MOD_Mode,

				Args_Invalid = UCI_ERR - 100,
				Args_MemoryTooSmall,
				Args_FileNameTooLong,
				Args_DataLenNotMatch,

				Data_Overflow = UCI_ERR - 120,
				Data_OutRange,
				Data_NotReadEnoughLenth,
				Data_ECC_Failed,
				Data_Invalid,
				Data_Zip_Error,
				Data_UnZip_Error,
				Data_Transfer_Error, 
				Data_Transfer_Break,
				Data_No_Data_Incoming,
		
				File_AccessDenied = UCI_ERR - 140,
				File_GenericException,
				File_NotFound,
				File_BadPath,
				File_TooManyOpenFiles,
								File_InvalidFile,
				File_RemoveCurrentDir,
				File_DirectoryFull,
				File_BadSeek,
				File_HardIO,
				File_SharingViolation,
				File_LockViolation,
				File_DiskFull,
				File_EndOfFile,
				File_SaveToDiskFailed,
				File_Length_OutOfRange,
	}UErr;
		
	#define INVALID_SESSION  ((u_uint32)(-1))

				

#define CACHE_LINE  1
#define CACHE_ALIGN   __declspec(align(CACHE_LINE))

	#define PACK_ALIGN(n) __declspec(align(n))


#ifdef __cplusplus
	extern "C"{
#endif 
				u_inline u_word UCI_HIWORD(u_dword _dw) { return ((u_word)((_dw >> 16) & 0xffff)); }
		u_inline u_word UCI_LOWORD(u_dword _dw) { return ((u_word)(_dw & 0xffff)); }

				#include <PshPack1.h>
						typedef struct _RParams {
						u_cstring CMDString;
						u_uint32  RetCount;
						u_uint32  Timeout;
												u_buf     ExtraData; 						u_size    ExtraDataLen;
		}RParams, *PRParams;

#ifdef __cplusplus
		inline RParams* uci_CreateRParams(RParams& _p, u_cstring _cmd,
										  u_uint32 _timeout, u_buf _ExtraData,
										  u_size _ExtraDataLen) {
			memset(&_p, 0, sizeof(_p));
			_p.CMDString = _cmd;
			_p.Timeout = _timeout;
			_p.ExtraData = _ExtraData;
			_p.ExtraDataLen = _ExtraDataLen;
			return &_p;
		}
#else
		u_inline RParams* uci_CreateRParams(RParams* _p, u_cstring _cmd,
			u_uint32 _timeout, u_buf _ExtraData,
			u_size _ExtraDataLen) {
			memset(_p, 0, sizeof(*_p));
			_p->CMDString = _cmd;
			_p->Timeout = _timeout;
			_p->ExtraData = _ExtraData;
			_p->ExtraDataLen = _ExtraDataLen;
			return _p;
		}
#endif

		typedef struct _DeviceIOParams {
			u_int32  Count;
			u_int32* Data;
		}DeviceIOParams;

		typedef struct _QParams {
												u_int32   Type;
						u_int32   PortCount;
						u_int32*  Ports;
									u_int32   PVIDCount;
									u_int32*  PVID;
						u_cstring Msg;
		}QParams, *PQParams;
		u_inline u_int32 MakePVID(u_ushort _pid, u_ushort _vid) { return ((_pid << 16) | (_vid)); };

		u_inline u_ushort GetPID(u_int32 _pvid) { return UCI_HIWORD(_pvid); }

		u_inline u_ushort GetVID(u_int32 _pvid) { return UCI_LOWORD(_pvid); }

#ifdef __cplusplus
		inline QParams* UCI_CreateQParam(QParams& _qp, u_int32 _type,
										 u_int32* _ports, u_int32 _port_cnt,
										 u_int32* _pvid, u_int32 _pvid_cnt, u_cstring _msg) {
			memset(&_qp, 0, sizeof(_qp));
			_qp.Type = _type;
			_qp.Ports = _ports;
			_qp.PortCount = _port_cnt;
			_qp.PVID = _pvid;
			_qp.PVIDCount = _pvid_cnt;
			_qp.Msg = _msg;
			return &_qp;
		}
#else
		u_inline QParams* UCI_CreateQParam(QParams* _qp, u_int32 _type,
			u_int32* _ports, u_int32 _port_cnt,
			u_int32* _pvid, u_int32 _pvid_cnt, u_cstring _msg) {
			memset(_qp, 0, sizeof(*_qp));
			_qp->Type = _type;
			_qp->Ports = _ports;
			_qp->PortCount = _port_cnt;
			_qp->PVID = _pvid;
			_qp->PVIDCount = _pvid_cnt;
			_qp->Msg = _msg;
			return _qp;
		}
#endif
						typedef struct _WParams {
						u_cstring CMDString;
						u_uint32  RetCount;
						u_uint32  Timeout;
		}WParams, *PWParams;

#ifdef __cplusplus
		u_inline WParams* uci_CreateWParams(WParams& _p, u_cstring _cmd, u_uint32 _timeout) {
			memset(&_p, 0, sizeof(_p));
			_p.CMDString = _cmd;
			_p.Timeout = _timeout;
			return &_p;
		}
#else
		u_inline WParams* uci_CreateWParams(WParams* _p, u_cstring _cmd, u_uint32 _timeout) {
			memset(_p, 0, sizeof(*_p));
			_p->CMDString = _cmd;
			_p->Timeout = _timeout;
			return _p;
		}
#endif
		typedef struct _CommandParams {
						u_cstring CMDString;
						u_uint32  Param1;
						u_uint32  Param2;
						u_uint32  Timeout;
		}CommandParams, *PCommandParams;

				typedef struct _WFileParams {
						u_cstring  CMDString;
						u_cstring  FilePath;
						u_uint32   Timeout;
		}WFileParams, *PWFileParams;

				typedef struct _RFileParams {
						u_cstring   CMDString;
						u_cstring   FilePath;
						u_uint32    Timeout;
						u_tchar     FilePathFinal[MAX_PATH];
		}RFileParams, *PRFileParams;

						typedef enum _NodeType{
			LAN = 0x0001,
			USB = 0x0010,
		}NodeType;

						typedef struct _USBDescriptor {
						u_ushort  PID;
						u_ushort  VID;
						u_ushort  Addr;
		}USBDescriptor;

						typedef union _IPAddr {
			struct { u_byte f1, f2, f3, f4; } Field;
			u_int32 Addr;
		}u_IPAddr;

						typedef struct _LANDescriptor {
						u_tchar    IP[16];
						u_IPAddr   Addr;
									u_ushort   Port;
		}LANDescriptor;

						typedef struct _Node {
						NodeType Type;
												u_tchar   Name[50];
									u_tchar   DevType[10];
						LANDescriptor LAN;
						USBDescriptor USB;
						u_tchar   UCIAddr[256];
						u_tchar   SN[50];
						u_status  Status;
						u_tchar   IDN[20];
		}Node, *PNode;


						typedef struct _NodeEx {
						NodeType Type;
									u_tchar   Name[50];
									u_tchar   DevType[10];
						LANDescriptor LAN;
						USBDescriptor USB;
						u_tchar   UCIAddr[256];
						u_tchar   SN[50];
						u_status  Status;
						u_tchar   IDN[20];
		}NodeEx, *PNodeEx;

		typedef struct _UCIMSG {
			u_session   Session;
			u_uint32    Message;
			u_wparam    wParams;
			u_lparam    lParams;
			u_byte      Reserved[240];
		}UCIMSG;
				typedef enum _uci_msg {
															UMSG_CONNECT_CLOSED = 1,
																		UMSG_FILE_TRANSFER = 2,
															UMSG_DEVICE_NOTIFY = 3,
		}EUCIMSG;

		typedef int(__stdcall *UCIMSGProc)(UCIMSG* _msg);
#include <poppack.h>

#ifdef __cplusplus
	}
#endif
#ifdef __cplusplus
}
#endif 
#endif // ucidef_h__ 
