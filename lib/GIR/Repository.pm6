use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;
use GIR::Raw::Repository;

use GLib::GList;
use GIR::BaseInfo;
use GIR::EnumInfo;
use GIR::Typelib;

use GLib::Roles::ListData;
use GLib::Roles::Object;

our subset GIRepositoryAncestry is export of Mu
  where GIRepository | GObject;

class GIR::Repository {
  also does GLib::Roles::Object;

  has GIRepository $!gir;

  submethod BUILD (:$repository) {
    self.setRepository($repository);
  }

  method setRepository (GIRepositoryAncestry $_) {
    my $to-parent;

    $!gir = do {
      when GIRepository {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIRepository, $_);
      }
    }

    self!setObject($to-parent);
  }

  method GIR::Raw::Structs::GIRepository
    is also<GIRepository>
  { $!gir }

  multi method new (GIRepositoryAncestry $repository) {
    $repository ?? self.bless( :$repository ) !! Nil;
  }

  method get_default is also<get-default> {
    my $repository = g_irepository_get_default();

    $repository ?? self.bless( :$repository ) !! Nil;
  }

  method dump (
    GIR::Repository:U:
    Str() $arg,
    CArray[Pointer[GError]] $error
  ) {
    clear_error;
    my $rv = g_irepository_dump($arg, $error);
    set_error($error);
    $rv;
  }

  method enumerate_versions (
    Str() $namespace,
    :$glist = False,
    :$raw = False
  )
    is also<enumerate-versions>
  {
    my $vl = g_irepository_enumerate_versions($!gir, $namespace);

    return Nil unless $vl;
    return $vl if $glist && $raw;

    $vl = GLib::GList.new($vl) but GLib::Roles::ListData[Str];
    return $vl if $glist;
    $vl.Array;
  }

  method error_quark is also<error-quark> {
    g_irepository_error_quark();
  }

  method find_by_error_domain (GQuark $domain, :$raw = False)
    is also<find-by-error-domain>
  {
    my $e = g_irepository_find_by_error_domain($!gir, $domain);

    $e ??
      ( $raw ?? $e !! GIR::EnumInfo.new($e) )
      !!
      Nil;
  }

  method find_by_gtype (Int() $gtype, :$raw = False) is also<find-by-gtype> {
    return Nil unless $gtype;

    my $b = g_irepository_find_by_gtype($!gir, $gtype);

    $b ??
      ( $raw ?? $b !! GIR::BaseInfo.new($b) )
      !!
      Nil;
  }

  method find_by_name (Str() $namespace, Str() $name, :$raw = False)
    is also<find-by-name>
  {
    my $b = g_irepository_find_by_name($!gir, $namespace, $name);

    $b ??
      ( $raw ?? $b !! GIR::BaseInfo.new($b) )
      !!
      Nil;
  }

  method get_c_prefix (Str() $namespace) is also<get-c-prefix> {
    g_irepository_get_c_prefix($!gir, $namespace);
  }

  method get_dependencies (Str() $namespace) is also<get-dependencies> {
    CStringArrayToArray( g_irepository_get_dependencies($!gir, $namespace) );
  }

  method get_immediate_dependencies (Str $namespace)
    is also<get-immediate-dependencies>
  {
    CStringArrayToArray(
      g_irepository_get_immediate_dependencies($!gir, $namespace)
    );
  }

  method get_info (Str() $namespace, Int() $index, :$raw = False)
    is also<get-info>
  {
    my gint $i = $index;

    my $b = g_irepository_get_info($!gir, $namespace, $i);

    $b ??
      ( $raw ?? $b !! GIR::BaseInfo.new($b) )
      !!
      Nil;
  }

  method get_infos (Str() $namespace) is also<get-infos> {
    do gather for ^self.get_n_infos($namespace) {
      take self.get_info($namespace, $_);
    }
  }

  method get_loaded_namespaces is also<get-loaded-namespaces> {
    CStringArrayToArray( g_irepository_get_loaded_namespaces($!gir) );
  }

  method get_n_infos (Str() $namespace) is also<get-n-infos> {
    g_irepository_get_n_infos($!gir, $namespace);
  }

  proto method get_object_gtype_interfaces (|)
      is also<get-object-gtype-interfaces>
  { * }

  multi method get_object_gtype_interfaces (Int() $gtype) {
    samewith($gtype, $, $);
  }
  multi method get_object_gtype_interfaces (
    Int() $gtype,
    $n_interfaces_out is rw,
    $interfaces_out is rw,
  ) {
    my guint $n = 0;
    my $io = CArray[Pointer].new;
    $io[0] = Pointer;

    g_irepository_get_object_gtype_interfaces($!gir, $gtype, $n, $io);
    ($n_interfaces_out, $interfaces_out) = ppr($n, $io);
    if $interfaces_out {
      $interfaces_out =
        GLib::Roles::TypedBuffer[GIInterfaceInfo].new($interfaces_out).Array;
      $interfaces_out.setSize($n_interfaces_out);
    }
    ($n_interfaces_out, $interfaces_out);
  }

  method get_option_group (GIR::Repository:U: ) is also<get-option-group> {
    g_irepository_get_option_group();
  }

  method get_search_path (GIR::Repository:U: :$glist =  False, :$raw = False )
    is also<
      get-search-path
      search_path
      search-path
    >
  {
    my $spl = g_irepository_get_search_path();

    return Nil unless $spl;
    return $spl if $glist && $raw;

    $spl = GLib::GList.new($spl) but GLib::Roles::ListData[Str];
    $spl.Array;
  }

  method get_shared_library (Str() $namespace) is also<get-shared-library> {
    g_irepository_get_shared_library($!gir, $namespace);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &g_irepository_get_type, $n, $t );
  }

  method get_typelib_path (Str() $namespace) is also<get-typelib-path> {
    g_irepository_get_typelib_path($!gir, $namespace);
  }

  method get_version (Str() $namespace) is also<get-version> {
    g_irepository_get_version($!gir, $namespace);
  }

  method gi_cclosure_marshal_generic (
    GIR::Repository:U:
    GClosure() $closure,
    GValue() $return_gvalue,
    Int() $n_param_values,
    GValue() $param_values,
    gpointer $invocation_hint,
    gpointer $marshal_data
  )
    is also<gi-cclosure-marshal-generic>
  {
    my guint $n = $n_param_values;

    gi_cclosure_marshal_generic(
      $closure,
      $return_gvalue,
      $n_param_values,
      $param_values,
      $invocation_hint,
      $marshal_data
    );
  }

  method is_registered (Str() $namespace, Str() $version)
    is also<is-registered>
  {
    g_irepository_is_registered($!gir, $namespace, $version);
  }

  method load_typelib (
    GITypelib $typelib,
    Int() $flags                   = 0,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<load-typelib>
  {
    my GIRepositoryLoadFlags $f = $flags;

    clear_error;
    my $rv = g_irepository_load_typelib($!gir, $typelib, $f, $error);
    set_error($error);
    $rv;
  }

  method prepend_library_path (
    GIR::Repository:U:
    Str() $dir
  )
    is also<prepend-library-path>
  {
    g_irepository_prepend_library_path($dir);
  }

  method prepend_search_path (
    GIR::Repository:U:
    Str() $dir
  )
    is also<prepend-search-path>
  {
    g_irepository_prepend_search_path($dir);
  }

  method require (
    Str() $namespace,
    Str() $version                 = Str,
    Int() $flags                   = 0,
    CArray[Pointer[GError]] $error = gerror,
    :$raw                          = False
  ) {
    my GIRepositoryLoadFlags $f = $flags;

    clear_error;
    my $t = g_irepository_require($!gir, $namespace, $version, $f, $error);
    set_error($error);

    $t ??
      ( $raw ?? $t !! GIR::Typelib.new($t) )
      !!
      Nil;
  }

  method require_private (
    Str() $typelib_dir,
    Str() $namespace,
    Str() $version                 = Str,
    Int() $flags                   = 0,
    CArray[Pointer[GError]] $error = gerror,
    :$raw                          = False
  )
    is also<require-private>
  {
    my GIRepositoryLoadFlags $f = $flags;

    clear_error;
    my $t = g_irepository_require_private(
      $!gir,
      $typelib_dir,
      $namespace,
      $version,
      $f,
      $error
    );
    set_error($error);

    $t ??
      ( $raw ?? $t !! GIR::Typelib.new($t) )
      !!
      Nil;
  }

}
