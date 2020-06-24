use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::TypeInfo;


### /usr/include/gobject-introspection-1.0/gitypeinfo.h

sub g_info_type_to_string (GIInfoType $type)
  returns Str
  is native(gir)
  is export
{ * }

sub g_type_tag_to_string (GITypeTag $type)
  returns Str
  is native(gir)
  is export
{ * }

sub g_type_info_get_array_fixed_size (GITypeInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_type_info_get_array_length (GITypeInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_type_info_get_array_type (GITypeInfo $info)
  returns GIArrayType
  is native(gir)
  is export
{ * }

sub g_type_info_get_interface (GITypeInfo $info)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_type_info_get_param_type (GITypeInfo $info, gint $n)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_type_info_get_tag (GITypeInfo $info)
  returns GITypeTag
  is native(gir)
  is export
{ * }

sub g_type_info_is_pointer (GITypeInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_type_info_is_zero_terminated (GITypeInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
