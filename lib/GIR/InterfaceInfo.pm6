use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::InterfaceInfo;

use GIR::RegisteredTypeInfo;

use GIR::BaseInfo;
use GIR::ConstantInfo;
use GIR::PropertyInfo;
use GIR::FunctionInfo;
use GIR::SignalInfo;
use GIR::StructInfo;
use GIR::VFuncInfo;

our subset GIInterfaceInfoAncestry is export of Mu
  where GIInterfaceInfo | GIRegisteredTypeInfoAncestry;

class GIR::InterfaceInfo is GIR::RegisteredTypeInfo {
  has GIInterfaceInfo $!ii;

  submethod BUILD (:$interface-info) {
    self.setInterfaceInfo($interface-info) if $interface-info;
  }

  method setInterfaceInfo (GIInterfaceInfoAncestry $_) {
    my $to-parent;

    $!ii = do {
      when GIInterfaceInfo {
        $to-parent = cast(GIRegisteredTypeInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIInterfaceInfo, $_);
      }
    }

    self.setGIRegisteredTypeInfo($to-parent);
  }

  method GStreamer::Raw::Interfaces::GIInterfaceInfo
    is also<GIInterfaceInfo>
  { $!ii }

  method new (GIInterfaceInfoAncestry $interface-info) {
    $interface-info ?? self.bless(:$interface-info) !! Nil;
  }

  method find_method (Str() $name, :$raw = False) is also<find-method> {
    my $m = g_interface_info_find_method($!ii, $name);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method find_signal (Str() $name, :$raw = False) is also<find-signal> {
    my $s = g_interface_info_find_signal($!ii, $name);

    $s ??
      ( $raw ?? $s !! GIR::SignalInfo.new($s) )
      !!
      Nil;
  }

  method find_vfunc (Str() $name, :$raw = False) is also<find-vfunc> {
    my $v = g_interface_info_find_vfunc($!ii, $name);

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

  method get_constant (Int() $n, :$raw = False) is also<get-constant> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_constants - 1;

    my gint $nn = $n;
    my $c = g_interface_info_get_constant($!ii, $nn);

    $c ??
      ( $raw ?? $c !! GIR::ConstantInfo.new($c) )
      !!
      Nil;
  }

  method get_iface_struct (:$raw = False)
    is also<
      get-iface-struct
      iface_struct
      iface-struct
    >
  {
    my $s = g_interface_info_get_iface_struct($!ii);

    $s ??
      ( $raw ?? $s !! GIR::StructInfo.new($s) )
      !!
      Nil;
  }

  method get_method (Int() $n, :$raw = False) is also<get-method> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_methods - 1;

    my gint $nn = $n;
    my $m = g_interface_info_get_method($!ii, $nn);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method get_n_constants
    is also<
      get-n-constants
      n_constants
      n-constants
      c_elems
      c-elems
    >
  {
    g_interface_info_get_n_constants($!ii);
  }

  method get_n_methods
    is also<
      get-n-methods
      n_methods
      n-methods
      m_elems
      m-elems
    >
  {
    g_interface_info_get_n_methods($!ii);
  }

  method get_n_prerequisites
    is also<
      get-n-prerequisites
      n_prerequisites
      n-prerequisites
      pre_elems
      pre-elems
    >
  {
    g_interface_info_get_n_prerequisites($!ii);
  }

  method get_n_properties
    is also<
      get-n-properties
      n_properties
      n-properties
      p_elems
      p-elems
    >
  {
    g_interface_info_get_n_properties($!ii);
  }

  method get_n_signals
    is also<
      get-n-signals
      n_signals
      n-signals
      s_elems
      s-elems
    >
  {
    g_interface_info_get_n_signals($!ii);
  }

  method get_n_vfuncs
    is also<
      get-n-vfuncs
      n_vfuncs
      n-vfuncs
      v_elems
      v-elems
    >
  {
    g_interface_info_get_n_vfuncs($!ii);
  }

  method get_prerequisite (Int() $n, :$raw = False) is also<get-prerequisite> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_prerequisites - 1;

    my gint $nn = $n;
    my $b = g_interface_info_get_prerequisite($!ii, $nn);

    $b ??
      ( $raw ?? $b !! GIR::BaseInfo.new($b) )
      !!
      Nil;
  }

  method get_property (Int() $n, :$raw = False) is also<get-property> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_properties - 1;

    my gint $nn = $n;
    my $p = g_interface_info_get_property($!ii, $nn);

    $p ??
      ( $raw ?? $p !! GIR::PropertyInfo.new($p) )
      !!
      Nil;
  }

  method get_signal (Int() $n, :$raw = False) is also<get-signal> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_signals - 1;

    my gint $nn = $n;
    my $s = g_interface_info_get_signal($!ii, $nn);

    $s ??
      ( $raw ?? $s !! GIR::SignalInfo.new($s) )
      !!
      Nil;
  }

  method get_vfunc (Int() $n, :$raw = False) is also<get-vfunc> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_vfuncs - 1;

    my gint $nn = $n;
    my $v = g_interface_info_get_vfunc($!ii, $nn);

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

}
