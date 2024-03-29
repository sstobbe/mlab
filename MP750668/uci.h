/********************************************************************
	created:	2014/12/22
	author:		M.Yang
	purpose:	UCI(united communicate interface)
*********************************************************************/

#ifndef uci_h__
#define uci_h__

#include "ucidef.h"


#ifdef __cplusplus
namespace uci {
extern "C"{
#endif
u_status _UCIAPI uci_Query(_in_out PRParams _params, _in_out u_byte* _data, _in u_size _dataCount);

u_status _UCIAPI uci_QueryNodes(_in const QParams* _params, _out Node* _outBuf, 
_in_out u_size* _nodeCnt, _in u_size _timeOut);

u_status _UCIAPI uci_QueryNodesX(u_cstring _msg, Node* _nodes, u_size _node_count, _in u_size _timeout);

u_status _UCIAPI uci_QueryNodesX_Simple(u_tchar* _addr_msg, u_size _addr_msg_len, u_size _node_type, _in u_size _timeout);

u_status _UCIAPI uci_Open(u_cstring _addr, u_session* _session, u_uint32 _timeOut);

u_status _UCIAPI uci_OpenX(u_cstring _addr, u_uint32 _timeOut);

u_status _UCIAPI uci_SendCommand(u_session _session, PCommandParams _params);

u_status _UCIAPI uci_SetNotify(UCIMSGProc _pNotify);

u_status _UCIAPI uci_SetAttribute(u_session _sesn, u_cstring _msg, const u_object* _obj, u_size _objSize);

u_status _UCIAPI uci_GetAttribute(u_session _sesn, u_cstring _msg, u_object* _obj, u_size _objSize);

u_status _UCIAPI uci_Write(u_session _session, PWParams _params, const u_byte* _data, u_size _len);

u_status _UCIAPI uci_WriteX(u_session _session, u_cstring _msg, 
u_uint32 _timeout, const u_byte* _data, u_size _len);

u_status _UCIAPI uci_WriteSimple(u_session _session, u_cstring _msg, u_uint32 _timeout);

u_status _UCIAPI uci_FormatWrite(u_session _sesn, u_uint32 _timeOut, const u_tchar *format, ...);

u_status _UCIAPI uci_Read(u_session _session, PRParams _params, u_byte* _data, u_size _dataLen);

u_status _UCIAPI uci_ReadX(u_session _session, u_cstring _msg, 
u_uint32 _timeout, u_byte* _data, u_size _dataLen);

u_status _UCIAPI uci_WriteFromFile(u_session _session, WFileParams* _info);

u_status _UCIAPI uci_WriteFromFileX(u_session _session, u_cstring _msg,
u_cstring _filePath, u_uint32 _timeout);

u_status _UCIAPI uci_ReadToFile(u_session _session, RFileParams* _params);

u_status _UCIAPI uci_ReadToFileX(u_session _session, u_cstring _msg,
u_cstring _filePath, u_uint32 _timeout, 
u_tchar *_filePathFinal, u_int32 _filePathFinalLength);

u_status _UCIAPI uci_Close(u_session _session);

u_cstring _UCIAPI uci_GetLastError(void);

void _UCIAPI uci_ExInstance(void);

typedef struct _WParams {
u_cstring CMDString;
u_uint32  RetCount;
u_uint32  Timeout;
}WParams;
#ifdef __cplusplus
}

}
#endif
#endif
