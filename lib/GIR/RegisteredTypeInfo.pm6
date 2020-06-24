use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;

use GIR::BaseInfo;

our subset GIRegisteredTypeInfoAncestry is export of Mu
  where GIRegisteredTypeInfo | GIBaseInfo;

class GIR::RegisteredTypeInfo is GIR::BaseInfo {
  has GIRegisteredTypeInfo $!rti;

  submethod BUILD (:$registered) {
    self.setGIRegisteredTypeInfo($registered) if $registered;
  }

  method setGIRegisteredTypeInfo (GIRegisteredTypeInfoAncestry $_) {
    my $to-parent;

    $!rti = do {
      when GIRegisteredTypeInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIBaseInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GStreamer::Raw::Structs::GIRegisteredTypeInfo
    is also<GIRegisteredTypeInfo>
  { $!rti }

  method new (GIRegisteredTypeInfoAncestry $registered) {
    $registered ?? self.bless(:$registered) !! Nil;
  }

  method get_g_type
    is also<
      get-g-type
      g_type
      g-type
    >
  {
    g_registered_type_info_get_g_type($!rti);
  }

  method get_type_init
    is also<
      get-type-init
      type_init
      type-init
    >
  {
    g_registered_type_info_get_type_init($!rti);
  }

  method get_type_name
    is also<
      get-type-name
      type_name
      type-name
    >
  {
    g_registered_type_info_get_type_name($!rti);
  }

}

### /usr/include/gobject-introspection-1.0/giregisteredtypeinfo.h

sub g_registered_type_info_get_g_type (GIRegisteredTypeInfo $info)
  returns GType
  is native(gir)
  is export
{ * }

sub g_registered_type_info_get_type_init (GIRegisteredTypeInfo $info)
  returns Str
  is native(gir)
  is export
{ * }

sub g_registered_type_info_get_type_name (GIRegisteredTypeInfo $info)
  returns Str
  is native(gir)
  is export
{ * }
