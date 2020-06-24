use v6.c;

use Method::Also;

use GIR::Raw::Types;

use GIR::BaseInfo;

our subset GIConstantInfoAncestry is export of Mu
  where GIConstantInfo | GIBaseInfo;

class GIR::ConstantInfo is GIR::BaseInfo {
  has GIConstantInfo $!ci;

  submethod BUILD (:$constant-info) {
    self.setGIConstantInfo($constant-info) if $constant-info;
  }

  method setGIConstantInfo (GIConstantInfoAncestry $_) {
    my $to-parent;

    $!ci = do {
      when GIConstantInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIConstantInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GIConstantInfo
    is also<GIConstantInfo>
  { $!ci }

  method new (GIConstantInfoAncestry $constant-info) {
    $constant-info ?? self.bless( :$constant-info ) !! Nil;
  }

  # Should be moved to the GIArgument class.
  #
  # The problem being the first argument. There may have to be a bit of
  # trickery required to get this to work at the CPointer level!
  method free_value (GIArgument $value)
    is also<free-value>
  {
    g_constant_info_free_value($!ci, $value);
  }

  method get_type (:$raw = False) is also<get-type> {
    my $t = g_constant_info_get_type($!ci);

    $t ??
      ( $raw ?? $t !! GIR::TypeInfo.new($t) )
      !!
      Nil;
  }

  proto method get_value (|)
    is also<get-value>
  { * }

  multi method get_value  {
    my $v  = GIArgument.new;

    samewith($v);
    $v;
  }
  multi method get_value (GIArgument $value) {
    g_constant_info_get_value($!ci, $value);
  }

}


### /usr/include/gobject-introspection-1.0/giconstantinfo.h

sub g_constant_info_free_value (GIConstantInfo $info, GIArgument $value)
  is native(gir)
  is export
{ * }

sub g_constant_info_get_type (GIConstantInfo $info)
  returns GITypeInfo
  is native(gir)
  is export
{ * }

sub g_constant_info_get_value (GIConstantInfo $info, GIArgument $value)
  returns gint
  is native(gir)
  is export
{ * }
