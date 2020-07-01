use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::StructInfo;

use GIR::FieldInfo;
use GIR::FunctionInfo;
use GIR::RegisteredTypeInfo;

our subset GIStructInfoAncestry is export of Mu
  where GIStructInfo | GIRegisteredTypeInfoAncestry;

class GIR::StructInfo is GIR::RegisteredTypeInfo {
  has GIStructInfo $!si;

  submethod BUILD (:$struct-info) {
    self.setStructInfo($struct-info) if $struct-info;
  }

  method setStructInfo (GIStructInfoAncestry $_) {
    my $to-parent;

    $!si = do {
      when GIStructInfo {
        $to-parent = cast(GIRegisteredTypeInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIStructInfo, $_);
      }
    }

    self.setGIRegisteredTypeInfo($to-parent);
  }

  method GStreamer::Raw::Structs::GIStructInfo
    is also<GIStructInfo>
  { $!si }

  method new (GIStructInfoAncestry $struct-info) {
    $struct-info ?? self.bless(:$struct-info) !! Nil;
  }

  method find_field (Str() $name, :$raw = False) is also<find-field> {
    my $f = g_struct_info_find_field($!si, $name);

    $f ??
      ( $raw ?? $f !! GIR::FieldInfo.new($f) )
      !!
      Nil;
  }

  method find_method (Str() $name, :$raw = False) is also<find-method> {
    my $m = g_struct_info_find_method($!si, $name);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo($m) )
      !!
      Nil;
  }

  method get_alignment is also<get-alignment> {
    g_struct_info_get_alignment($!si);
  }

  method get_field (Int() $n, :$raw = False) is also<get-field> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_fields - 1;

    my gint $nn = $n;
    my $f = g_struct_info_get_field($!si, $nn);

    $f ??
      ( $raw ?? $f !! GIR::FieldInfo.new($f) )
      !!
      Nil;
  }

  method get_method (Int() $n, :$raw = False) is also<get-method> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_methods - 1;

    my gint $nn = $n;
    my $m = g_struct_info_get_method($!si, $nn);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method get_n_fields
    is also<
      get-n-fields
      n_fields
      n-fields
      f_elems
      f-elems
    >
  {
    g_struct_info_get_n_fields($!si);
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
    g_struct_info_get_n_methods($!si);
  }

  method get_size
    is also<
      get-size
      size
    >
  {
    g_struct_info_get_size($!si);
  }

  method is_foreign is also<is-foreign> {
    so g_struct_info_is_foreign($!si);
  }

  method is_gtype_struct
    is also<
      is-gtype-struct
      is_gtype
      is-gtype
    >
  {
    so g_struct_info_is_gtype_struct($!si);
  }
}
