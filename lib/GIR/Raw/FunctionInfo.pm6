use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::FunctionInfo;

### /usr/include/gobject-introspection-1.0/gifunctioninfo.h

sub g_function_info_get_flags (GIFunctionInfo $info)
  returns GIFunctionInfoFlags
  is native(gir)
  is export
{ * }

sub g_function_info_get_property (GIFunctionInfo $info)
  returns GIPropertyInfo
  is native(gir)
  is export
{ * }

sub g_function_info_get_symbol (GIFunctionInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_function_info_get_vfunc (GIFunctionInfo $info)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }

sub g_function_info_invoke (
  GIFunctionInfo $info,
  Pointer $in_args,           #= Array of GIArgument
  gint $n_in_args,
  Pointer $out_args,          #= Array of GIArgument
  gint $n_out_args,
  GIArgument $return_value,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_invoke_error_quark ()
  returns GQuark
  is native(gir)
  is export
{ * }
