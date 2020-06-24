use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;

use GIR::CallableInfo;

our subset GISignalInfoAncestry is export of Mu
  where GISignalInfo | GICallableInfoAncestry;

class GIR::SignalInfo is GIR::CallableInfo {
  has GISignalInfo $!si;

  submethod BUILD (:$signal-info) {
    self.setSignalInfo($signal-info) if $signal-info;
  }

  method setSignalInfo (GISignalInfoAncestry $_) {
    my $to-parent;

    $!si = do {
      when GISignalInfo {
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

  method GStreamer::Raw::Signals::GISignalInfo
    is also<GISignalInfo>
  { $!si }

  method new (GISignalInfoAncestry $signal-info) {
    $signal-info ?? self.bless(:$signal-info) !! Nil;
  }

  method get_class_closure (:$raw = False)
    is also<
      get-class-closure
      class_closure
      class-closure
    >
  {
    my $v = g_signal_info_get_class_closure($!si);

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

  method get_flags
    is also<
      get-flags
      flags
    >
  {
    GSignalFlagsEnum( g_signal_info_get_flags($!si) );
  }

  method true_stops_emit is also<true-stops-emit> {
    so g_signal_info_true_stops_emit($!si);
  }

}


### /usr/include/gobject-introspection-1.0/gisignalinfo.h

sub g_signal_info_get_class_closure (GISignalInfo $info)
  returns GISignalInfo
  is native(gir)
  is export
{ * }

sub g_signal_info_get_flags (GISignalInfo $info)
  returns GSignalFlags
  is native(gir)
  is export
{ * }

sub g_signal_info_true_stops_emit (GISignalInfo $info)
  returns uint32
  is native(gir)
  is export
{ * }
