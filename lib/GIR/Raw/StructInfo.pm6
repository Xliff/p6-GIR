use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::StructInfo;

### /usr/include/gobject-introspection-1.0/gistructinfo.h

sub g_struct_info_find_field (GIStructInfo $info, Str $name)
  returns GIFieldInfo
  is native(gir)
  is export
{ * }

sub g_struct_info_find_method (GIStructInfo $info, Str $name)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_struct_info_get_alignment (GIStructInfo $info)
  returns gsize
  is native(gir)
  is export
{ * }

sub g_struct_info_get_field (GIStructInfo $info, gint $n)
  returns GIFieldInfo
  is native(gir)
  is export
{ * }

sub g_struct_info_get_method (GIStructInfo $info, gint $n)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_struct_info_get_n_fields (GIStructInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_struct_info_get_n_methods (GIStructInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_struct_info_get_size (GIStructInfo $info)
  returns gsize
  is native(gir)
  is export
{ * }

sub g_struct_info_is_foreign (GIStructInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_struct_info_is_gtype_struct (GIStructInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
