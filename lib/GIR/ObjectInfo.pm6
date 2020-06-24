use v6.c;

use Method::Also;

use NativeCall;

use GIR::Raw::Types;
use GIR::Raw::ObjectInfo;

use GIR::ConstantInfo;
use GIR::FieldInfo;
use GIR::FunctionInfo;
use GIR::InterfaceInfo;
use GIR::PropertyInfo;
use GIR::RegisteredTypeInfo;
use GIR::SignalInfo;
use GIR::StructInfo;
use GIR::VFuncInfo;

our subset GIObjectInfoAncestry is export of Mu
  where GIObjectInfo | GIRegisteredTypeInfoAncestry;

class GIR::ObjectInfo is GIR::RegisteredTypeInfo {
  has GIObjectInfo $!oi;

  submethod BUILD (:$object-info) {
    self.setObjectInfo($object-info) if $object-info;
  }

  method setObjectInfo (GIObjectInfoAncestry $_) {
    my $to-parent;

    $!oi = do {
      when GIObjectInfo {
        $to-parent = cast(GIRegisteredTypeInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GIObjectInfo, $_);
      }
    }

    self.setGIRegisteredTypeInfo($to-parent);
  }

  method GStreamer::Raw::Objects::GIObjectInfo
    is also<GIObjectInfo>
  { $!oi }

  method new (GIObjectInfoAncestry $object-info) {
    $object-info ?? self.bless(:$object-info) !! Nil;
  }

  method find_method (Str() $name, :$raw = False) is also<find-method> {
    my $m = g_object_info_find_method($!oi, $name);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method find_method_using_interfaces (
    Str() $name,
    GIObjectInfo() $implementor,
    :$raw = False;
  )
    is also<find-method-using-interfaces>
  {
    my $m = g_object_info_find_method_using_interfaces(
      $!oi,
      $name,
      $implementor
    );

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method find_signal (Str() $name, :$raw = False) is also<find-signal> {
    my $s = g_object_info_find_signal($!oi, $name);

    $s ??
      ( $raw ?? $s !! GIR::SignalInfo.new($s) )
      !!
      Nil;
  }

  method find_vfunc (Str() $name, :$raw = False) is also<find-vfunc> {
    my $v = g_object_info_find_vfunc($!oi, $name);

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

  method find_vfunc_using_interfaces (
    Str() $name,
    GIObjectInfo() $implementor,
    :$raw = False
  )
    is also<find-vfunc-using-interfaces>
  {
    my $v = g_object_info_find_vfunc_using_interfaces(
      $!oi,
      $name,
      $implementor
    );

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

  method get_abstract
    is also<
      get-abstract
      is_abstract
      is-abstract
      abstract
    >
  {
    so g_object_info_get_abstract($!oi);
  }

  method get_class_struct (:$raw = False) is also<get-class-struct> {
    my $s = g_object_info_get_class_struct($!oi);

    $s ??
      ( $raw ?? $s !! GIR::StructInfo.new($s) )
      !!
      Nil;
  }

  method get_constant (Int() $n, :$raw = False) is also<get-constant> {
    my gint $nn = $n;
    my $c = g_object_info_get_constant($!oi, $nn);

    $c ??
      ( $raw ?? $c !! GIR::ConstantInfo.new($c) )
      !!
      Nil;
  }

  method get_field (Int() $n, :$raw = False) is also<get-field> {
    my gint $nn = $n;
    my $f = g_object_info_get_field($!oi, $nn);

    $f ??
      ( $raw ?? $f !! GIR::FieldInfo.new($f) )
      !!
      Nil;
  }

  method get_fundamental
    is also<
      get-fundamental
      is_fundamental
      is-fundamental
      fundamental
    >
  {
    so g_object_info_get_fundamental($!oi);
  }

  method get_get_value_function is also<
    get-get-value-function
    get_value_function
    get-value-function
  > {
    g_object_info_get_get_value_function($!oi);
  }

  method get_get_value_function_pointer
    is also<
      get-get-value-function-pointer
      get_value_function_pointer
      get-value-function-pointer
    >
  {
    g_object_info_get_get_value_function_pointer($!oi);
  }

  method get_interface (Int() $n, :$raw = False) is also<get-interface> {
    my gint $nn = $n;
    my $i = g_object_info_get_interface($!oi, $nn);

    $i ??
      ( $raw ?? $i !! GIR::InterfaceInfo.new($i) )
      !!
      Nil
  }

  method get_method (Int() $n, :$raw = False) is also<get-method> {
    my gint $nn = $n;
    my $m = g_object_info_get_method($!oi, $nn);

    $m ??
      ( $raw ?? $m !! GIR::FunctionInfo.new($m) )
      !!
      Nil;
  }

  method get_n_constants
    is also<
      get-n-constants
      n_constants
      n-constants
      c_elems
      c-elems
    >
  {
    g_object_info_get_n_constants($!oi);
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
    g_object_info_get_n_fields($!oi);
  }

  method get_n_interfaces
    is also<
      get-n-interfaces
      n_interfaces
      n-interfaces
      i_elems
      i-elems
    >
  {
    g_object_info_get_n_interfaces($!oi);
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
    g_object_info_get_n_methods($!oi);
  }

  method get_n_properties
    is also<
      get-n-properties
      n_properties
      n-properties
      p_elems
      p-elems
    >
  {
    g_object_info_get_n_properties($!oi);
  }

  method get_n_signals
    is also<
      get-n-signals
      n_signals
      n-signals
      s_elems
      s-elems
    >
  {
    g_object_info_get_n_signals($!oi);
  }

  method get_n_vfuncs
    is also<
      get-n-vfuncs
      n_vfuncs
      n-vfuncs
      v_elems
      v-elems
    >
  {
    g_object_info_get_n_vfuncs($!oi);
  }

  method get_parent (:$raw = False)
    is also<
      get-parent
      parent
    >
  {
    my $po = g_object_info_get_parent($!oi);

    $po ??
      ( $raw ?? $po !! GIR::ObjectInfo.new($po) )
      !!
      Nil;
  }

  method get_property (Int() $n, :$raw = False) is also<get-property> {
    my gint $nn = $n;
    my $p = g_object_info_get_property($!oi, $nn);

    $p ??
      ( $raw ?? $p !! GIR::PropertyInfo.new($p) )
      !!
      Nil;
  }

  method get_ref_function
    is also<
      get-ref-function
      ref_function
      ref-function
    >
  {
    g_object_info_get_ref_function($!oi);
  }

  method get_ref_function_pointer
    is also<
      get-ref-function-pointer
      ref_function_pointer
      ref-function-pointer
    >
  {
    g_object_info_get_ref_function_pointer($!oi);
  }

  method get_set_value_function
    is also<
      get-set-value-function
      set_value_function
      set-value-function
    >
  {
    g_object_info_get_set_value_function($!oi);
  }

  method get_set_value_function_pointer
    is also<
      get-set-value-function-pointer
      set_value_function_pointer
      set-value-function-pointer
    >
  {
    g_object_info_get_set_value_function_pointer($!oi);
  }

  method get_signal (Int() $n, :$raw = False) is also<get-signal> {
    my gint $nn = $n;
    my $s = g_object_info_get_signal($!oi, $nn);

    $s ??
      ( $raw ?? $s !! GIR::SignalInfo.new($s) )
      !!
      Nil;
  }

  method get_type_init
    is also<
      get-type-init
      type_init
      type-init
    >
  {
    g_object_info_get_type_init($!oi);
  }

  method get_type_name
    is also<
      get-type-name
      type_name
      type-name
    >
  {
    g_object_info_get_type_name($!oi);
  }

  method get_unref_function
    is also<
      get-unref-function
      unref_function
      unref-function
    >
  {
    g_object_info_get_unref_function($!oi);
  }

  method get_unref_function_pointer
    is also<
      get-unref-function-pointer
      unref_function_pointer
      unref-function-pointer
    >
  {
    g_object_info_get_unref_function_pointer($!oi);
  }

  method get_vfunc (Int() $n, :$raw = False) is also<get-vfunc> {
    my gint $nn = $n;
    my $v = g_object_info_get_vfunc($!oi, $nn);

    $v ??
      ( $raw ?? $v !! GIR::VFuncInfo.new($v) )
      !!
      Nil;
  }

}
