use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::EnumInfo;

### /usr/include/gobject-introspection-1.0/gienuminfo.h

sub g_value_info_get_value (GIValueInfo $info)
  returns gint64
  is native(gir)
  is export
{ * }

sub g_enum_info_get_error_domain (GIEnumInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_enum_info_get_method (GIEnumInfo $info, gint $n)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_enum_info_get_n_methods (GIEnumInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_enum_info_get_n_values (GIEnumInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_enum_info_get_storage_type (GIEnumInfo $info)
  returns GITypeTag
  is native(gir)
  is export
{ * }

sub g_enum_info_get_value (GIEnumInfo $info, gint $n)
  returns GIValueInfo
  is native(gir)
  is export
{ * }
