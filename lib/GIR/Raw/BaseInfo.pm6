use v6.c;

use GIR::Raw::Types;

unit package GIR::Raw::BaseInfo;


### /usr/include/gobject-introspection-1.0/gibaseinfo.h

sub g_base_info_equal (GIBaseInfo $info1, GIBaseInfo $info2)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_base_info_get_attribute (GIBaseInfo $info, Str $name)
  returns Str
  is native(gir)
  is export
{ * }

sub g_base_info_get_container (GIBaseInfo $info)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_base_info_get_name (GIBaseInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_base_info_get_namespace (GIBaseInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_base_info_get_type (GIBaseInfo $info)
  returns GIInfoType
  is native(gir)
  is export
{ * }

sub g_base_info_get_typelib (GIBaseInfo $info)
  returns GITypelib
  is native(gir)
  is export
{ * }

sub g_base_info_gtype_get_type ()
  returns GType
  is native(gir)
  is export
{ * }

sub g_base_info_is_deprecated (GIBaseInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_base_info_iterate_attributes (
  GIBaseInfo $info,
  GIAttributeIter $iterator,
  Str $name,
  Str $value
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_base_info_ref (GIBaseInfo $info)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_base_info_unref (GIBaseInfo $info)
  is native(gir)
  is export
{ * }

sub g_info_new (
  GIInfoType $type,
  GIBaseInfo $container,
  GITypelib $typelib,
  guint32 $offset
)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }
