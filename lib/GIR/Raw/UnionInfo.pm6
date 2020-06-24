use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::UnionInfo;

### /usr/include/gobject-introspection-1.0/giunioninfo.h

sub g_union_info_find_method (GIUnionInfo $info, Str $name)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_union_info_get_alignment (GIUnionInfo $info)
  returns gsize
  is native(gir)
  is export
{ * }

sub g_union_info_get_discriminator (GIUnionInfo $info, gint $n)
  returns GIConstantInfo
  is native(gir)
  is export
{ * }

sub g_union_info_get_discriminator_offset (GIUnionInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_union_info_get_discriminator_type (GIUnionInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_union_info_get_field (GIUnionInfo $info, gint $n)
  returns GIFieldInfo
  is native(gir)
  is export
{ * }

sub g_union_info_get_method (GIUnionInfo $info, gint $n)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_union_info_get_n_fields (GIUnionInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_union_info_get_n_methods (GIUnionInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_union_info_get_size (GIUnionInfo $info)
  returns gsize
  is native(gir)
  is export
{ * }

sub g_union_info_is_discriminated (GIUnionInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
