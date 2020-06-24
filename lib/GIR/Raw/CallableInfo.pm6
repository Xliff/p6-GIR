use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::CallableInfo;

### /usr/include/gobject-introspection-1.0/gicallableinfo.h

sub g_callable_info_can_throw_gerror (GICallableInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_callable_info_get_arg (GICallableInfo $info, gint $n)
  returns GIArgInfo
  is native(gir)
  is export
{ * }

sub g_callable_info_get_caller_owns (GICallableInfo $info)
  returns GITransfer
  is native(gir)
  is export
{ * }

sub g_callable_info_get_instance_ownership_transfer (GICallableInfo $info)
  returns GITransfer
  is native(gir)
  is export
{ * }

sub g_callable_info_get_n_args (GICallableInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_callable_info_get_return_attribute (GICallableInfo $info, Str $name)
  returns Str
  is native(gir)
  is export
{ * }

sub g_callable_info_get_return_type (GICallableInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_callable_info_invoke (
  GICallableInfo $info,
  gpointer $function,
  Pointer $in_args,
  gint $n_in_args,
  Pointer $out_args,
  gint $n_out_args,
  GIArgument $return_value,
  gboolean $is_method,
  gboolean $throws,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_callable_info_is_method (GICallableInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_callable_info_iterate_return_attributes (
  GICallableInfo $info,
  GIAttributeIter $iterator,
  Str $name,
  Str $value
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_callable_info_load_arg (GICallableInfo $info, gint $n, GIArgInfo $arg)
  is native(gir)
  is export
{ * }

sub g_callable_info_load_return_type (GICallableInfo $info, GITypeInfo $type)
  is native(gir)
  is export
{ * }

sub g_callable_info_may_return_null (GICallableInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_callable_info_skip_return (GICallableInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
