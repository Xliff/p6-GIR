use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::TypeInfo;

use GIR::BaseInfo;

our subset GITypeInfoAncestry is export of Mu
  where GITypeInfo | GIBaseInfo;

class GIR::TypeInfo is GIR::BaseInfo {
  has GITypeInfo $!ti;

  submethod BUILD (:$type-info) {
    self.setGITypeInfo($type-info) if $type-info;
  }

  method setGITypeInfo (GITypeInfoAncestry $_) {
    my $to-parent;

    $!ti = do {
      when GITypeInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GITypeInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GITypeInfo
    is also<GITypeInfo>
  { $!ti }

  method new (GITypeInfoAncestry $type-info) {
    $type-info ?? self.bless( :$type-info ) !! Nil;
  }

  # Place in a catch-all?
  #
  # method g_info_type_to_string {
  #   g_info_type_to_string($!ti);
  # }
  #
  method tag_to_string ()
    is also<
      tag-to-string
      tag_name
      tag-name
    >
  {
    my GITypeTag $tt = self.get_tag;

    do given (g_type_tag_to_string($tt) // '') {
      when 'utf8'            { 'char' }
      when none('interface') { $_     }

      default {
        # Last chance replacement, here.
        $_;
      }
    }
  }

  method get_array_fixed_size
    is also<
      get-array-fixed-size
      array_fixed_size
      array-fixed-size
    >
  {
    g_type_info_get_array_fixed_size($!ti);
  }

  method get_array_length
    is also<
      get-array-length
      array_length
      array-length
    >
  {
    g_type_info_get_array_length($!ti);
  }

  method get_array_type
    is also<
      get-array-type
      array_type
      array-type
    >
  {
    GIArrayTypeEnum( g_type_info_get_array_type($!ti) );
  }

  method get_interface (:$raw = False)
    is also<
      get-interface
      interface
    >
  {
    my $b = g_type_info_get_interface($!ti);

    $b ??
      ( $raw ?? $b !! GIR::BaseInfo.new($b) )
      !!
      Nil;
  }

  method get_param_type (Int() $n, :$raw = False) is also<get-param-type> {
    # cw: Where is get_n_params?
    #
    # die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
    #   if $n > self.get_n_params - 1;

    my gint $nn = $n;
    my $ti = g_type_info_get_param_type($!ti, $nn);

    $ti ??
      ( $raw ?? $ti !! GIR::TypeInfo.new($ti) )
      !!
      Nil;
  }

  method get_tag
    is also<
      get-tag
      tag
    >
  {
    GITypeTagEnum( g_type_info_get_tag($!ti) );
  }

  method is_pointer is also<is-pointer> {
    so g_type_info_is_pointer($!ti);
  }

  method is_zero_terminated is also<is-zero-terminated> {
    so g_type_info_is_zero_terminated($!ti);
  }

}
