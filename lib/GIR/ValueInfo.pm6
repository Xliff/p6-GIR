use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::EnumInfo;

use GIR::BaseInfo;

our subset GIValueInfoAncestry is export of Mu
  where GIValueInfo | GIBaseInfo;

class GIR::ValueInfo is GIR::BaseInfo {
  has GIValueInfo $!vi;

  submethod BUILD (:$value-info) {
    self.setValueInfo($value-info) if $value-info;
  }

  method setValueInfo (GIValueInfoAncestry $_) {
    my $to-parent;

    $!vi = do {
      when GIValueInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIValueInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GStreamer::Raw::Structs::GIValueInfo
    is also<GIValueInfo>
  { $!vi }

  method new (GIValueInfoAncestry $value-info) {
    $value-info ?? self.bless(:$value-info) !! Nil;
  }

  method get_value
    is also<
      get-value
      value
    >
  {
    g_value_info_get_value($!vi);
  }

}
