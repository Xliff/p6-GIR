use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::FieldInfo;

### /usr/include/gobject-introspection-1.0/gifieldinfo.h

sub g_field_info_get_field (
  GIFieldInfo $field_info,
  gpointer $mem,
  GIArgument $value
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_field_info_get_flags (GIFieldInfo $info)
  returns GIFieldInfoFlags
  is native(gir)
  is export
{ * }

sub g_field_info_get_offset (GIFieldInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_field_info_get_size (GIFieldInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_field_info_get_type (GIFieldInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_field_info_set_field (
  GIFieldInfo $field_info,
  gpointer $mem,
  GIArgument $value
)
  returns uint32
  is native(gir)
  is export
{ * }
