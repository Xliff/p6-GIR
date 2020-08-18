use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GIR::Raw::Enums;

use GLib::Roles::Pointers;

unit package GIR::Raw::Structs;

# Number of times a forced rebuild has been made.
my constant forced = 15;

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

  method value(Int() $tag) {
    # See:
    # https://discourse.gnome.org/t/getting-the-proper-value-from-a-giconstantinfo-and-a-giargument/3713/4
    #
    # Thanks @ebassi!

    given GITypeTagEnum($tag) {
      when GI_TYPE_TAG_BOOLEAN   { $.v_boolean }
      when GI_TYPE_TAG_INT8      { $.v_int8    }
      when GI_TYPE_TAG_INT16     { $.v_int16   }
      when GI_TYPE_TAG_INT32     { $.v_int32   }
      when GI_TYPE_TAG_INT64     { $.v_int64   }
      when GI_TYPE_TAG_UINT8     { $.v_uint8   }
      when GI_TYPE_TAG_UINT16    { $.v_uint16  }
      when GI_TYPE_TAG_UINT32    { $.v_uint32  }
      when GI_TYPE_TAG_UINT64    { $.v_uint64  }
      when GI_TYPE_TAG_FLOAT     { $.v_float   }
      when GI_TYPE_TAG_DOUBLE    { $.v_double  }

      when GI_TYPE_TAG_UNICHAR   { $.v_string  }
      when GI_TYPE_TAG_UTF8      { $.v_string  }
      when GI_TYPE_TAG_FILENAME  { $.v_string  }

      when GI_TYPE_TAG_INTERFACE { $.v_pointer }
      when GI_TYPE_TAG_GLIST     { $.v_pointer }
      when GI_TYPE_TAG_GSLIST    { $.v_pointer }
      when GI_TYPE_TAG_GHASH     { $.v_pointer }
      when GI_TYPE_TAG_ERROR     { $.v_pointer }
    }
  }
}

class GIArgInfo            is repr<CPointer> does GLib::Roles::Pointers is export { }
class GICallableInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GICallbackInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIConstantInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIEnumInfo           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIFieldInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIFunctionInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIInterfaceInfo      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIObjectInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIPropertyInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIRegisteredTypeInfo is repr<CPointer> does GLib::Roles::Pointers is export { }
class GISignalInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIStructInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GITypeInfo           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIUnionInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIValueInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GIVFuncInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }

constant gir                  is export  = 'girepository-1.0',v1;

class GITypelib is repr<CPointer> does GLib::Roles::Pointers is export { }