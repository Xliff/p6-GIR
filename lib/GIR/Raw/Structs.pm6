use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GIR::Raw::Enums;

use GLib::Roles::Pointers;

unit package GIR::Raw::Structs;

class GIBaseInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has gint32   $!dummy1;
  has gint32   $!dummy2;
  has gpointer $!dummy3;
  has gpointer $!dummy4;
  has gpointer $!dummy5;
  has guint32  $!dummy6;
  has guint32  $!dummy7;
  HAS gpointer @!padding[4] is CArray;
}

class GIFunctionInvoker is repr<CStruct> does GLib::Roles::Pointers is export {
  has Pointer  $.cif;    #= ffi_cif cif;
  has gpointer $.native_address;
  has gpointer @.padding[3] is CArray;
}

class GIRepository is repr<CStruct> does GLib::Roles::Pointers is export {
  has GObject $!parent;
  has Pointer $!priv;    #= GIRepositoryPrivate *priv;
}

class GIAttributeIter is repr<CStruct> does GLib::Roles::Pointers is export {
  has gpointer $!data;
  has gpointer $!data2;
  has gpointer $!data3;
  has gpointer $!data4;
}

class GIArgument is repr<CUnion> does GLib::Roles::Pointers is export {
  has gboolean $.v_boolean;
  has gint8    $.v_int8;
  has guint8   $.v_uint8;
  has gint16   $.v_int16;
  has guint16  $.v_uint16;
  has gint32   $.v_int32;
  has guint32  $.v_uint32;
  has gint64   $.v_int64;
  has guint64  $.v_uint64;
  has gfloat   $.v_float;
  has gdouble  $.v_double;
  has gshort   $.v_short;
  has gushort  $.v_ushort;
  has gint     $.v_int;
  has guint    $.v_uint;
  has glong    $.v_long;
  has gulong   $.v_ulong;
  has gssize   $.v_ssize;
  has gsize    $.v_size;
  has Str      $.v_string;
  has gpointer $.v_pointer;
}

constant GIArgInfo            is export := GIBaseInfo;
constant GICallableInfo       is export := GIBaseInfo;
constant GICallbackInfo       is export := GIBaseInfo;
constant GIConstantInfo       is export := GIBaseInfo;
constant GIEnumInfo           is export := GIBaseInfo;
constant GIFieldInfo          is export := GIBaseInfo;
constant GIFunctionInfo       is export := GIBaseInfo;
constant GIInterfaceInfo      is export := GIBaseInfo;
constant GIObjectInfo         is export := GIBaseInfo;
constant GIPropertyInfo       is export := GIBaseInfo;
constant GIRegisteredTypeInfo is export := GIBaseInfo;
constant GISignalInfo         is export := GIBaseInfo;
constant GIStructInfo         is export := GIBaseInfo;
constant GITypeInfo           is export := GIBaseInfo;
constant GIUnionInfo          is export := GIBaseInfo;
constant GIValueInfo          is export := GIBaseInfo;
constant GIVFuncInfo          is export := GIBaseInfo;

constant gir                  is export  = 'girepository-1.0',v1;

class GITypelib is repr<CPointer> does GLib::Roles::Pointers is export { }
