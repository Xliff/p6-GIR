use v6.c;

use NativeCall;
use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::VFuncInfo;

use GIR::CallableInfo;
use GIR::FunctionInfo;
use GIR::SignalInfo;

our subset GIVFuncInfoAncestry is export of Mu
  where GIVFuncInfo | GICallableInfoAncestry;

class GIR::VFuncInfo is GIR::CallableInfo {
  has GIVFuncInfo $!vi;

  submethod BUILD (:$vfunc-info) {
    self.setVFuncInfo($vfunc-info) if $vfunc-info;
  }

  method setVFuncInfo (GIVFuncInfoAncestry $_) {
    my $to-parent;

    $!vi = do {
      when GIVFuncInfo {
        $to-parent = cast(GICallableInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GICallableInfo, $_);
      }
    }

    self.setGICallableInfo($to-parent);
  }

  method GStreamer::Raw::VFuncs::GIVFuncInfo
    is also<GIVFuncInfo>
  { $!vi }

  method new (GIVFuncInfoAncestry $vfunc-info) {
    $vfunc-info ?? self.bless(:$vfunc-info) !! Nil;
  }

  method get_address (
    Int() $implementor_gtype,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<get-address>
  {
    g_vfunc_info_get_address($!vi, $implementor_gtype, $error);
  }

  method get_flags
    is also<
      get-flags
      flags
    >
  {
    GIVFuncInfoFlags( g_vfunc_info_get_flags($!vi) );
  }

  method get_invoker (:$raw = False)
    is also<
      get-invoker
      invoker
    >
  {
    my $f = g_vfunc_info_get_invoker($!vi);

    $f ??
      ( $raw ?? $f !! GIR::FunctionInfo.new($f) )
      !!
      Nil;
  }

  method get_offset
    is also<
      get-offset
      offset
    >
  {
    g_vfunc_info_get_offset($!vi);
  }

  method get_signal (:$raw = False)
    is also<
      get-signal
      signal
    >
  {
    my $s = g_vfunc_info_get_signal($!vi);

    $s ??
      ( $raw ?? $s !! GIR::SignalInfo.new($s) )
      !!
      Nil;
  }

  multi method invoke (
    Int() $implementor,
    @in,
    @out,
    GIArgument $return_value,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my $in = GLib::Roles::TypedBuffer[GIArgument].new(@in);
    my $out = GLib::Roles::TypedBuffer[GIArgument].new(@out);

    samewith(
      $implementor,
      $in.p,
      @in.elems,
      $out.p,
      @out.elems,
      $return_value,
      $error
    );
  }
  multi method invoke (
    Int() $implementor,
    Pointer $in_args,
    gint $n_in_args,
    Pointer $out_args,
    gint $n_out_args,
    GIArgument $return_value,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $rv = so g_vfunc_info_invoke(
      $!vi,
      $implementor,
      $in_args,
      $n_in_args,
      $out_args,
      $n_out_args,
      $return_value,
      $error
    );
    set_error($error);
    $rv;
  }

}
