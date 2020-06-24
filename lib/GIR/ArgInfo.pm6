use v6.c;

use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::ArgInfo;

use GIR::BaseInfo;
use GIR::TypeInfo;

our subset GIArgInfoAncestry is export of Mu
  where GIArgInfo | GIBaseInfo;

class GIR::ArgInfo is GIR::BaseInfo {
  has GIArgInfo $!ai;

  submethod BUILD (:$arg-info) {
    self.setGIArgInfo($arg-info) if $arg-info;
  }

  method setGIArgInfo (GIArgInfoAncestry $_) {
    my $to-parent;

    $!ai = do {
      when GIArgInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIArgInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GIArgInfo
    is also<GIArgInfo>
  { $!ai }

  method new (GIArgInfoAncestry $arg-info) {
    $arg-info ?? self.bless( :$arg-info ) !! Nil;
  }

  method get_closure
    is also<
      get-closure
      closure
    >
  {
    g_arg_info_get_closure($!ai);
  }

  method get_destroy
    is also<
      get-destroy
      destroy
    >
  {
    g_arg_info_get_destroy($!ai);
  }

  method get_direction
    is also<
      get-direction
      direction
    >
  {
    GIDirectionEnum( g_arg_info_get_direction($!ai) );
  }

  method get_ownership_transfer
    is also<
      get-ownership-transfer
      ownership_transfer
      ownership-transfer
    >
  {
    GITransferEnum( g_arg_info_get_ownership_transfer($!ai) );
  }

  method get_scope
    is also<
      get-scope
      scope
    >
  {
    GIScopeTypeEnum( g_arg_info_get_scope($!ai) );
  }

  method get_type (:$raw = False)
    is also<
      get-type
      get_typeinfo
      get-typeinfo
      typeinfo
    >
  {
    my $t = g_arg_info_get_type($!ai);

    $t ??
      ( $raw ?? $t !! GIR::TypeInfo.new($t) )
      !!
      Nil;
  }

  method is_caller_allocates is also<is-caller-allocates> {
    so g_arg_info_is_caller_allocates($!ai);
  }

  method is_optional is also<is-optional> {
    so g_arg_info_is_optional($!ai);
  }

  method is_return_value is also<is-return-value> {
    so g_arg_info_is_return_value($!ai);
  }

  method is_skip is also<is-skip> {
    so g_arg_info_is_skip($!ai);
  }

  method load_type (GITypeInfo $type) is also<load-type> {
    g_arg_info_load_type($!ai, $type);
  }

  method may_be_null is also<may-be-null> {
    so g_arg_info_may_be_null($!ai);
  }

}
