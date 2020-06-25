use v6.c;

use NativeCall;

use GIR::Raw::Types;

unit package GIR::Raw::Typelib;

### /usr/include/gobject-introspection-1.0/gitypelib.h

sub g_typelib_free (GITypelib $typelib)
  is native(gir)
  is export
{ * }

sub g_typelib_get_namespace (GITypelib $typelib)
  returns Str
  is native(gir)
  is export
{ * }

sub g_typelib_new_from_const_memory (
  Pointer $memory is rw,
  gsize $len,
  CArray[Pointer[GError]] $error
)
  returns GITypelib
  is native(gir)
  is export
{ * }

sub g_typelib_new_from_mapped_file (
  GMappedFile $mfile,
  CArray[Pointer[GError]] $error
)
  returns GITypelib
  is native(gir)
  is export
{ * }

sub g_typelib_new_from_memory (
  Pointer $memory is rw,
  gsize $len,
  CArray[Pointer[GError]] $error
)
  returns GITypelib
  is native(gir)
  is export
{ * }

sub g_typelib_symbol (GITypelib $typelib, Str $symbol_name, gpointer $symbol)
  returns uint32
  is native(gir)
  is export
{ * }
