use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;
use GIR::Raw::Typelib;

class GIR::Typelib {
  has GITypelib $!tl;

  submethod BUILD (:$typelib) {
    $!tl = $typelib;
  }

  method GIR::Raw::Structs::GITypelib
    is also<GITypelib>
  { $!tl }

  method new (GITypelib $typelib) {
    $typelib ?? self.bless( :$typelib ) !! Nil;
  }

  method new_from_const_memory (
    Pointer $memory,
    Int() $len,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-const-memory>
  {
    my gsize $l = $len;

    clear_error;
    my $typelib = g_typelib_new_from_const_memory($memory, $l, $error);
    set_error($error);

    $typelib ?? self.bless( :$typelib ) !! Nil;
  }

  method new_from_mapped_file (
    GMappedFile() $mfile,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-mapped-file>
  {
    clear_error;
    my $typelib = g_typelib_new_from_mapped_file($mfile, $error);
    set_error($error);

    $typelib ?? self.bless( :$typelib ) !! Nil;
  }

  method new_from_memory (
    Pointer $memory,
    Int() $len,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-memory>
  {
    my gsize $l = $len;

    clear_error;
    my $typelib = g_typelib_new_from_memory($memory, $len, $error);
    set_error($error);

    $typelib ?? self.bless( :$typelib ) !! Nil;
  }

  method free {
    g_typelib_free($!tl);
  }

  method get_namespace
    is also<
      get-namespace
      namespace
    >
  {
    g_typelib_get_namespace($!tl);
  }

  method symbol (Str() $symbol_name, gpointer $symbol) {
    so g_typelib_symbol($!tl, $symbol_name, $symbol);
  }

}
