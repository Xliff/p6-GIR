use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::Repository;

### /usr/include/gobject-introspection-1.0/girepository.h

sub g_irepository_dump (Str $arg, CArray[Pointer[GError]] $error)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_irepository_enumerate_versions (
  GIRepository $repository,
  Str $namespace
)
  returns GList
  is native(gir)
  is export
{ * }

sub g_irepository_error_quark ()
  returns GQuark
  is native(gir)
  is export
{ * }

sub g_irepository_find_by_error_domain (
  GIRepository $repository,
  GQuark $domain
)
  returns GIEnumInfo
  is native(gir)
  is export
{ * }

sub g_irepository_find_by_gtype (GIRepository $repository, GType $gtype)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_irepository_find_by_name (
  GIRepository $repository,
  Str $namespace,
  Str $name
)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_irepository_get_c_prefix (GIRepository $repository, Str $namespace)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_default ()
  returns GIRepository
  is native(gir)
  is export
{ * }

sub g_irepository_get_dependencies (GIRepository $repository, Str $namespace)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_immediate_dependencies (
  GIRepository $repository,
  Str $namespace
)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_info (
  GIRepository $repository,
  Str $namespace,
  gint $index
)
  returns GIBaseInfo
  is native(gir)
  is export
{ * }

sub g_irepository_get_loaded_namespaces (GIRepository $repository)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_n_infos (GIRepository $repository, Str $namespace)
  returns gint
  is native(gir)
  is export
{ * }

sub g_irepository_get_object_gtype_interfaces (
  GIRepository $repository,
  GType $gtype,
  guint $n_interfaces_out is rw,
  GIInterfaceInfo $interfaces_out
)
  is native(gir)
  is export
{ * }

sub g_irepository_get_option_group ()
  returns GOptionGroup
  is native(gir)
  is export
{ * }

sub g_irepository_get_search_path ()
  returns GSList
  is native(gir)
  is export
{ * }

sub g_irepository_get_shared_library (GIRepository $repository, Str $namespace)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_type ()
  returns GType
  is native(gir)
  is export
{ * }

sub g_irepository_get_typelib_path (GIRepository $repository, Str $namespace)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_get_version (GIRepository $repository, Str $namespace)
  returns Str
  is native(gir)
  is export
{ * }

sub gi_cclosure_marshal_generic (
  GClosure $closure,
  GValue $return_gvalue,
  guint $n_param_values,
  GValue $param_values,
  gpointer $invocation_hint,
  gpointer $marshal_data
)
  is native(gir)
  is export
{ * }

sub g_irepository_is_registered (
  GIRepository $repository,
  Str $namespace,
  Str $version
)
  returns uint32
  is native(gir)
  is export
{ * }

sub g_irepository_load_typelib (
  GIRepository $repository,
  GITypelib $typelib,
  GIRepositoryLoadFlags $flags,
  CArray[Pointer[GError]] $error
)
  returns Str
  is native(gir)
  is export
{ * }

sub g_irepository_prepend_library_path (Str $directory)
  is native(gir)
  is export
{ * }

sub g_irepository_prepend_search_path (Str $directory)
  is native(gir)
  is export
{ * }

sub g_irepository_require (
  GIRepository $repository,
  Str $namespace,
  Str $version,
  GIRepositoryLoadFlags $flags,
  CArray[Pointer[GError]] $error
)
  returns GITypelib
  is native(gir)
  is export
{ * }

sub g_irepository_require_private (
  GIRepository $repository,
  Str $typelib_dir,
  Str $namespace_,
  Str $version,
  GIRepositoryLoadFlags $flags,
  CArray[Pointer[GError]] $error
)
  returns GITypelib
  is native(gir)
  is export
{ * }
