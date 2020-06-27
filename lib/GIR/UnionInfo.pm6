use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::UnionInfo;

use GIR::ConstantInfo;
use GIR::FieldInfo;
use GIR::FunctionInfo;
use GIR::RegisteredTypeInfo;
use GIR::TypeInfo;

our subset GIUnionInfoAncestry is export of Mu
  where GIUnionInfo | GIRegisteredTypeInfoAncestry;

class GIR::UnionInfo is GIR::RegisteredTypeInfo {
  has GIUnionInfo $!ui;

  submethod BUILD (:$union-info) {
    self.setUnionInfo($union-info) if $union-info;
  }

  method setUnionInfo (GIUnionInfoAncestry $_) {
    my $to-parent;

    $!ui = do {
      when GIUnionInfo {
        $to-parent = cast(GIRegisteredTypeInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIUnionInfo, $_);
      }
    }

    self.setGIRegisteredTypeInfo($to-parent);
  }

  method GStreamer::Raw::Unions::GIUnionInfo
    is also<GIUnionInfo>
  { $!ui }

  method new (GIUnionInfoAncestry $union-info) {
    $union-info ?? self.bless(:$union-info) !! Nil;
  }

  method find_method (Str() $name, :$raw = False) is also<find-method> {
    my $m = g_union_info_find_method($!ui, $name);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method get_alignment
    is also<
      get-alignment
      alignment
    >
  {
    g_union_info_get_alignment($!ui);
  }

  method get_discriminator (Int() $n, :$raw = False)
    is also<get-discriminator>
  {
    my gint $nn = $n;
    my $c = g_union_info_get_discriminator($!ui, $nn);

    $c ??
      ( $raw ?? $c !! GIR::ConstantInfo.new($c) )
      !!
      Nil;
  }

  method get_discriminator_offset
    is also<
      get-discriminator-offset
      discriminator_offset
      discriminator-offset
    >
  {
    g_union_info_get_discriminator_offset($!ui);
  }

  method get_discriminator_type (:$raw = False)
    is also<
      get-discriminator-type
      discriminator_type
      discriminator-type
    >
  {
    my $t = g_union_info_get_discriminator_type($!ui);

    $t ??
      ( $raw ?? $t !! GIR::TypeInfo.new($t) )
      !!
      Nil;
  }

  method get_field (Int() $n, :$raw = False) is also<get-field> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_fields - 1;

    my gint $nn = $n;
    my $f = g_union_info_get_field($!ui, $nn);

    $f ??
      ( $raw ?? $f !! GIR::FieldInfo.new($f) )
      !!
      Nil;
  }

  method get_method (Int() $n, :$raw = False) is also<get-method> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_methods - 1;

    my gint $nn = $n;
    my $m = g_union_info_get_method($!ui, $nn);

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
    g_union_info_get_n_fields($!ui);
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
    g_union_info_get_n_methods($!ui);
  }

  method get_size
    is also<
      get-size
      size
    >
  {
    g_union_info_get_size($!ui);
  }

  method is_discriminated is also<is-discriminated> {
    so g_union_info_is_discriminated($!ui);
  }

}
