use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::ArgInfo;

### /usr/include/gobject-introspection-1.0/giarginfo.h

sub g_arg_info_get_closure (GIArgInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_arg_info_get_destroy (GIArgInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_arg_info_get_direction (GIArgInfo $info)
  returns GIDirection
  is native(gir)
  is export
{ * }

sub g_arg_info_get_ownership_transfer (GIArgInfo $info)
  returns GITransfer
  is native(gir)
  is export
{ * }

sub g_arg_info_get_scope (GIArgInfo $info)
  returns GIScopeType
  is native(gir)
  is export
{ * }

sub g_arg_info_get_type (GIArgInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_arg_info_is_caller_allocates (GIArgInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_arg_info_is_optional (GIArgInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_arg_info_is_return_value (GIArgInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_arg_info_is_skip (GIArgInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_arg_info_load_type (GIArgInfo $info, GITypeInfo $type)
  is native(gir)
  is export
{ * }

sub g_arg_info_may_be_null (GIArgInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
