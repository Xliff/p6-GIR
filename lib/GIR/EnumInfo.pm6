use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::EnumInfo;

use GIR::RegisteredTypeInfo;
use GIR::FunctionInfo;

our subset GIEnumInfoAncestry is export of Mu
  where GIEnumInfo | GIRegisteredTypeInfoAncestry;

class GIR::EnumInfo is GIR::RegisteredTypeInfo {
  has GIEnumInfo $!ei;

  submethod BUILD (:$enum-info) {
    self.setEnumInfo($enum-info) if $enum-info;
  }

  method setEnumInfo (GIEnumInfoAncestry $_) {
    my $to-parent;

    $!ei = do {
      when GIEnumInfo {
        $to-parent = cast(GIRegisteredTypeInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIRegisteredTypeInfo, $_);
      }
    }

    self.setGIRegisteredTypeInfo($to-parent);
  }

  method GStreamer::Raw::Structs::GIEnumInfo
    is also<GIEnumInfo>
  { $!ei }

  method new (GIEnumInfoAncestry $enum-info) {
    $enum-info ?? self.bless(:$enum-info) !! Nil;
  }

  # Hrm.
  method g_value_info_get_value (GIValueInfo() $info)
    is also<g-value-info-get-value>
  {
    g_value_info_get_value($info);
  }

  method get_error_domain is also<get-error-domain> {
    g_enum_info_get_error_domain($!ei);
  }

  method get_method (Int() $n, :$raw = False) is also<get-method> {
    my gint $nn = $n;
    my $fi = g_enum_info_get_method($!ei, $nn);

    $fi ??
      ( $raw ?? $fi !! GIR::FunctionInfo.new($fi) )
      !!
      Nil;
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
    g_enum_info_get_n_methods($!ei);
  }

  method get_n_values
    is also<
      get-n-values
      n_values
      n-values
      v_elems
      v-elems
    >
  {
    g_enum_info_get_n_values($!ei);
  }

  method get_storage_type
    is also<
      get-storage-type
      storage_type
      storage-type
    >
  {
    GITypeTagEnum( g_enum_info_get_storage_type($!ei) );
  }

  method get_value (Int() $n) is also<get-value> {
    my gint $nn = $n;

    g_enum_info_get_value($!ei, $n);
  }

}