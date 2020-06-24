use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::FieldInfo;

use GIR::BaseInfo;

our subset GIFieldInfoAncestry is export of Mu
  where GIFieldInfo | GIBaseInfo;

class GIR::FieldInfo is GIR::BaseInfo {
  has GIFieldInfo $!fi;

  submethod BUILD (:$field-info) {
    self.setGIFieldInfo($field-info) if $field-info;
  }

  method setGIFieldInfo (GIFieldInfoAncestry $_) {
    my $to-parent;

    $!fi = do {
      when GIFieldInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIFieldInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GIFieldInfo
    is also<GIFieldInfo>
  { $!fi }

  method new (GIFieldInfoAncestry $field-info) {
    $field-info ?? self.bless( :$field-info ) !! Nil;
  }

  method get_field (gpointer $mem, GIArgument $value) is also<get-field> {
    so g_field_info_get_field($!fi, $mem, $value);
  }

  method get_flags
    is also<
      get-flags
      flags
    >
  {
    GIFieldInfoFlagsEnum( g_field_info_get_flags($!fi) );
  }

  method get_offset
    is also<
      get-offset
      offset
    >
  {
    g_field_info_get_offset($!fi);
  }

  method get_size
    is also<
      get-size
      size
    >
  {
    g_field_info_get_size($!fi);
  }

  method get_type (:$raw = False)
    is also<
      get-type
      type
    >
  {
    my $t = g_field_info_get_type($!fi);

    $t ??
      ( $raw ?? $t !! GIR::TypeInfo.new($t) )
      !!
      Nil;
  }

  method set_field (gpointer $mem, GIArgument $value) is also<set-field> {
    so g_field_info_set_field($!fi, $mem, $value);
  }

}
