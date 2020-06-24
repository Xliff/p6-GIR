use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::VFuncInfo;

### /usr/include/gobject-introspection-1.0/givfuncinfo.h

sub g_vfunc_info_get_address (
  GIVFuncInfo $info,
  GType $implementor_gtype,
  CArray[Pointer[GError]] $error
)
  returns Pointer
  is native(gir)
  is export
{ * }

sub g_vfunc_info_get_flags (GIVFuncInfo $info)
  returns GIVFuncInfoFlags
  is native(gir)
  is export
{ * }

sub g_vfunc_info_get_invoker (GIVFuncInfo $info)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_vfunc_info_get_offset (GIVFuncInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_vfunc_info_get_signal (GIVFuncInfo $info)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_vfunc_info_invoke (
  GIVFuncInfo $info,
  GType $implementor,
  Pointer $in_args,
  gint $n_in_args,
  Pointer $out_args, 
  gint $n_out_args,
  GIArgument $return_value,
  CArray[Pointer[GError]] $error
)
  returns uint32
  is native(gir)
  is export
{ * }
