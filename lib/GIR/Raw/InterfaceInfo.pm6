use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::InterfaceInfo;

### /usr/include/gobject-introspection-1.0/giinterfaceinfo.h

sub g_interface_info_find_method (GIInterfaceInfo $info, Str $name)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_find_signal (GIInterfaceInfo $info, Str $name)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_find_vfunc (GIInterfaceInfo $info, Str $name)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_constant (GIInterfaceInfo $info, gint $n)
  returns GIConstantInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_iface_struct (GIInterfaceInfo $info)
  returns GIStructInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_method (GIInterfaceInfo $info, gint $n)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_constants (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_methods (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_prerequisites (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_properties (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_signals (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_n_vfuncs (GIInterfaceInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_interface_info_get_prerequisite (GIInterfaceInfo $info, gint $n)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_property (GIInterfaceInfo $info, gint $n)
  returns GIPropertyInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_signal (GIInterfaceInfo $info, gint $n)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_interface_info_get_vfunc (GIInterfaceInfo $info, gint $n)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }
