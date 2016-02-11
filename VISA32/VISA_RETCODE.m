classdef VISA_RETCODE < int32
    %VISA_RETCODE VISA32 Return Codes enum
    %
    % Scott Stobbe 2016
    %
    % Enum constructed from list of return codes defined in visa.h
    %
    % General notes: 
    %        return code >= 0 : SUCCESS
    %        return code > 0 : SUCCESS with Code
    %        return code < 0 : ERROR 
    %
    enumeration
        ERROR                              (int32(-2147483647)-1)  % hex2dec('80000000 */
        SUCCESS                            (0)
        SUCCESS_EVENT_EN                   (hex2dec('3FFF0002')) % 3FFF0002,  1073676290 */
        SUCCESS_EVENT_DIS                  (hex2dec('3FFF0003')) % 3FFF0003,  1073676291 */
        SUCCESS_QUEUE_EMPTY                (hex2dec('3FFF0004')) % 3FFF0004,  1073676292 */
        SUCCESS_TERM_CHAR                  (hex2dec('3FFF0005')) % 3FFF0005,  1073676293 */
        SUCCESS_MAX_CNT                    (hex2dec('3FFF0006')) % 3FFF0006,  1073676294 */
        SUCCESS_DEV_NPRESENT               (hex2dec('3FFF007D')) % 3FFF007D,  1073676413 */
        SUCCESS_TRIG_MAPPED                (hex2dec('3FFF007E')) % 3FFF007E,  1073676414 */
        SUCCESS_QUEUE_NEMPTY               (hex2dec('3FFF0080')) % 3FFF0080,  1073676416 */
        SUCCESS_NCHAIN                     (hex2dec('3FFF0098')) % 3FFF0098,  1073676440 */
        SUCCESS_NESTED_SHARED              (hex2dec('3FFF0099')) % 3FFF0099,  1073676441 */
        SUCCESS_NESTED_EXCLUSIVE           (hex2dec('3FFF009A')) % 3FFF009A,  1073676442 */
        SUCCESS_SYNC                       (hex2dec('3FFF009B')) % 3FFF009B,  1073676443 */
        WARN_QUEUE_OVERFLOW                (hex2dec('3FFF000C')) % 3FFF000C,  1073676300 */
        WARN_CONFIG_NLOADED                (hex2dec('3FFF0077')) % 3FFF0077,  1073676407 */
        WARN_NULL_OBJECT                   (hex2dec('3FFF0082')) % 3FFF0082,  1073676418 */
        WARN_NSUP_ATTR_STATE               (hex2dec('3FFF0084')) % 3FFF0084,  1073676420 */
        WARN_UNKNOWN_STATUS                (hex2dec('3FFF0085')) % 3FFF0085,  1073676421 */
        WARN_NSUP_BUF                      (hex2dec('3FFF0088')) % 3FFF0088,  1073676424 */
        WARN_EXT_FUNC_NIMPL                (hex2dec('3FFF00A9')) % 3FFF00A9,  1073676457 */
        ERROR_SYSTEM_ERROR                 (VISA_RETCODE.ERROR+hex2dec('3FFF0000')) % BFFF0000, -1073807360 */
        ERROR_INV_OBJECT                   (VISA_RETCODE.ERROR+hex2dec('3FFF000E')) % BFFF000E, -1073807346 */
        ERROR_RSRC_LOCKED                  (VISA_RETCODE.ERROR+hex2dec('3FFF000F')) % BFFF000F, -1073807345 */
        ERROR_INV_EXPR                     (VISA_RETCODE.ERROR+hex2dec('3FFF0010')) % BFFF0010, -1073807344 */
        ERROR_RSRC_NFOUND                  (VISA_RETCODE.ERROR+hex2dec('3FFF0011')) % BFFF0011, -1073807343 */
        ERROR_INV_RSRC_NAME                (VISA_RETCODE.ERROR+hex2dec('3FFF0012')) % BFFF0012, -1073807342 */
        ERROR_INV_ACC_MODE                 (VISA_RETCODE.ERROR+hex2dec('3FFF0013')) % BFFF0013, -1073807341 */
        ERROR_TMO                          (VISA_RETCODE.ERROR+hex2dec('3FFF0015')) % BFFF0015, -1073807339 */
        ERROR_CLOSING_FAILED               (VISA_RETCODE.ERROR+hex2dec('3FFF0016')) % BFFF0016, -1073807338 */
        ERROR_INV_DEGREE                   (VISA_RETCODE.ERROR+hex2dec('3FFF001B')) % BFFF001B, -1073807333 */
        ERROR_INV_JOB_ID                   (VISA_RETCODE.ERROR+hex2dec('3FFF001C')) % BFFF001C, -1073807332 */
        ERROR_NSUP_ATTR                    (VISA_RETCODE.ERROR+hex2dec('3FFF001D')) % BFFF001D, -1073807331 */
        ERROR_NSUP_ATTR_STATE              (VISA_RETCODE.ERROR+hex2dec('3FFF001E')) % BFFF001E, -1073807330 */
        ERROR_ATTR_READONLY                (VISA_RETCODE.ERROR+hex2dec('3FFF001F')) % BFFF001F, -1073807329 */
        ERROR_INV_LOCK_TYPE                (VISA_RETCODE.ERROR+hex2dec('3FFF0020')) % BFFF0020, -1073807328 */
        ERROR_INV_ACCESS_KEY               (VISA_RETCODE.ERROR+hex2dec('3FFF0021')) % BFFF0021, -1073807327 */
        ERROR_INV_EVENT                    (VISA_RETCODE.ERROR+hex2dec('3FFF0026')) % BFFF0026, -1073807322 */
        ERROR_INV_MECH                     (VISA_RETCODE.ERROR+hex2dec('3FFF0027')) % BFFF0027, -1073807321 */
        ERROR_HNDLR_NINSTALLED             (VISA_RETCODE.ERROR+hex2dec('3FFF0028')) % BFFF0028, -1073807320 */
        ERROR_INV_HNDLR_REF                (VISA_RETCODE.ERROR+hex2dec('3FFF0029')) % BFFF0029, -1073807319 */
        ERROR_INV_CONTEXT                  (VISA_RETCODE.ERROR+hex2dec('3FFF002A')) % BFFF002A, -1073807318 */
        ERROR_QUEUE_OVERFLOW               (VISA_RETCODE.ERROR+hex2dec('3FFF002D')) % BFFF002D, -1073807315 */
        ERROR_NENABLED                     (VISA_RETCODE.ERROR+hex2dec('3FFF002F')) % BFFF002F, -1073807313 */
        ERROR_ABORT                        (VISA_RETCODE.ERROR+hex2dec('3FFF0030')) % BFFF0030, -1073807312 */
        ERROR_RAW_WR_PROT_VIOL             (VISA_RETCODE.ERROR+hex2dec('3FFF0034')) % BFFF0034, -1073807308 */
        ERROR_RAW_RD_PROT_VIOL             (VISA_RETCODE.ERROR+hex2dec('3FFF0035')) % BFFF0035, -1073807307 */
        ERROR_OUTP_PROT_VIOL               (VISA_RETCODE.ERROR+hex2dec('3FFF0036')) % BFFF0036, -1073807306 */
        ERROR_INP_PROT_VIOL                (VISA_RETCODE.ERROR+hex2dec('3FFF0037')) % BFFF0037, -1073807305 */
        ERROR_BERR                         (VISA_RETCODE.ERROR+hex2dec('3FFF0038')) % BFFF0038, -1073807304 */
        ERROR_IN_PROGRESS                  (VISA_RETCODE.ERROR+hex2dec('3FFF0039')) % BFFF0039, -1073807303 */
        ERROR_INV_SETUP                    (VISA_RETCODE.ERROR+hex2dec('3FFF003A')) % BFFF003A, -1073807302 */
        ERROR_QUEUE_ERROR                  (VISA_RETCODE.ERROR+hex2dec('3FFF003B')) % BFFF003B, -1073807301 */
        ERROR_ALLOC                        (VISA_RETCODE.ERROR+hex2dec('3FFF003C')) % BFFF003C, -1073807300 */
        ERROR_INV_MASK                     (VISA_RETCODE.ERROR+hex2dec('3FFF003D')) % BFFF003D, -1073807299 */
        ERROR_IO                           (VISA_RETCODE.ERROR+hex2dec('3FFF003E')) % BFFF003E, -1073807298 */
        ERROR_INV_FMT                      (VISA_RETCODE.ERROR+hex2dec('3FFF003F')) % BFFF003F, -1073807297 */
        ERROR_NSUP_FMT                     (VISA_RETCODE.ERROR+hex2dec('3FFF0041')) % BFFF0041, -1073807295 */
        ERROR_LINE_IN_USE                  (VISA_RETCODE.ERROR+hex2dec('3FFF0042')) % BFFF0042, -1073807294 */
        ERROR_LINE_NRESERVED               (VISA_RETCODE.ERROR+hex2dec('3FFF0043')) % BFFF0043, -1073807293 */
        ERROR_NSUP_MODE                    (VISA_RETCODE.ERROR+hex2dec('3FFF0046')) % BFFF0046, -1073807290 */
        ERROR_SRQ_NOCCURRED                (VISA_RETCODE.ERROR+hex2dec('3FFF004A')) % BFFF004A, -1073807286 */
        ERROR_INV_SPACE                    (VISA_RETCODE.ERROR+hex2dec('3FFF004E')) % BFFF004E, -1073807282 */
        ERROR_INV_OFFSET                   (VISA_RETCODE.ERROR+hex2dec('3FFF0051')) % BFFF0051, -1073807279 */
        ERROR_INV_WIDTH                    (VISA_RETCODE.ERROR+hex2dec('3FFF0052')) % BFFF0052, -1073807278 */
        ERROR_NSUP_OFFSET                  (VISA_RETCODE.ERROR+hex2dec('3FFF0054')) % BFFF0054, -1073807276 */
        ERROR_NSUP_VAR_WIDTH               (VISA_RETCODE.ERROR+hex2dec('3FFF0055')) % BFFF0055, -1073807275 */
        ERROR_WINDOW_NMAPPED               (VISA_RETCODE.ERROR+hex2dec('3FFF0057')) % BFFF0057, -1073807273 */
        ERROR_RESP_PENDING                 (VISA_RETCODE.ERROR+hex2dec('3FFF0059')) % BFFF0059, -1073807271 */
        ERROR_NLISTENERS                   (VISA_RETCODE.ERROR+hex2dec('3FFF005F')) % BFFF005F, -1073807265 */
        ERROR_NCIC                         (VISA_RETCODE.ERROR+hex2dec('3FFF0060')) % BFFF0060, -1073807264 */
        ERROR_NSYS_CNTLR                   (VISA_RETCODE.ERROR+hex2dec('3FFF0061')) % BFFF0061, -1073807263 */
        ERROR_NSUP_OPER                    (VISA_RETCODE.ERROR+hex2dec('3FFF0067')) % BFFF0067, -1073807257 */
        ERROR_INTR_PENDING                 (VISA_RETCODE.ERROR+hex2dec('3FFF0068')) % BFFF0068, -1073807256 */
        ERROR_ASRL_PARITY                  (VISA_RETCODE.ERROR+hex2dec('3FFF006A')) % BFFF006A, -1073807254 */
        ERROR_ASRL_FRAMING                 (VISA_RETCODE.ERROR+hex2dec('3FFF006B')) % BFFF006B, -1073807253 */
        ERROR_ASRL_OVERRUN                 (VISA_RETCODE.ERROR+hex2dec('3FFF006C')) % BFFF006C, -1073807252 */
        ERROR_TRIG_NMAPPED                 (VISA_RETCODE.ERROR+hex2dec('3FFF006E')) % BFFF006E, -1073807250 */
        ERROR_NSUP_ALIGN_OFFSET            (VISA_RETCODE.ERROR+hex2dec('3FFF0070')) % BFFF0070, -1073807248 */
        ERROR_USER_BUF                     (VISA_RETCODE.ERROR+hex2dec('3FFF0071')) % BFFF0071, -1073807247 */
        ERROR_RSRC_BUSY                    (VISA_RETCODE.ERROR+hex2dec('3FFF0072')) % BFFF0072, -1073807246 */
        ERROR_NSUP_WIDTH                   (VISA_RETCODE.ERROR+hex2dec('3FFF0076')) % BFFF0076, -1073807242 */
        ERROR_INV_PARAMETER                (VISA_RETCODE.ERROR+hex2dec('3FFF0078')) % BFFF0078, -1073807240 */
        ERROR_INV_PROT                     (VISA_RETCODE.ERROR+hex2dec('3FFF0079')) % BFFF0079, -1073807239 */
        ERROR_INV_SIZE                     (VISA_RETCODE.ERROR+hex2dec('3FFF007B')) % BFFF007B, -1073807237 */
        ERROR_WINDOW_MAPPED                (VISA_RETCODE.ERROR+hex2dec('3FFF0080')) % BFFF0080, -1073807232 */
        ERROR_NIMPL_OPER                   (VISA_RETCODE.ERROR+hex2dec('3FFF0081')) % BFFF0081, -1073807231 */
        ERROR_INV_LENGTH                   (VISA_RETCODE.ERROR+hex2dec('3FFF0083')) % BFFF0083, -1073807229 */
        ERROR_INV_MODE                     (VISA_RETCODE.ERROR+hex2dec('3FFF0091')) % BFFF0091, -1073807215 */
        ERROR_SESN_NLOCKED                 (VISA_RETCODE.ERROR+hex2dec('3FFF009C')) % BFFF009C, -1073807204 */
        ERROR_MEM_NSHARED                  (VISA_RETCODE.ERROR+hex2dec('3FFF009D')) % BFFF009D, -1073807203 */
        ERROR_LIBRARY_NFOUND               (VISA_RETCODE.ERROR+hex2dec('3FFF009E')) % BFFF009E, -1073807202 */
        ERROR_NSUP_INTR                    (VISA_RETCODE.ERROR+hex2dec('3FFF009F')) % BFFF009F, -1073807201 */
        ERROR_INV_LINE                     (VISA_RETCODE.ERROR+hex2dec('3FFF00A0')) % BFFF00A0, -1073807200 */
        ERROR_FILE_ACCESS                  (VISA_RETCODE.ERROR+hex2dec('3FFF00A1')) % BFFF00A1, -1073807199 */
        ERROR_FILE_IO                      (VISA_RETCODE.ERROR+hex2dec('3FFF00A2')) % BFFF00A2, -1073807198 */
        ERROR_NSUP_LINE                    (VISA_RETCODE.ERROR+hex2dec('3FFF00A3')) % BFFF00A3, -1073807197 */
        ERROR_NSUP_MECH                    (VISA_RETCODE.ERROR+hex2dec('3FFF00A4')) % BFFF00A4, -1073807196 */
        ERROR_INTF_NUM_NCONFIG             (VISA_RETCODE.ERROR+hex2dec('3FFF00A5')) % BFFF00A5, -1073807195 */
        ERROR_CONN_LOST                    (VISA_RETCODE.ERROR+hex2dec('3FFF00A6')) % BFFF00A6, -1073807194 */
        ERROR_MACHINE_NAVAIL               (VISA_RETCODE.ERROR+hex2dec('3FFF00A7')) % BFFF00A7, -1073807193 */
        ERROR_NPERMISSION                  (VISA_RETCODE.ERROR+hex2dec('3FFF00A8')) % BFFF00A8, -1073807192 */
    end
end

