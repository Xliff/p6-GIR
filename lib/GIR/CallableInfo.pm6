use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;
use GIR::Raw::CallableInfo;

use GIR::ArgInfo;
use GIR::BaseInfo;
use GIR::TypeInfo;

our subset GICallableInfoAncestry is export of Mu
  where GICallableInfo | GIBaseInfo;

class GIR::CallableInfo is GIR::BaseInfo {
  has GICallableInfo $!ci;

  submethod BUILD (:$callable-info) {
    self.setGICallableInfo($callable-info) if $callable-info;
  }

  method setGICallableInfo (GICallableInfoAncestry $_) {
    my $to-parent;

    $!ci = do {
      when GICallableInfo {
        $to-parent = cast(GIBaseInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GICallableInfo, $_);
      }
    }

    self.setGIBaseInfo($to-parent);
  }

  method GIR::Raw::Structs::GICallableInfo
    is also<GICallableInfo>
  { $!ci }

  method new (GICallableInfoAncestry $callable-info) {
    $callable-info ?? self.bless( :$callable-info ) !! Nil;
  }

  method can_throw_gerror is also<can-throw-gerror> {
    so g_callable_info_can_throw_gerror($!ci);
  }

  method get_arg (Int() $n, :$raw = False) is also<get-arg> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_args - 1;

    my gint $nn = $n;
    my $t = g_callable_info_get_arg($!ci, $nn);

    $t ??
      ( $raw ?? $t !! GIR::ArgInfo.new($t) )
      !!
      Nil;
  }

  method get_args (:$raw = False) is also<get-args> {
    my @args;

    for ^self.get_n_args {
      @args.push: self.get_arg($_, :$raw);
    }
    @args;
  }

  method get_caller_owns is also<get-caller-owns> {
    GITransferEnum( g_callable_info_get_caller_owns($!ci) );
  }

  method get_instance_ownership_transfer
    is also<get-instance-ownership-transfer>
  {
    GITransferEnum( g_callable_info_get_instance_ownership_transfer($!ci) );
  }

  method get_n_args
    is also<
      get-n-args
      n_args
      n-args
      a_elems
      a-elems
    >
  {
    g_callable_info_get_n_args($!ci);
  }

  method get_return_attribute (Str() $name) is also<get-return-attribute> {
    g_callable_info_get_return_attribute($!ci, $name);
  }

  method get_return_attributes is also<get-return-attributes> {
    my $i = GIAttributeIter.new;
    my @attrs;

    while self.iterate_return_attributes($i) -> $ra {
      @attrs.push: $ra;
    }
    @attrs;
  }

  method get_return_type (:$raw = False)
    is also<
      get-return-type
      return_type
      return-type
    >
  {
    my $t = g_callable_info_get_return_type($!ci);

    $t ??
      ( $raw ?? $t !! GIR::TypeInfo.new($t) )
      !!
      Nil;
  }

  multi method invoke (
    gpointer $function,
    @in,
    @out,
    GIArgument $return,
    Int() $is_method,
    Int() $throws,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my $in = GLib::Roles::TypedBuffer[GIArgument].new(@in);
    my $out = GLib::Roles::TypedfBuffer[GIArgument].new(@out);

    samewith(
      $function,
      $in.p,
      @in.elems,
      $out.p,
      @out.elems,
      $return,
      $is_method,
      $throws,
      $error
    );
  }
  multi method invoke (
    gpointer $function,
    Pointer $in_args,
    Int() $n_in_args,
    Pointer $out_args,
    Int() $n_out_args,
    GIArgument $return_value,
    Int() $is_method,
    Int() $throws,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gint ($ni, $no) = ($n_in_args, $n_out_args);
    my gboolean ($ism, $t) = ($is_method, $throws).map( *.so.Int );

    so g_callable_info_invoke(
      $!ci,
      $function,
      $in_args,
      $n_in_args,
      $out_args,
      $n_out_args,
      $return_value,
      $ism,
      $t,
      $error
    );
  }

  method is_method is also<is-method> {
    so g_callable_info_is_method($!ci);
  }

  proto method iterate_return_attributes (|)
    is also<iterate-return-attributes>
  { * }

  multi method iterate_return_attributes (GIAttributeIter $iterator) {
    my $rv = samewith($iterator, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method iterate_return_attributes (
    GIAttributeIter $iterator,
    $name  is rw,
    $value is rw,
    :$all = False
  ) {
    my ($n, $v) = CArray[Str].new xx 2;
    ($n[0], $v[0]) = Str xx 2;

    my $rv = so g_callable_info_iterate_return_attributes(
      $!ci,
      $iterator,
      $n,
      $v
    );
    ($name, $value) = ppr($n, $v);
    $all.not ?? $rv !! ($rv, $name, $value);
  }

  method load_arg (Int() $n, GIArgInfo() $arg) is also<load-arg> {
    die "Index $n out of range in { ::?CLASS.^name }.{ $*ROUTINE.name }"
      if $n > self.get_n_args - 1;

    my gint $nn = $n;

    g_callable_info_load_arg($!ci, $nn, $arg);
  }

  method load_return_type (GITypeInfo $type) is also<load-return-type> {
    g_callable_info_load_return_type($!ci, $type);
  }

  method may_return_null is also<may-return-null> {
    so g_callable_info_may_return_null($!ci);
  }

  method skip_return is also<skip-return> {
    so g_callable_info_skip_return($!ci);
  }

}
