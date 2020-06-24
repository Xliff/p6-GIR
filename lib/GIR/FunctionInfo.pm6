use v6.c;

use NativeCall;
use Method::Also;

use GIR::Raw::Types;
use GIR::Raw::FunctionInfo;

use GIR::CallableInfo;

our subset GIFunctionInfoAncestry is export of Mu
  where GIFunctionInfo | GICallableInfoAncestry;

class GIR::FunctionInfo is GIR::CallableInfo {
  has GIFunctionInfo $!fi;

  submethod BUILD (:$function-info) {
    self.setGIFunctionInfo($function-info) if $function-info;
  }

  method setGIFunctionInfo (GIFunctionInfoAncestry $_) {
    my $to-parent;

    $!fi = do {
      when GIFunctionInfo {
        $to-parent = cast(GICallableInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIFunctionInfo, $_);
      }
    }

    self.setGICallableInfo($to-parent);
  }

  method GIR::Raw::Structs::GIFunctionInfo
    is also<GIFunctionInfo>
  { $!fi }

  method new (GIFunctionInfoAncestry $function-info) {
    $function-info ?? self.bless( :$function-info ) !! Nil;
  }

  method get_flags
    is also<
      get-flags
      flags
    >
  {
    GIFunctionInfoFlagsEnum( g_function_info_get_flags($!fi) );
  }

  method get_property
    is also<
      get-property
      property
    >
  {
    g_function_info_get_property($!fi);
  }

  method get_symbol
    is also<
      get-symbol
      symbol
    >
  {
    g_function_info_get_symbol($!fi);
  }

  method get_vfunc
    is also<
      get-vfunc
      vfunc
    >
  {
    g_function_info_get_vfunc($!fi);
  }

  multi method invoke (
    @in,
    @out,
    GIArgument $return,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my $in = GLib::Roles::TypedBuffer[GIArgument].new(@in);
    my $out = GLib::Roles::TypedBuffer[GIArgument].new(@out);

    samewith($in.p, @in.elems, $out.p, @out.elems, $return, $error);
  }
  multi method invoke (
    Pointer $in_args,
    Int() $n_in_args,
    Pointer $out_args,
    Int() $n_out_args,
    GIArgument $return_value,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gint ($ni, $no) = ($n_in_args, $n_out_args);

    clear_error;
    my $rv = so g_function_info_invoke(
      $!fi,
      $in_args,
      $ni,
      $out_args,
      $no,
      $return_value,
      $error
    );
    set_error($error);
    $rv;
  }

  method invoke_error_quark (GIR::FunctionInfo:U: )
    is also<invoke-error-quark>
  {
    g_invoke_error_quark();
  }

}
