use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::ObjectInfo;

### /usr/include/gobject-introspection-1.0/giobjectinfo.h

sub g_object_info_find_method (GIObjectInfo $info, Str $name)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_object_info_find_method_using_interfaces (
  GIObjectInfo $info,
  Str $name,
  GIObjectInfo $implementor
)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_object_info_find_signal (GIObjectInfo $info, Str $name)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_object_info_find_vfunc (GIObjectInfo $info, Str $name)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }

sub g_object_info_find_vfunc_using_interfaces (
  GIObjectInfo $info,
  Str $name,
  GIObjectInfo $implementor
)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_abstract (GIObjectInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_object_info_get_class_struct (GIObjectInfo $info)
  returns GIStructInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_constant (GIObjectInfo $info, gint $n)
  returns GIConstantInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_field (GIObjectInfo $info, gint $n)
  returns GIFieldInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_fundamental (GIObjectInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_object_info_get_get_value_function (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_get_value_function_pointer (GIObjectInfo $info)
  returns Pointer # GIObjectInfoGetValueFunction
  is native(gir)
  is export
{ * }

sub g_object_info_get_interface (GIObjectInfo $info, gint $n)
  returns GIInterfaceInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_method (GIObjectInfo $info, gint $n)
  returns GIFunctionInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_constants (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_fields (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_interfaces (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_methods (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_properties (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_signals (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_n_vfuncs (GIObjectInfo $info)
  returns gint
  is native(gir)
  is export
{ * }

sub g_object_info_get_parent (GIObjectInfo $info)
  returns GIObjectInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_property (GIObjectInfo $info, gint $n)
  returns GIPropertyInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_ref_function (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_ref_function_pointer (GIObjectInfo $info)
  returns Pointer # GIObjectInfoRefFunction
  is native(gir)
  is export
{ * }

sub g_object_info_get_set_value_function (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_set_value_function_pointer (GIObjectInfo $info)
  returns Pointer # GIObjectInfoSetValueFunction
  is native(gir)
  is export
{ * }

sub g_object_info_get_signal (GIObjectInfo $info, gint $n)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_object_info_get_type_init (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_type_name (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_unref_function (GIObjectInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_object_info_get_unref_function_pointer (GIObjectInfo $info)
  returns Pointer # GIObjectInfoUnrefFunction
  is native(gir)
  is export
{ * }

sub g_object_info_get_vfunc (GIObjectInfo $info, gint $n)
  returns GIVFuncInfo
  is native(gir)
  is export
{ * }
