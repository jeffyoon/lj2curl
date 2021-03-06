local ffi = require("ffi");

require("platform")


ffi.cdef[[
typedef socklen_t CURL_TYPEOF_CURL_SOCKLEN_T;

typedef long CURL_TYPEOF_CURL_OFF_T;
typedef CURL_TYPEOF_CURL_SOCKLEN_T curl_socklen_t;
typedef CURL_TYPEOF_CURL_OFF_T curl_off_t;
typedef socket_t curl_socket_t;
//typedef int curl_socket_t;

static const int CURL_SIZEOF_LONG = 8;
static const int CURL_SIZEOF_CURL_SOCKLEN_T = 4;
static const int CURL_SIZEOF_CURL_OFF_T = 8;

]]

--[[
#define CURL_FORMAT_CURL_OFF_T "ld"
/* unsigned curl_off_t formatting string without "%" conversion specifier. */
#define CURL_FORMAT_CURL_OFF_TU "lu"
/* curl_off_t formatting string directive with "%" conversion specifier. */
static CURL_FORMAT_OFF_T "%ld"

/* curl_off_t constant suffix. */
#define CURL_SUFFIX_CURL_OFF_T L
/* unsigned curl_off_t constant suffix. */
#define CURL_SUFFIX_CURL_OFF_TU UL
--]]

--[[
#if (defined(_WIN32); || defined(__WIN32__);); && \
     !defined(WIN32); && !defined(__SYMBIAN32__);
WIN32
#endif

#include <stdio.h>
#include <limits.h>

#if defined(__FreeBSD__); && (__FreeBSD__ >= 2);
/* Needed for __FreeBSD_version symbol definition */
#include <osreldate.h>
#endif

/* The include stuff here below is mainly for time_t! */
#include <sys/types.h>
#include <time.h>

#if defined(WIN32); && !defined(_WIN32_WCE); && !defined(__CYGWIN__);
#if !(defined(_WINSOCKAPI_); || defined(_WINSOCK_H); || defined(__LWIP_OPT_H__););
/* The check above prevents the winsock2 inclusion if winsock.h already was
   included, since they can't co-exist without problems */
#include <winsock2.h>
#include <ws2tcpip.h>
#endif
#endif

/* HP-UX systems version 9, 10 and 11 lack sys/select.h and so does oldish
   libc5-based Linux systems. Only include it on systems that are known to
   require it! */
#if defined(_AIX); || defined(__NOVELL_LIBC__); || defined(__NetBSD__); || \
    defined(__minix); || defined(__SYMBIAN32__); || defined(__INTEGRITY); || \
    defined(ANDROID); || defined(__ANDROID__); || defined(__OpenBSD__); || \
   (defined(__FreeBSD_version); && (__FreeBSD_version < 800000););
#include <sys/select.h>
#endif

#if !defined(WIN32); && !defined(_WIN32_WCE);
#include <sys/socket.h>
#endif

#if !defined(WIN32); && !defined(__WATCOMC__); && !defined(__VXWORKS__);
#include <sys/time.h>
#endif

#ifdef __BEOS__
#include <support/SupportDefs.h>
#endif
--]]


ffi.cdef[[
typedef void CURL;
]]

--[[
/*
 * libcurl external API function linkage decorations.
 */

#ifdef CURL_STATICLIB
#  define CURL_EXTERN
#elif defined(WIN32); || defined(_WIN32); || defined(__SYMBIAN32__);
#  if defined(BUILDING_LIBCURL);
#    define  __declspec(dllexport);
#  else
#    define  __declspec(dllimport);
#  endif
#elif defined(BUILDING_LIBCURL); && defined(CURL_HIDDEN_SYMBOLS);
#  define CURL_EXTERN_SYMBOL
#else
#  define CURL_EXTERN
#endif
--]]


ffi.cdef[[
static const int CURL_SOCKET_BAD = -1;
]]

ffi.cdef[[
struct curl_httppost {
  struct curl_httppost *next;       /* next entry in the list */
  char *name;                       /* pointer to allocated name */
  long namelength;                  /* length of name length */
  char *contents;                   /* pointer to allocated data contents */
  long contentslength;              /* length of contents field, see also
                                       CURL_HTTPPOST_LARGE */
  char *buffer;                     /* pointer to allocated buffer contents */
  long bufferlength;                /* length of buffer field */
  char *contenttype;                /* Content-Type */
  struct curl_slist* contentheader; /* list of extra headers for this form */
  struct curl_httppost *more;       /* if one field name has more than one
                                       file, this link should link to following
                                       files */
  long flags;                       /* as defined below */


  char *showfilename;               /* The file name to show. If not set, the
                                       actual file name will be used (if this
                                       is a file part); */
  void *userp;                      /* custom pointer used for
                                       HTTPPOST_CALLBACK posts */
  curl_off_t contentlen;            /* alternative length of contents
                                       field. Used if CURL_HTTPPOST_LARGE is
                                       set. Added in 7.46.0 */
};
]]

ffi.cdef[[
static const int CURL_HTTPPOST_FILENAME =(1<<0);
static const int CURL_HTTPPOST_READFILE =(1<<1);
static const int CURL_HTTPPOST_PTRNAME =(1<<2);
static const int CURL_HTTPPOST_PTRCONTENTS =(1<<3);
static const int CURL_HTTPPOST_BUFFER =(1<<4);
static const int CURL_HTTPPOST_PTRBUFFER =(1<<5);
static const int CURL_HTTPPOST_CALLBACK =(1<<6);
static const int CURL_HTTPPOST_LARGE =(1<<7);
]]


ffi.cdef[[
/* This is the CURLOPT_PROGRESSFUNCTION callback proto. It is now considered
   deprecated but was the only choice up until 7.31.0 */
typedef int (*curl_progress_callback)(void *clientp,
                                      double dltotal,
                                      double dlnow,
                                      double ultotal,
                                      double ulnow);
]]

ffi.cdef[[
/* This is the CURLOPT_XFERINFOFUNCTION callback proto. It was introduced in
   7.32.0, it avoids floating point and provides more detailed information. */
typedef int (*curl_xferinfo_callback)(void *clientp,
                                      curl_off_t dltotal,
                                      curl_off_t dlnow,
                                      curl_off_t ultotal,
                                      curl_off_t ulnow);
]]

ffi.cdef[[

static const int CURL_MAX_WRITE_SIZE = 16384;

static const int CURL_MAX_HTTP_HEADER = (100*1024);

static const int CURL_WRITEFUNC_PAUSE = 0x10000001;
]]

ffi.cdef[[
typedef size_t (*curl_write_callback)(char *buffer,
                                      size_t size,
                                      size_t nitems,
                                      void *outstream);
]]

ffi.cdef[[
/* enumeration of file types */
typedef enum {
  CURLFILETYPE_FILE = 0,
  CURLFILETYPE_DIRECTORY,
  CURLFILETYPE_SYMLINK,
  CURLFILETYPE_DEVICE_BLOCK,
  CURLFILETYPE_DEVICE_CHAR,
  CURLFILETYPE_NAMEDPIPE,
  CURLFILETYPE_SOCKET,
  CURLFILETYPE_DOOR, /* is possible only on Sun Solaris now */

  CURLFILETYPE_UNKNOWN /* should never occur */
} curlfiletype;
]]

ffi.cdef[[
typedef enum {
  CURLFINFOFLAG_KNOWN_FILENAME   = (1<<0),
  CURLFINFOFLAG_KNOWN_FILETYPE   = (1<<1),
  CURLFINFOFLAG_KNOWN_TIME       = (1<<2),
  CURLFINFOFLAG_KNOWN_PERM       = (1<<3),
  CURLFINFOFLAG_KNOWN_UID        = (1<<4),
  CURLFINFOFLAG_KNOWN_GID        = (1<<5),
  CURLFINFOFLAG_KNOWN_SIZE       = (1<<6),
  CURLFINFOFLAG_KNOWN_HLINKCOUNT = (1<<7),
};
]]

ffi.cdef[[
/* Content of this structure depends on information which is known and is
   achievable (e.g. by FTP LIST parsing);. Please see the url_easy_setopt(3); man
   page for callbacks returning this structure -- some fields are mandatory,
   some others are optional. The FLAG field has special meaning. */
struct curl_fileinfo {
  char *filename;
  curlfiletype filetype;
  time_t time;
  unsigned int perm;
  int uid;
  int gid;
  curl_off_t size;
  long int hardlinks;

  struct {
    /* If some of these fields is not NULL, it is a pointer to b_data. */
    char *time;
    char *perm;
    char *user;
    char *group;
    char *target; /* pointer to the target filename of a symlink */
  } strings;

  unsigned int flags;

  /* used internally */
  char * b_data;
  size_t b_size;
  size_t b_used;
};
]]

ffi.cdef[[
typedef enum {
/* return codes for CURLOPT_CHUNK_BGN_FUNCTION */
  CURL_CHUNK_BGN_FUNC_OK     = 0,
  CURL_CHUNK_BGN_FUNC_FAIL   = 1, /* tell the lib to end the task */
  CURL_CHUNK_BGN_FUNC_SKIP   = 2 /* skip this chunk over */
};


typedef long (*curl_chunk_bgn_callback)(const void *transfer_info, void *ptr, int remains);
]]

ffi.cdef[[
enum {
  /* return codes for CURLOPT_CHUNK_END_FUNCTION */
  CURL_CHUNK_END_FUNC_OK     = 0,
  CURL_CHUNK_END_FUNC_FAIL   = 1 /* tell the lib to end the task */
}
]]

ffi.cdef[[
typedef long (*curl_chunk_end_callback)(void *ptr);
]]

ffi.cdef[[
/* return codes for FNMATCHFUNCTION */
static const int CURL_FNMATCHFUNC_MATCH   = 0; /* string corresponds to the pattern */
static const int CURL_FNMATCHFUNC_NOMATCH = 1; /* pattern doesn't match the string */
static const int CURL_FNMATCHFUNC_FAIL    = 2; /* an error occurred */
]]

ffi.cdef[[
/* callback type for wildcard downloading pattern matching. If the
   string matches the pattern, return CURL_FNMATCHFUNC_MATCH value, etc. */
typedef int (*curl_fnmatch_callback)(void *ptr,
                                     const char *pattern,
                                     const char *string);
]]

ffi.cdef[[
/* These are the return codes for the seek callbacks */
typedef enum {
  CURL_SEEKFUNC_OK      = 0,
  CURL_SEEKFUNC_FAIL    = 1, /* fail the entire transfer */
  CURL_SEEKFUNC_CANTSEEK = 2 /* tell libcurl seeking can't be done, so
                                    libcurl might try other means instead */
}
]]

ffi.cdef[[
typedef int (*curl_seek_callback)(void *instream,
                                  curl_off_t offset,
                                  int origin); 
]]

ffi.cdef[[
static const int CURL_READFUNC_ABORT = 0x10000000;
static const int CURL_READFUNC_PAUSE = 0x10000001;
]]

ffi.cdef[[
typedef size_t (*curl_read_callback)(char *buffer,
                                      size_t size,
                                      size_t nitems,
                                      void *instream);

typedef enum  {
  CURLSOCKTYPE_IPCXN,  /* socket created for a specific IP connection */
  CURLSOCKTYPE_ACCEPT, /* socket created by accept(); call */
  CURLSOCKTYPE_LAST    /* never use */
} curlsocktype;
]]

ffi.cdef[[
/* The return code from the sockopt_callback can signal information back
   to libcurl: */
static const int CURL_SOCKOPT_OK = 0;
static const int CURL_SOCKOPT_ERROR = 1; /* causes libcurl to abort and return
                                CURLE_ABORTED_BY_CALLBACK */
static const int CURL_SOCKOPT_ALREADY_CONNECTED = 2;
]]


ffi.cdef[[
typedef int (*curl_sockopt_callback)(void *clientp,
                                     curl_socket_t curlfd,
                                     curlsocktype purpose);
]]

ffi.cdef[[
struct curl_sockaddr {
  int family;
  int socktype;
  int protocol;
  unsigned int addrlen; /* addrlen was a socklen_t type before 7.18.0 but it
                           turned really ugly and painful on the systems that
                           lack this type */
  struct sockaddr addr;
};
]]

ffi.cdef[[
typedef curl_socket_t
(*curl_opensocket_callback)(void *clientp,
                            curlsocktype purpose,
                            struct curl_sockaddr *address);

typedef int
(*curl_closesocket_callback)(void *clientp, curl_socket_t item);
]]

ffi.cdef[[
typedef enum {
  CURLIOE_OK,            /* I/O operation successful */
  CURLIOE_UNKNOWNCMD,    /* command was unknown to callback */
  CURLIOE_FAILRESTART,   /* failed to restart the read */
  CURLIOE_LAST           /* never use */
} curlioerr;

typedef enum  {
  CURLIOCMD_NOP,         /* no operation */
  CURLIOCMD_RESTARTREAD, /* restart the read stream from start */
  CURLIOCMD_LAST         /* never use */
} curliocmd;
]]

ffi.cdef[[
typedef curlioerr (*curl_ioctl_callback)(CURL *handle,
                                         int cmd,
                                         void *clientp);
]]

ffi.cdef[[
/*
 * The following typedef's are signatures of malloc, free, realloc, strdup and
 * calloc respectively.  Function pointers of these types can be passed to the
 * curl_global_init_mem(); function to set user defined memory management
 * callback routines.
 */
typedef void *(*curl_malloc_callback)(size_t size);
typedef void (*curl_free_callback)(void *ptr);
typedef void *(*curl_realloc_callback)(void *ptr, size_t size);
typedef char *(*curl_strdup_callback)(const char *str);
typedef void *(*curl_calloc_callback)(size_t nmemb, size_t size);
]]

ffi.cdef[[
/* the kind of data that is passed to information_callback*/
typedef enum {
  CURLINFO_TEXT = 0,
  CURLINFO_HEADER_IN,    /* 1 */
  CURLINFO_HEADER_OUT,   /* 2 */
  CURLINFO_DATA_IN,      /* 3 */
  CURLINFO_DATA_OUT,     /* 4 */
  CURLINFO_SSL_DATA_IN,  /* 5 */
  CURLINFO_SSL_DATA_OUT, /* 6 */
  CURLINFO_END
} curl_infotype;
]]

ffi.cdef[[
typedef int (*curl_debug_callback)
       (CURL *handle,      /* the handle/transfer this concerns */
        curl_infotype type, /* what kind of data */
        char *data,        /* points to the data */
        size_t size,       /* size of the data pointed to */
        void *userptr)    /* whatever the user please */
]]

ffi.cdef[[
typedef enum {
  CURLE_OK = 0,
  CURLE_UNSUPPORTED_PROTOCOL,    /* 1 */
  CURLE_FAILED_INIT,             /* 2 */
  CURLE_URL_MALFORMAT,           /* 3 */
  CURLE_NOT_BUILT_IN,            /* 4 - [was obsoleted in August 2007 for
                                    7.17.0, reused in April 2011 for 7.21.5] */
  CURLE_COULDNT_RESOLVE_PROXY,   /* 5 */
  CURLE_COULDNT_RESOLVE_HOST,    /* 6 */
  CURLE_COULDNT_CONNECT,         /* 7 */
  CURLE_FTP_WEIRD_SERVER_REPLY,  /* 8 */
  CURLE_REMOTE_ACCESS_DENIED,    /* 9 a service was denied by the server
                                    due to lack of access - when login fails
                                    this is not returned. */
  CURLE_FTP_ACCEPT_FAILED,       /* 10 - [was obsoleted in April 2006 for
                                    7.15.4, reused in Dec 2011 for 7.24.0]*/
  CURLE_FTP_WEIRD_PASS_REPLY,    /* 11 */
  CURLE_FTP_ACCEPT_TIMEOUT,      /* 12 - timeout occurred accepting server
                                    [was obsoleted in August 2007 for 7.17.0,
                                    reused in Dec 2011 for 7.24.0]*/
  CURLE_FTP_WEIRD_PASV_REPLY,    /* 13 */
  CURLE_FTP_WEIRD_227_FORMAT,    /* 14 */
  CURLE_FTP_CANT_GET_HOST,       /* 15 */
  CURLE_HTTP2,                   /* 16 - A problem in the http2 framing layer.
                                    [was obsoleted in August 2007 for 7.17.0,
                                    reused in July 2014 for 7.38.0] */
  CURLE_FTP_COULDNT_SET_TYPE,    /* 17 */
  CURLE_PARTIAL_FILE,            /* 18 */
  CURLE_FTP_COULDNT_RETR_FILE,   /* 19 */
  CURLE_OBSOLETE20,              /* 20 - NOT USED */
  CURLE_QUOTE_ERROR,             /* 21 - quote command failure */
  CURLE_HTTP_RETURNED_ERROR,     /* 22 */
  CURLE_WRITE_ERROR,             /* 23 */
  CURLE_OBSOLETE24,              /* 24 - NOT USED */
  CURLE_UPLOAD_FAILED,           /* 25 - failed upload "command" */
  CURLE_READ_ERROR,              /* 26 - couldn't open/read from file */
  CURLE_OUT_OF_MEMORY,           /* 27 */
  /* Note: CURLE_OUT_OF_MEMORY may sometimes indicate a conversion error
           instead of a memory allocation error if CURL_DOES_CONVERSIONS
           is defined
  */
  CURLE_OPERATION_TIMEDOUT,      /* 28 - the timeout time was reached */
  CURLE_OBSOLETE29,              /* 29 - NOT USED */
  CURLE_FTP_PORT_FAILED,         /* 30 - FTP PORT operation failed */
  CURLE_FTP_COULDNT_USE_REST,    /* 31 - the REST command failed */
  CURLE_OBSOLETE32,              /* 32 - NOT USED */
  CURLE_RANGE_ERROR,             /* 33 - RANGE "command" didn't work */
  CURLE_HTTP_POST_ERROR,         /* 34 */
  CURLE_SSL_CONNECT_ERROR,       /* 35 - wrong when connecting with SSL */
  CURLE_BAD_DOWNLOAD_RESUME,     /* 36 - couldn't resume download */
  CURLE_FILE_COULDNT_READ_FILE,  /* 37 */
  CURLE_LDAP_CANNOT_BIND,        /* 38 */
  CURLE_LDAP_SEARCH_FAILED,      /* 39 */
  CURLE_OBSOLETE40,              /* 40 - NOT USED */
  CURLE_FUNCTION_NOT_FOUND,      /* 41 */
  CURLE_ABORTED_BY_CALLBACK,     /* 42 */
  CURLE_BAD_FUNCTION_ARGUMENT,   /* 43 */
  CURLE_OBSOLETE44,              /* 44 - NOT USED */
  CURLE_INTERFACE_FAILED,        /* 45 - CURLOPT_INTERFACE failed */
  CURLE_OBSOLETE46,              /* 46 - NOT USED */
  CURLE_TOO_MANY_REDIRECTS ,     /* 47 - catch endless re-direct loops */
  CURLE_UNKNOWN_OPTION,          /* 48 - User specified an unknown option */
  CURLE_TELNET_OPTION_SYNTAX ,   /* 49 - Malformed telnet option */
  CURLE_OBSOLETE50,              /* 50 - NOT USED */
  CURLE_PEER_FAILED_VERIFICATION, /* 51 - peer's certificate or fingerprint
                                     wasn't verified fine */
  CURLE_GOT_NOTHING,             /* 52 - when this is a specific error */
  CURLE_SSL_ENGINE_NOTFOUND,     /* 53 - SSL crypto engine not found */
  CURLE_SSL_ENGINE_SETFAILED,    /* 54 - can not set SSL crypto engine as
                                    default */
  CURLE_SEND_ERROR,              /* 55 - failed sending network data */
  CURLE_RECV_ERROR,              /* 56 - failure in receiving network data */
  CURLE_OBSOLETE57,              /* 57 - NOT IN USE */
  CURLE_SSL_CERTPROBLEM,         /* 58 - problem with the local certificate */
  CURLE_SSL_CIPHER,              /* 59 - couldn't use specified cipher */
  CURLE_SSL_CACERT,              /* 60 - problem with the CA cert (path?); */
  CURLE_BAD_CONTENT_ENCODING,    /* 61 - Unrecognized/bad encoding */
  CURLE_LDAP_INVALID_URL,        /* 62 - Invalid LDAP URL */
  CURLE_FILESIZE_EXCEEDED,       /* 63 - Maximum file size exceeded */
  CURLE_USE_SSL_FAILED,          /* 64 - Requested FTP SSL level failed */
  CURLE_SEND_FAIL_REWIND,        /* 65 - Sending the data requires a rewind
                                    that failed */
  CURLE_SSL_ENGINE_INITFAILED,   /* 66 - failed to initialise ENGINE */
  CURLE_LOGIN_DENIED,            /* 67 - user, password or similar was not
                                    accepted and we failed to login */
  CURLE_TFTP_NOTFOUND,           /* 68 - file not found on server */
  CURLE_TFTP_PERM,               /* 69 - permission problem on server */
  CURLE_REMOTE_DISK_FULL,        /* 70 - out of disk space on server */
  CURLE_TFTP_ILLEGAL,            /* 71 - Illegal TFTP operation */
  CURLE_TFTP_UNKNOWNID,          /* 72 - Unknown transfer ID */
  CURLE_REMOTE_FILE_EXISTS,      /* 73 - File already exists */
  CURLE_TFTP_NOSUCHUSER,         /* 74 - No such user */
  CURLE_CONV_FAILED,             /* 75 - conversion failed */
  CURLE_CONV_REQD,               /* 76 - caller must register conversion
                                    callbacks using curl_easy_setopt options
                                    CURLOPT_CONV_FROM_NETWORK_FUNCTION,
                                    CURLOPT_CONV_TO_NETWORK_FUNCTION, and
                                    CURLOPT_CONV_FROM_UTF8_FUNCTION */
  CURLE_SSL_CACERT_BADFILE,      /* 77 - could not load CACERT file, missing
                                    or wrong format */
  CURLE_REMOTE_FILE_NOT_FOUND,   /* 78 - remote file not found */
  CURLE_SSH,                     /* 79 - error from the SSH layer, somewhat
                                    generic so the error message will be of
                                    interest when this has happened */

  CURLE_SSL_SHUTDOWN_FAILED,     /* 80 - Failed to shut down the SSL
                                    connection */
  CURLE_AGAIN,                   /* 81 - socket is not ready for send/recv,
                                    wait till it's ready and try again (Added
                                    in 7.18.2); */
  CURLE_SSL_CRL_BADFILE,         /* 82 - could not load CRL file, missing or
                                    wrong format (Added in 7.19.0); */
  CURLE_SSL_ISSUER_ERROR,        /* 83 - Issuer check failed.  (Added in
                                    7.19.0); */
  CURLE_FTP_PRET_FAILED,         /* 84 - a PRET command failed */
  CURLE_RTSP_CSEQ_ERROR,         /* 85 - mismatch of RTSP CSeq numbers */
  CURLE_RTSP_SESSION_ERROR,      /* 86 - mismatch of RTSP Session Ids */
  CURLE_FTP_BAD_FILE_LIST,       /* 87 - unable to parse FTP file list */
  CURLE_CHUNK_FAILED,            /* 88 - chunk callback reported error */
  CURLE_NO_CONNECTION_AVAILABLE, /* 89 - No connection available, the
                                    session will be queued */
  CURLE_SSL_PINNEDPUBKEYNOTMATCH, /* 90 - specified pinned public key did not
                                     match */
  CURLE_SSL_INVALIDCERTSTATUS,   /* 91 - invalid certificate status */
  CURL_LAST /* never use! */
} CURLcode;
]]

--[[
#ifndef CURL_NO_OLDIES /* define this to test if your app builds with all
                          the obsolete stuff removed! */

/* Previously obsolete error code re-used in 7.38.0 */
CURLE_OBSOLETE16 CURLE_HTTP2

/* Previously obsolete error codes re-used in 7.24.0 */
CURLE_OBSOLETE10 CURLE_FTP_ACCEPT_FAILED
CURLE_OBSOLETE12 CURLE_FTP_ACCEPT_TIMEOUT

/*  compatibility with older names */
CURLOPT_ENCODING CURLOPT_ACCEPT_ENCODING

/* The following were added in 7.21.5, April 2011 */
CURLE_UNKNOWN_TELNET_OPTION CURLE_UNKNOWN_OPTION

/* The following were added in 7.17.1 */
/* These are scheduled to disappear by 2009 */
CURLE_SSL_PEER_CERTIFICATE CURLE_PEER_FAILED_VERIFICATION

/* The following were added in 7.17.0 */
/* These are scheduled to disappear by 2009 */
CURLE_OBSOLETE CURLE_OBSOLETE50 /* no one should be using this! */
CURLE_BAD_PASSWORD_ENTERED CURLE_OBSOLETE46
CURLE_BAD_CALLING_ORDER CURLE_OBSOLETE44
CURLE_FTP_USER_PASSWORD_INCORRECT CURLE_OBSOLETE10
CURLE_FTP_CANT_RECONNECT CURLE_OBSOLETE16
CURLE_FTP_COULDNT_GET_SIZE CURLE_OBSOLETE32
CURLE_FTP_COULDNT_SET_ASCII CURLE_OBSOLETE29
CURLE_FTP_WEIRD_USER_REPLY CURLE_OBSOLETE12
CURLE_FTP_WRITE_ERROR CURLE_OBSOLETE20
CURLE_LIBRARY_NOT_FOUND CURLE_OBSOLETE40
CURLE_MALFORMAT_USER CURLE_OBSOLETE24
CURLE_SHARE_IN_USE CURLE_OBSOLETE57
CURLE_URL_MALFORMAT_USER CURLE_NOT_BUILT_IN

CURLE_FTP_ACCESS_DENIED CURLE_REMOTE_ACCESS_DENIED
CURLE_FTP_COULDNT_SET_BINARY CURLE_FTP_COULDNT_SET_TYPE
CURLE_FTP_QUOTE_ERROR CURLE_QUOTE_ERROR
CURLE_TFTP_DISKFULL CURLE_REMOTE_DISK_FULL
CURLE_TFTP_EXISTS CURLE_REMOTE_FILE_EXISTS
CURLE_HTTP_RANGE_ERROR CURLE_RANGE_ERROR
CURLE_FTP_SSL_FAILED CURLE_USE_SSL_FAILED



/* The following were added earlier */

CURLE_OPERATION_TIMEOUTED CURLE_OPERATION_TIMEDOUT

CURLE_HTTP_NOT_FOUND CURLE_HTTP_RETURNED_ERROR
CURLE_HTTP_PORT_FAILED CURLE_INTERFACE_FAILED
CURLE_FTP_COULDNT_STOR_FILE CURLE_UPLOAD_FAILED

CURLE_FTP_PARTIAL_FILE CURLE_PARTIAL_FILE
CURLE_FTP_BAD_DOWNLOAD_RESUME CURLE_BAD_DOWNLOAD_RESUME

/* This was the error code 50 in 7.7.3 and a few earlier versions, this
   is no longer used by libcurl but is instead #defined here only to not
   make programs break */
CURLE_ALREADY_COMPLETE 99999

/* Provide defines for really old option names */
CURLOPT_FILE CURLOPT_WRITEDATA /* name changed in 7.9.7 */
CURLOPT_INFILE CURLOPT_READDATA /* name changed in 7.9.7 */
CURLOPT_WRITEHEADER CURLOPT_HEADERDATA

/* Since long deprecated options with no code in the lib that does anything
   with them. */
CURLOPT_WRITEINFO CURLOPT_OBSOLETE40
CURLOPT_CLOSEPOLICY CURLOPT_OBSOLETE72

#endif /*!CURL_NO_OLDIES*/
--]]

ffi.cdef[[
/* This prototype applies to all conversion callbacks */
typedef CURLcode (*curl_conv_callback)(char *buffer, size_t length);

typedef CURLcode (*curl_ssl_ctx_callback)(CURL *curl,    /* easy handle */
                                          void *ssl_ctx, /* actually an
                                                            OpenSSL SSL_CTX */
                                          void *userptr);
]]

ffi.cdef[[
typedef enum {
  CURLPROXY_HTTP = 0,   /* added in 7.10, new in 7.19.4 default is to use
                           CONNECT HTTP/1.1 */
  CURLPROXY_HTTP_1_0 = 1,   /* added in 7.19.4, force to use CONNECT
                               HTTP/1.0  */
  CURLPROXY_SOCKS4 = 4, /* support added in 7.15.2, enum existed already
                           in 7.10 */
  CURLPROXY_SOCKS5 = 5, /* added in 7.10 */
  CURLPROXY_SOCKS4A = 6, /* added in 7.18.0 */
  CURLPROXY_SOCKS5_HOSTNAME = 7 /* Use the SOCKS5 protocol but pass along the
                                   host name rather than the IP address. added
                                   in 7.18.0 */
} curl_proxytype;  /* this enum was added in 7.10 */
]]

ffi.cdef[[


static const int CURLAUTH_NONE         =((unsigned long)0);
static const int CURLAUTH_BASIC        =(((unsigned long)1)<<0);
static const int CURLAUTH_DIGEST       =(((unsigned long)1)<<1);
static const int CURLAUTH_NEGOTIATE    =(((unsigned long)1)<<2);
/* Deprecated since the advent of CURLAUTH_NEGOTIATE */
static const int CURLAUTH_GSSNEGOTIATE =CURLAUTH_NEGOTIATE;
static const int CURLAUTH_NTLM         =(((unsigned long)1)<<3);
static const int CURLAUTH_DIGEST_IE    =(((unsigned long)1)<<4);
static const int CURLAUTH_NTLM_WB      =(((unsigned long)1)<<5);
static const int CURLAUTH_ONLY         =(((unsigned long)1)<<31);
static const int CURLAUTH_ANY          =(~CURLAUTH_DIGEST_IE);
static const int CURLAUTH_ANYSAFE      =(~(CURLAUTH_BASIC|CURLAUTH_DIGEST_IE));

static const int CURLSSH_AUTH_ANY       =~0;     /* all types supported by the server */
static const int CURLSSH_AUTH_NONE      =0;      /* none allowed, silly but complete */
static const int CURLSSH_AUTH_PUBLICKEY =(1<<0); /* public/private key files */
static const int CURLSSH_AUTH_PASSWORD  =(1<<1); /* password */
static const int CURLSSH_AUTH_HOST      =(1<<2); /* host key files */
static const int CURLSSH_AUTH_KEYBOARD  =(1<<3); /* keyboard interactive */
static const int CURLSSH_AUTH_AGENT     =(1<<4); /* agent (ssh-agent, pageant...) */
static const int CURLSSH_AUTH_DEFAULT =CURLSSH_AUTH_ANY;

static const int CURLGSSAPI_DELEGATION_NONE        =0;      /* no delegation (default) */
static const int CURLGSSAPI_DELEGATION_POLICY_FLAG =(1<<0); /* if permitted by policy */
static const int CURLGSSAPI_DELEGATION_FLAG        =(1<<1); /* delegate always */

static const int CURL_ERROR_SIZE =256;
]]

ffi.cdef[[
enum curl_khtype {
  CURLKHTYPE_UNKNOWN,
  CURLKHTYPE_RSA1,
  CURLKHTYPE_RSA,
  CURLKHTYPE_DSS
};

struct curl_khkey {
  const char *key; /* points to a zero-terminated string encoded with base64
                      if len is zero, otherwise to the "raw" data */
  size_t len;
  enum curl_khtype keytype;
};

/* this is the set of return values expected from the curl_sshkeycallback
   callback */
enum curl_khstat {
  CURLKHSTAT_FINE_ADD_TO_FILE,
  CURLKHSTAT_FINE,
  CURLKHSTAT_REJECT, /* reject the connection, return an error */
  CURLKHSTAT_DEFER,  /* do not accept it, but we can't answer right now so
                        this causes a CURLE_DEFER error but otherwise the
                        connection will be left intact etc */
  CURLKHSTAT_LAST    /* not for use, only a marker for last-in-list */
};

/* this is the set of status codes pass in to the callback */
enum curl_khmatch {
  CURLKHMATCH_OK,       /* match */
  CURLKHMATCH_MISMATCH, /* host found, key mismatch! */
  CURLKHMATCH_MISSING,  /* no matching host/key found */
  CURLKHMATCH_LAST      /* not for use, only a marker for last-in-list */
};

typedef int
  (*curl_sshkeycallback) (CURL *easy,     /* easy handle */
                          const struct curl_khkey *knownkey, /* known */
                          const struct curl_khkey *foundkey, /* found */
                          enum curl_khmatch, /* libcurl's view on the keys */
                          void *clientp); /* custom pointer passed from app */

/* parameter for the CURLOPT_USE_SSL option */
typedef enum {
  CURLUSESSL_NONE,    /* do not attempt to use SSL */
  CURLUSESSL_TRY,     /* try using SSL, proceed anyway otherwise */
  CURLUSESSL_CONTROL, /* SSL for the control connection or fail */
  CURLUSESSL_ALL,     /* SSL for all communication or fail */
  CURLUSESSL_LAST     /* not an option, never use */
} curl_usessl;
]]

ffi.cdef[[
/* Definition of bits for the CURLOPT_SSL_OPTIONS argument: */

static const int CURLSSLOPT_ALLOW_BEAST = (1<<0);
static const int CURLSSLOPT_NO_REVOKE = (1<<1);
]]

--[[
#ifndef CURL_NO_OLDIES /* define this to test if your app builds with all
                          the obsolete stuff removed! */

/* Backwards compatibility with older names */
/* These are scheduled to disappear by 2009 */

CURLFTPSSL_NONE CURLUSESSL_NONE
CURLFTPSSL_TRY CURLUSESSL_TRY
CURLFTPSSL_CONTROL CURLUSESSL_CONTROL
CURLFTPSSL_ALL CURLUSESSL_ALL
CURLFTPSSL_LAST CURLUSESSL_LAST
curl_ftpssl curl_usessl
#endif /*!CURL_NO_OLDIES*/
--]]

ffi.cdef[[
/* parameter for the CURLOPT_FTP_SSL_CCC option */
typedef enum {
  CURLFTPSSL_CCC_NONE,    /* do not send CCC */
  CURLFTPSSL_CCC_PASSIVE, /* Let the server initiate the shutdown */
  CURLFTPSSL_CCC_ACTIVE,  /* Initiate the shutdown */
  CURLFTPSSL_CCC_LAST     /* not an option, never use */
} curl_ftpccc;

/* parameter for the CURLOPT_FTPSSLAUTH option */
typedef enum {
  CURLFTPAUTH_DEFAULT, /* let libcurl decide */
  CURLFTPAUTH_SSL,     /* use "AUTH SSL" */
  CURLFTPAUTH_TLS,     /* use "AUTH TLS" */
  CURLFTPAUTH_LAST /* not an option, never use */
} curl_ftpauth;

/* parameter for the CURLOPT_FTP_CREATE_MISSING_DIRS option */
typedef enum {
  CURLFTP_CREATE_DIR_NONE,  /* do NOT create missing dirs! */
  CURLFTP_CREATE_DIR,       /* (FTP/SFTP); if CWD fails, try MKD and then CWD
                               again if MKD succeeded, for SFTP this does
                               similar magic */
  CURLFTP_CREATE_DIR_RETRY, /* (FTP only); if CWD fails, try MKD and then CWD
                               again even if MKD failed! */
  CURLFTP_CREATE_DIR_LAST   /* not an option, never use */
} curl_ftpcreatedir;

/* parameter for the CURLOPT_FTP_FILEMETHOD option */
typedef enum {
  CURLFTPMETHOD_DEFAULT,   /* let libcurl pick */
  CURLFTPMETHOD_MULTICWD,  /* single CWD operation for each path part */
  CURLFTPMETHOD_NOCWD,     /* no CWD at all */
  CURLFTPMETHOD_SINGLECWD, /* one CWD to full dir, then work on file */
  CURLFTPMETHOD_LAST       /* not an option, never use */
} curl_ftpmethod;
]]

ffi.cdef[[
/* bitmask defines for CURLOPT_HEADEROPT */
static const int CURLHEADER_UNIFIED  = 0;
static const int CURLHEADER_SEPARATE = (1<<0);

/* CURLPROTO_ defines are for the CURLOPT_*PROTOCOLS options */
static const int CURLPROTO_HTTP   = (1<<0);
static const int CURLPROTO_HTTPS  = (1<<1);
static const int CURLPROTO_FTP    = (1<<2);
static const int CURLPROTO_FTPS   = (1<<3);
static const int CURLPROTO_SCP    = (1<<4);
static const int CURLPROTO_SFTP   = (1<<5);
static const int CURLPROTO_TELNET = (1<<6);
static const int CURLPROTO_LDAP   = (1<<7);
static const int CURLPROTO_LDAPS  = (1<<8);
static const int CURLPROTO_DICT   = (1<<9);
static const int CURLPROTO_FILE   = (1<<10);
static const int CURLPROTO_TFTP   = (1<<11);
static const int CURLPROTO_IMAP   = (1<<12);
static const int CURLPROTO_IMAPS  = (1<<13);
static const int CURLPROTO_POP3   = (1<<14);
static const int CURLPROTO_POP3S  = (1<<15);
static const int CURLPROTO_SMTP   = (1<<16);
static const int CURLPROTO_SMTPS  = (1<<17);
static const int CURLPROTO_RTSP   = (1<<18);
static const int CURLPROTO_RTMP   = (1<<19);
static const int CURLPROTO_RTMPT  = (1<<20);
static const int CURLPROTO_RTMPE  = (1<<21);
static const int CURLPROTO_RTMPTE = (1<<22);
static const int CURLPROTO_RTMPS  = (1<<23);
static const int CURLPROTO_RTMPTS = (1<<24);
static const int CURLPROTO_GOPHER = (1<<25);
static const int CURLPROTO_SMB    = (1<<26);
static const int CURLPROTO_SMBS   = (1<<27);
static const int CURLPROTO_ALL    = (~0); /* enable everything */
]]

local CurlOptions = require("curlopt");


ffi.cdef[[
typedef enum {
  /* Below here follows defines for the CURLOPT_IPRESOLVE option. If a host
     name resolves addresses using more than one IP protocol version, this
     option might be handy to force libcurl to use a specific IP version. */
  CURL_IPRESOLVE_WHATEVER =0, /* default, resolves addresses to all IP
                                     versions that your system allows */
  CURL_IPRESOLVE_V4       =1, /* resolve to IPv4 addresses */
  CURL_IPRESOLVE_V6       =2 /* resolve to IPv6 addresses */
};
]]

ffi.cdef[[
  /* three convenient "aliases" that follow the name scheme better */
static const int CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER;
]]

ffi.cdef[[
  /* These enums are for use with the CURLOPT_HTTP_VERSION option. */
enum {
  CURL_HTTP_VERSION_NONE, /* setting this means we don't care, and that we'd
                             like the library to choose the best possible
                             for us! */
  CURL_HTTP_VERSION_1_0,  /* please use HTTP 1.0 in the request */
  CURL_HTTP_VERSION_1_1,  /* please use HTTP 1.1 in the request */
  CURL_HTTP_VERSION_2_0,  /* please use HTTP 2.0 in the request */

  CURL_HTTP_VERSION_LAST /* *ILLEGAL* http version */
};
]]


ffi.cdef[[
/* Convenience definition simple because the name of the version is HTTP/2 and
   not 2.0. The 2_0 version of the enum name was set while the version was
   still planned to be 2.0 and we stick to it for compatibility. */
static const int CURL_HTTP_VERSION_2 = CURL_HTTP_VERSION_2_0;
]]

ffi.cdef[[
/*
 * Public API enums for RTSP requests
 */
enum {
    CURL_RTSPREQ_NONE, /* first in list */
    CURL_RTSPREQ_OPTIONS,
    CURL_RTSPREQ_DESCRIBE,
    CURL_RTSPREQ_ANNOUNCE,
    CURL_RTSPREQ_SETUP,
    CURL_RTSPREQ_PLAY,
    CURL_RTSPREQ_PAUSE,
    CURL_RTSPREQ_TEARDOWN,
    CURL_RTSPREQ_GET_PARAMETER,
    CURL_RTSPREQ_SET_PARAMETER,
    CURL_RTSPREQ_RECORD,
    CURL_RTSPREQ_RECEIVE,
    CURL_RTSPREQ_LAST /* last in list */
};
]]

ffi.cdef[[
  /* These enums are for use with the CURLOPT_NETRC option. */
enum CURL_NETRC_OPTION {
  CURL_NETRC_IGNORED,     /* The .netrc will never be read.
                           * This is the default. */
  CURL_NETRC_OPTIONAL,    /* A user:password in the URL will be preferred
                           * to one in the .netrc. */
  CURL_NETRC_REQUIRED,    /* A user:password in the URL will be ignored.
                           * Unless one is set programmatically, the .netrc
                           * will be queried. */
  CURL_NETRC_LAST
};

enum {
  CURL_SSLVERSION_DEFAULT,
  CURL_SSLVERSION_TLSv1, /* TLS 1.x */
  CURL_SSLVERSION_SSLv2,
  CURL_SSLVERSION_SSLv3,
  CURL_SSLVERSION_TLSv1_0,
  CURL_SSLVERSION_TLSv1_1,
  CURL_SSLVERSION_TLSv1_2,

  CURL_SSLVERSION_LAST /* never use, keep last */
};

enum CURL_TLSAUTH {
  CURL_TLSAUTH_NONE,
  CURL_TLSAUTH_SRP,
  CURL_TLSAUTH_LAST /* never use, keep last */
};
]]

ffi.cdef[[
/* symbols to use with CURLOPT_POSTREDIR.
   CURL_REDIR_POST_301, CURL_REDIR_POST_302 and CURL_REDIR_POST_303
   can be bitwise ORed so that CURL_REDIR_POST_301 | CURL_REDIR_POST_302
   | CURL_REDIR_POST_303 == CURL_REDIR_POST_ALL */

static const int CURL_REDIR_GET_ALL  = 0;
static const int CURL_REDIR_POST_301 = 1;
static const int CURL_REDIR_POST_302 = 2;
static const int CURL_REDIR_POST_303 = 4;
static const int CURL_REDIR_POST_ALL = (CURL_REDIR_POST_301|CURL_REDIR_POST_302|CURL_REDIR_POST_303);
]]

ffi.cdef[[
typedef enum {
  CURL_TIMECOND_NONE,

  CURL_TIMECOND_IFMODSINCE,
  CURL_TIMECOND_IFUNMODSINCE,
  CURL_TIMECOND_LASTMOD,

  CURL_TIMECOND_LAST
} curl_TimeCond;
]]

--[[
/* curl_strequal(); and curl_strnequal(); are subject for removal in a future
   libcurl, see lib/README.curlx for details */
int (curl_strequal)(const char *s1, const char *s2);
int (curl_strnequal)(const char *s1, const char *s2, size_t n);
--]]

ffi.cdef[[

typedef enum {
  CURLFORM_NOTHING,        /********* the first one is unused ************/

  /*  */
  CURLFORM_COPYNAME,
  CURLFORM_PTRNAME,
  CURLFORM_NAMELENGTH,
  CURLFORM_COPYCONTENTS,
  CURLFORM_PTRCONTENTS,
  CURLFORM_CONTENTSLENGTH,
  CURLFORM_FILECONTENT,
  CURLFORM_ARRAY,
  CURLFORM_OBSOLETE,
  CURLFORM_FILE,

  CURLFORM_BUFFER,
  CURLFORM_BUFFERPTR,
  CURLFORM_BUFFERLENGTH,

  CURLFORM_CONTENTTYPE,
  CURLFORM_CONTENTHEADER,
  CURLFORM_FILENAME,
  CURLFORM_END,
  CURLFORM_OBSOLETE2,

  CURLFORM_STREAM,
  CURLFORM_CONTENTLEN, /* added in 7.46.0, provide a curl_off_t length */

  CURLFORM_LASTENTRY /* the last unused */
} CURLformoption;

]]

ffi.cdef[[
/* structure to be used as parameter for CURLFORM_ARRAY */
struct curl_forms {
  CURLformoption option;
  const char     *value;
};
]]

ffi.cdef[[
/* use this for multipart formpost building */
/* Returns code for curl_formadd();
 *
 * Returns:
 * CURL_FORMADD_OK             on success
 * CURL_FORMADD_MEMORY         if the FormInfo allocation fails
 * CURL_FORMADD_OPTION_TWICE   if one option is given twice for one Form
 * CURL_FORMADD_NULL           if a null pointer was given for a char
 * CURL_FORMADD_MEMORY         if the allocation of a FormInfo struct failed
 * CURL_FORMADD_UNKNOWN_OPTION if an unknown option was used
 * CURL_FORMADD_INCOMPLETE     if the some FormInfo is not complete (or error);
 * CURL_FORMADD_MEMORY         if a curl_httppost struct cannot be allocated
 * CURL_FORMADD_MEMORY         if some allocation for string copying failed.
 * CURL_FORMADD_ILLEGAL_ARRAY  if an illegal option is used in an array
 *
 ***************************************************************************/
typedef enum {
  CURL_FORMADD_OK, /* first, no error */

  CURL_FORMADD_MEMORY,
  CURL_FORMADD_OPTION_TWICE,
  CURL_FORMADD_NULL,
  CURL_FORMADD_UNKNOWN_OPTION,
  CURL_FORMADD_INCOMPLETE,
  CURL_FORMADD_ILLEGAL_ARRAY,
  CURL_FORMADD_DISABLED, /* libcurl was built with this disabled */

  CURL_FORMADD_LAST /* last */
} CURLFORMcode;
]]

ffi.cdef[[
CURLFORMcode curl_formadd(struct curl_httppost **httppost,
                                      struct curl_httppost **last_post,
                                      ...);

typedef size_t (*curl_formget_callback)(void *arg, const char *buf,
                                        size_t len);

int curl_formget(struct curl_httppost *form, void *arg,
                             curl_formget_callback append);

void curl_formfree(struct curl_httppost *form);

]]


--[[
/*
 * NAME curl_getenv();
 *
 * DESCRIPTION
 *
 * Returns a malloc();'ed string that MUST be curl_free();ed after usage is
 * complete. DEPRECATED - see lib/README.curlx
 */
char *curl_getenv(const char *variable);
--]]

ffi.cdef[[

char *curl_version(void);

char *curl_easy_escape(CURL *handle,
                                   const char *string,
                                   int length);

char *curl_easy_unescape(CURL *handle,
                                     const char *string,
                                     int length,
                                     int *outlength);
]]

--[[
/* the previous version: */
char *curl_escape(const char *string,
                              int length);

/* the previous version */
char *curl_unescape(const char *string,
                                int length);
--]]

ffi.cdef[[

void curl_free(void *p);

CURLcode curl_global_init(long flags);

CURLcode curl_global_init_mem(long flags,
                                          curl_malloc_callback m,
                                          curl_free_callback f,
                                          curl_realloc_callback r,
                                          curl_strdup_callback s,
                                          curl_calloc_callback c);

void curl_global_cleanup(void);
]]

ffi.cdef[[
/* linked-list structure for the CURLOPT_QUOTE option (and other); */
struct curl_slist {
  char *data;
  struct curl_slist *next;
};

struct curl_slist *curl_slist_append(struct curl_slist *, const char *);

void curl_slist_free_all(struct curl_slist *);
]]

ffi.cdef[[

time_t curl_getdate(const char *p, const time_t *unused);
]]

ffi.cdef[[
/* info about the certificate chain, only for OpenSSL builds. Asked
   for with CURLOPT_CERTINFO / CURLINFO_CERTINFO */
struct curl_certinfo {
  int num_of_certs;             /* number of certificates with information */
  struct curl_slist **certinfo; /* for each index in this array, there's a
                                   linked list with textual information in the
                                   format "name: value" */
};

/* enum for the different supported SSL backends */
typedef enum {
  CURLSSLBACKEND_NONE = 0,
  CURLSSLBACKEND_OPENSSL = 1,
  CURLSSLBACKEND_GNUTLS = 2,
  CURLSSLBACKEND_NSS = 3,
  CURLSSLBACKEND_OBSOLETE4 = 4,  /* Was QSOSSL. */
  CURLSSLBACKEND_GSKIT = 5,
  CURLSSLBACKEND_POLARSSL = 6,
  CURLSSLBACKEND_CYASSL = 7,
  CURLSSLBACKEND_SCHANNEL = 8,
  CURLSSLBACKEND_DARWINSSL = 9,
  CURLSSLBACKEND_AXTLS = 10,
  CURLSSLBACKEND_MBEDTLS = 11
} curl_sslbackend;

/* Information about the SSL library used and the respective internal SSL
   handle, which can be used to obtain further information regarding the
   connection. Asked for with CURLINFO_TLS_SESSION. */
struct curl_tlssessioninfo {
  curl_sslbackend backend;
  void *internals;
};
]]

ffi.cdef[[
static const int CURLINFO_STRING   = 0x100000;
static const int CURLINFO_LONG     = 0x200000;
static const int CURLINFO_DOUBLE   = 0x300000;
static const int CURLINFO_SLIST    = 0x400000;
static const int CURLINFO_SOCKET   = 0x500000;
static const int CURLINFO_MASK     = 0x0fffff;
static const int CURLINFO_TYPEMASK = 0xf00000;

typedef enum {
  CURLINFO_NONE, /* first, never use this */
  CURLINFO_EFFECTIVE_URL    = CURLINFO_STRING + 1,
  CURLINFO_RESPONSE_CODE    = CURLINFO_LONG   + 2,
  CURLINFO_TOTAL_TIME       = CURLINFO_DOUBLE + 3,
  CURLINFO_NAMELOOKUP_TIME  = CURLINFO_DOUBLE + 4,
  CURLINFO_CONNECT_TIME     = CURLINFO_DOUBLE + 5,
  CURLINFO_PRETRANSFER_TIME = CURLINFO_DOUBLE + 6,
  CURLINFO_SIZE_UPLOAD      = CURLINFO_DOUBLE + 7,
  CURLINFO_SIZE_DOWNLOAD    = CURLINFO_DOUBLE + 8,
  CURLINFO_SPEED_DOWNLOAD   = CURLINFO_DOUBLE + 9,
  CURLINFO_SPEED_UPLOAD     = CURLINFO_DOUBLE + 10,
  CURLINFO_HEADER_SIZE      = CURLINFO_LONG   + 11,
  CURLINFO_REQUEST_SIZE     = CURLINFO_LONG   + 12,
  CURLINFO_SSL_VERIFYRESULT = CURLINFO_LONG   + 13,
  CURLINFO_FILETIME         = CURLINFO_LONG   + 14,
  CURLINFO_CONTENT_LENGTH_DOWNLOAD   = CURLINFO_DOUBLE + 15,
  CURLINFO_CONTENT_LENGTH_UPLOAD     = CURLINFO_DOUBLE + 16,
  CURLINFO_STARTTRANSFER_TIME = CURLINFO_DOUBLE + 17,
  CURLINFO_CONTENT_TYPE     = CURLINFO_STRING + 18,
  CURLINFO_REDIRECT_TIME    = CURLINFO_DOUBLE + 19,
  CURLINFO_REDIRECT_COUNT   = CURLINFO_LONG   + 20,
  CURLINFO_PRIVATE          = CURLINFO_STRING + 21,
  CURLINFO_HTTP_CONNECTCODE = CURLINFO_LONG   + 22,
  CURLINFO_HTTPAUTH_AVAIL   = CURLINFO_LONG   + 23,
  CURLINFO_PROXYAUTH_AVAIL  = CURLINFO_LONG   + 24,
  CURLINFO_OS_ERRNO         = CURLINFO_LONG   + 25,
  CURLINFO_NUM_CONNECTS     = CURLINFO_LONG   + 26,
  CURLINFO_SSL_ENGINES      = CURLINFO_SLIST  + 27,
  CURLINFO_COOKIELIST       = CURLINFO_SLIST  + 28,
  CURLINFO_LASTSOCKET       = CURLINFO_LONG   + 29,
  CURLINFO_FTP_ENTRY_PATH   = CURLINFO_STRING + 30,
  CURLINFO_REDIRECT_URL     = CURLINFO_STRING + 31,
  CURLINFO_PRIMARY_IP       = CURLINFO_STRING + 32,
  CURLINFO_APPCONNECT_TIME  = CURLINFO_DOUBLE + 33,
  CURLINFO_CERTINFO         = CURLINFO_SLIST  + 34,
  CURLINFO_CONDITION_UNMET  = CURLINFO_LONG   + 35,
  CURLINFO_RTSP_SESSION_ID  = CURLINFO_STRING + 36,
  CURLINFO_RTSP_CLIENT_CSEQ = CURLINFO_LONG   + 37,
  CURLINFO_RTSP_SERVER_CSEQ = CURLINFO_LONG   + 38,
  CURLINFO_RTSP_CSEQ_RECV   = CURLINFO_LONG   + 39,
  CURLINFO_PRIMARY_PORT     = CURLINFO_LONG   + 40,
  CURLINFO_LOCAL_IP         = CURLINFO_STRING + 41,
  CURLINFO_LOCAL_PORT       = CURLINFO_LONG   + 42,
  CURLINFO_TLS_SESSION      = CURLINFO_SLIST  + 43,
  CURLINFO_ACTIVESOCKET     = CURLINFO_SOCKET + 44,
  /* Fill in new entries below here! */

  CURLINFO_LASTONE          = 44
} CURLINFO;

/* CURLINFO_RESPONSE_CODE is the new name for the option previously known as
   CURLINFO_HTTP_CODE */
static const int CURLINFO_HTTP_CODE = CURLINFO_RESPONSE_CODE;
]]

ffi.cdef[[
typedef enum {
  CURLCLOSEPOLICY_NONE, /* first, never use this */

  CURLCLOSEPOLICY_OLDEST,
  CURLCLOSEPOLICY_LEAST_RECENTLY_USED,
  CURLCLOSEPOLICY_LEAST_TRAFFIC,
  CURLCLOSEPOLICY_SLOWEST,
  CURLCLOSEPOLICY_CALLBACK,

  CURLCLOSEPOLICY_LAST /* last, never use this */
} curl_closepolicy;
]]

ffi.cdef[[
static const int CURL_GLOBAL_SSL =(1<<0);
static const int CURL_GLOBAL_WIN32 =(1<<1);
static const int CURL_GLOBAL_ALL =(CURL_GLOBAL_SSL|CURL_GLOBAL_WIN32);
static const int CURL_GLOBAL_NOTHING =0;
static const int CURL_GLOBAL_DEFAULT =CURL_GLOBAL_ALL;
static const int CURL_GLOBAL_ACK_EINTR =(1<<2);
]]

ffi.cdef[[
/*****************************************************************************
 * Setup defines, protos etc for the sharing stuff.
 */

/* Different data locks for a single share */
typedef enum {
  CURL_LOCK_DATA_NONE = 0,
  /*  CURL_LOCK_DATA_SHARE is used internally to say that
   *  the locking is just made to change the internal state of the share
   *  itself.
   */
  CURL_LOCK_DATA_SHARE,
  CURL_LOCK_DATA_COOKIE,
  CURL_LOCK_DATA_DNS,
  CURL_LOCK_DATA_SSL_SESSION,
  CURL_LOCK_DATA_CONNECT,
  CURL_LOCK_DATA_LAST
} curl_lock_data;

/* Different lock access types */
typedef enum {
  CURL_LOCK_ACCESS_NONE = 0,   /* unspecified action */
  CURL_LOCK_ACCESS_SHARED = 1, /* for read perhaps */
  CURL_LOCK_ACCESS_SINGLE = 2, /* for write perhaps */
  CURL_LOCK_ACCESS_LAST        /* never use */
} curl_lock_access;

typedef void (*curl_lock_function)(CURL *handle,
                                   curl_lock_data data,
                                   curl_lock_access locktype,
                                   void *userptr);
typedef void (*curl_unlock_function)(CURL *handle,
                                     curl_lock_data data,
                                     void *userptr);
]]

ffi.cdef[[
typedef void CURLSH;

typedef enum {
  CURLSHE_OK,  /* all is fine */
  CURLSHE_BAD_OPTION, /* 1 */
  CURLSHE_IN_USE,     /* 2 */
  CURLSHE_INVALID,    /* 3 */
  CURLSHE_NOMEM,      /* 4 out of memory */
  CURLSHE_NOT_BUILT_IN, /* 5 feature not present in lib */
  CURLSHE_LAST        /* never use */
} CURLSHcode;


typedef enum {
  CURLSHOPT_NONE,  /* don't use */
  CURLSHOPT_SHARE,   /* specify a data type to share */
  CURLSHOPT_UNSHARE, /* specify which data type to stop sharing */
  CURLSHOPT_LOCKFUNC,   /* pass in a 'curl_lock_function' pointer */
  CURLSHOPT_UNLOCKFUNC, /* pass in a 'curl_unlock_function' pointer */
  CURLSHOPT_USERDATA,   /* pass in a user data pointer used in the lock/unlock
                           callback functions */
  CURLSHOPT_LAST  /* never use */
} CURLSHoption;
]]

ffi.cdef[[
CURLSH *curl_share_init(void);
CURLSHcode curl_share_setopt(CURLSH *, CURLSHoption option, ...);
CURLSHcode curl_share_cleanup(CURLSH *);
]]

ffi.cdef[[
/****************************************************************************
 * Structures for querying information about the curl library at runtime.
 */

typedef enum {
  CURLVERSION_FIRST,
  CURLVERSION_SECOND,
  CURLVERSION_THIRD,
  CURLVERSION_FOURTH,
  CURLVERSION_LAST /* never actually use this */
} CURLversion;

static const int CURLVERSION_NOW  = CURLVERSION_FOURTH;

]]


ffi.cdef[[
typedef struct {
  CURLversion age;          /* age of the returned struct */
  const char *version;      /* LIBCURL_VERSION */
  unsigned int version_num; /* LIBCURL_VERSION_NUM */
  const char *host;         /* OS/host/cpu/machine when configured */
  int features;             /* bitmask, see defines below */
  const char *ssl_version;  /* human readable string */
  long ssl_version_num;     /* not used anymore, always 0 */
  const char *libz_version; /* human readable string */
  /* protocols is terminated by an entry with a NULL protoname */
  const char * const *protocols;

  /* The fields below this were added in CURLVERSION_SECOND */
  const char *ares;
  int ares_num;

  /* This field was added in CURLVERSION_THIRD */
  const char *libidn;

  /* These field were added in CURLVERSION_FOURTH */

  /* Same as '_libiconv_version' if built with HAVE_ICONV */
  int iconv_ver_num;

  const char *libssh_version; /* human readable string */

} curl_version_info_data;
]]

ffi.cdef[[
static const int CURL_VERSION_IPV6         =(1<<0);  /* IPv6-enabled */
static const int CURL_VERSION_KERBEROS4    =(1<<1);  /* Kerberos V4 auth is supported
                                             (deprecated); */
static const int CURL_VERSION_SSL          =(1<<2);  /* SSL options are present */
static const int CURL_VERSION_LIBZ         =(1<<3);  /* libz features are present */
static const int CURL_VERSION_NTLM         =(1<<4);  /* NTLM auth is supported */
static const int CURL_VERSION_GSSNEGOTIATE =(1<<5);  /* Negotiate auth is supported
                                             (deprecated); */
static const int CURL_VERSION_DEBUG        =(1<<6);  /* Built with debug capabilities */
static const int CURL_VERSION_ASYNCHDNS    =(1<<7);  /* Asynchronous DNS resolves */
static const int CURL_VERSION_SPNEGO       =(1<<8);  /* SPNEGO auth is supported */
static const int CURL_VERSION_LARGEFILE    =(1<<9);  /* Supports files larger than 2GB */
static const int CURL_VERSION_IDN          =(1<<10); /* Internationized Domain Names are
                                             supported */
static const int CURL_VERSION_SSPI         =(1<<11); /* Built against Windows SSPI */
static const int CURL_VERSION_CONV         =(1<<12); /* Character conversions supported */
static const int CURL_VERSION_CURLDEBUG    =(1<<13); /* Debug memory tracking supported */
static const int CURL_VERSION_TLSAUTH_SRP  =(1<<14); /* TLS-SRP auth is supported */
static const int CURL_VERSION_NTLM_WB      =(1<<15); /* NTLM delegation to winbind helper
                                             is suported */
static const int CURL_VERSION_HTTP2        =(1<<16); /* HTTP2 support built-in */
static const int CURL_VERSION_GSSAPI       =(1<<17); /* Built against a GSS-API library */
static const int CURL_VERSION_KERBEROS5    =(1<<18); /* Kerberos V5 auth is supported */
static const int CURL_VERSION_UNIX_SOCKETS =(1<<19); /* Unix domain sockets support */
]]

ffi.cdef[[
curl_version_info_data *curl_version_info(CURLversion);


const char *curl_easy_strerror(CURLcode);


const char *curl_share_strerror(CURLSHcode);


CURLcode curl_easy_pause(CURL *handle, int bitmask);
]]

ffi.cdef[[
static const int CURLPAUSE_RECV      =(1<<0);
static const int CURLPAUSE_RECV_CONT =(0);

static const int CURLPAUSE_SEND      =(1<<2);
static const int CURLPAUSE_SEND_CONT =(0);

static const int CURLPAUSE_ALL       =(CURLPAUSE_RECV|CURLPAUSE_SEND);
static const int CURLPAUSE_CONT      =(CURLPAUSE_RECV_CONT|CURLPAUSE_SEND_CONT);
]]


--[[
  This is the "Easy" interface
--]]
ffi.cdef[[
CURL *curl_easy_init(void);
CURLcode curl_easy_setopt(CURL *curl, CURLoption option, ...);
CURLcode curl_easy_perform(CURL *curl);
void curl_easy_cleanup(CURL *curl);


CURLcode curl_easy_getinfo(CURL *curl, CURLINFO info, ...);

CURL* curl_easy_duphandle(CURL *curl);

void curl_easy_reset(CURL *curl);

CURLcode curl_easy_recv(CURL *curl, void *buffer, size_t buflen,
                                    size_t *n);

CURLcode curl_easy_send(CURL *curl, const void *buffer,
                                    size_t buflen, size_t *n);
]]


require ("multi_ffi")



local Lib_curl = ffi.load("curl");

return Lib_curl
