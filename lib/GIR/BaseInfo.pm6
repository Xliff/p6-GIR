use v6.c;

use NativeCall;
use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::BaseInfo;

use GIR::Typelib;

use GLib::Roles::Object;

class GIR::BaseInfo {
  has GIBaseInfo $!bi;

  submethod BUILD (:$base-info) {
    self.setGIBaseInfo($base-info) if $base-info;
  }

  # Protected
  method setGIBaseInfo (GIBaseInfo $base-info) {
    $!bi = $base-info;
  }

  method GIR::Raw::Structs::GIBaseInfo
    is also<GIBaseInfo>
  { $!bi }

  multi method new (GIBaseInfo $base-info) {
    $base-info ?? self.bless( :$base-info ) !! Nil;
  }
  multi method new (
    Int() $type,
    GIBaseInfo() $container,
    Int() $typelib,
    Int() $offset
  ) {
    my GIInfoType $t = $type;
    my GITypelib $tl = $typelib;
    my guint32    $o = $offset;
    my    $base-info = g_info_new($t, $container, $tl, $o);

    $base-info ?? self.bless(:$base-info) !! Nil;
  }

  method equal (GIBaseInfo() $info2) {
    g_base_info_equal($!bi, $info2);
  }

  method get_attribute (Str() $name)
    is also<
      get-attribute
      attribute
    >
  {
    g_base_info_get_attribute($!bi, $name);
  }

  method get_attributes
    is also<
      get-attriubutes
      attributes
    >
  {
    my $i = GIAttributeIter.new;
    my @attrs;

    while self.iterate_attributes($i) -> $nv {
      @attrs.push: $nv;
    }
    @attrs;
  }

  method get_container (:$raw = False)
    is also<
      get-container
      container
    >
  {
    my $c = g_base_info_get_container($!bi);

    $c ??
      ( $raw ?? $c !! GIR::BaseInfo.new($c) )
      !!
      Nil;
  }

  method get_name (:$prefix = '')
    is also<
      get-name
      name
    >
  {
    my $n = g_base_info_get_name($!bi) // '';
    $n = $prefix ~ $n if $n && $prefix;
    $n;
  }

  method get_namespace
    is also<
      get-namespace
      namespace
    >
  {
    g_base_info_get_namespace($!bi) // '';
  }

  method get_infotype
    is also<
      get-infotype
      infotype
    >
  {
    GIInfoTypeEnum( g_base_info_get_type($!bi) );
  }

  method get_typelib (:$raw = False)
    is also<
      get-typelib
      typelib
    >
  {
    my $tl = g_base_info_get_typelib($!bi);

    $tl ??
      ( $raw ?? $tl !! GIR::Typelib.new($tl) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &g_base_info_gtype_get_type, $n, $t );
  }

  method is_deprecated is also<is-deprecated> {
    so g_base_info_is_deprecated($!bi);
  }

  proto method iterate_attributes
    is also<iterate-attributes>
  { * }

  multi method iterate_attributes (GIAttributeIter() $iterator) {
    my $rv = samewith($iterator, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method iterate_attributes (
    GIAttributeIter() $iterator,
    $name  is rw,
    $value is rw,
    :$all = False
  ) {
    my ($n, $v) = CArray[Str].new xx 2;
    ($n[0], $v[0]) = Str xx 2;

    my $rv = so g_base_info_iterate_attributes($!bi, $iterator, $n, $v);
    ($name, $value) = ppr($n, $v);
    $all.not ?? $rv !! ($rv, $name, $value)
  }

  method ref {
    g_base_info_ref($!bi);
    self;
  }

  method unref {
    g_base_info_unref($!bi);
  }

}

multi infix:<===> (GIBaseInfo $a, GIBaseInfo $b) is export {
  $a.equal($b);
}
