use v6.c;

use Method::Also;

use GIR::Raw::Types;

use GIR::BaseInfo;

our subset GIPropertyInfoAncestry is export of Mu
  where GIPropertyInfo | GIBaseInfo;

class GIR::PropertyInfo is GIR::BaseInfo {
  has GIPropertyInfo $!pi;

submethod BUILD (:$property-info) {
    self.setGIPropertyInfo($property-info) if $property-info;
  }

  method setGIPropertyInfo (GIPropertyInfoAncestry $_) {
    my $to-parent;

    $!pi = do {
      when GIPropertyInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIPropertyInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GIPropertyInfo
    is also<GIPropertyInfo>
  { $!pi }

  method new (GIPropertyInfoAncestry $property-info) {
    $property-info ?? self.bless( :$property-info ) !! Nil;
  }

  method get_flags
    is also<
      get-flags
      flags
    >
  {
    g_property_info_get_flags($!pi);
  }

  method get_ownership_transfer
    is also<
      get-ownership-transfer
      ownership_transfer
      ownership-transfer
    >
  {
    g_property_info_get_ownership_transfer($!pi);
  }

  method get_type
    is also<
      get-type
      type
    >
  {
    g_property_info_get_type($!pi);
  }

}


### /usr/include/gobject-introspection-1.0/gipropertyinfo.h

sub g_property_info_get_flags (GIPropertyInfo $info)
  returns GParamFlags
  is native(gir)
  is export
{ * }

sub g_property_info_get_ownership_transfer (GIPropertyInfo $info)
  returns GITransfer
  is native(gir)
  is export
{ * }

sub g_property_info_get_type (GIPropertyInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }
