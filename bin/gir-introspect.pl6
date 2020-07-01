use v6.c;

use GIR::Raw::Types;

use GLib::Object::Type;
use GIR::Repository;
use GIR::ObjectInfo;

sub list-constant ($ci) {
  my $val = $ci.value;
  my $tn = $ci.type.tag-name;

  $val = "'{ $val }'" if $tn = 'char';
  "  { $ci.name } = { $val } ({ $*p.lc ~ $tn })\n";
}

sub list-constants {
  my $ret = '';
  if $*item.c-elems -> $nc {
    for ^$nc {
      my $ci = $*item.get-constant($_);
      next unless $ci.name;

      $ret ~= list-constant($ci);
    }
  }
  $ret;
}

sub list-fields {
  my $ret = '';
  if $*item.f-elems -> $nf {
    for ^$nf {
      my $fi = $*item.get-field($_);
      my $rw = '';
      $rw ~= 'R' if $fi.flags +& GI_FIELD_IS_READABLE;
      $rw ~= 'W' if $fi.flags +& GI_FIELD_IS_WRITABLE;

      $ret ~= "  { $fi.type.name // '' } { $fi.name } ({ $rw })\n";
    }
  }
  $ret;
}

sub list-properties {
  my $ret = '';
  if $*item.p-elems -> $nf {
    for ^$nf {
      my $fi = $*item.get-property($_);
      my $rw = '';
      $rw ~= 'R' if $fi.flags +& GI_FIELD_IS_READABLE;
      $rw ~= 'W' if $fi.flags +& GI_FIELD_IS_WRITABLE;

      $ret ~= "  { $fi.type.name // '' } { $fi.name } ({ $rw })\n";
    }
  }
  $ret;
}

multi sub ptr-mark(Bool $b) {
  $b ?? '*' !! '';
}
multi sub ptr-mark(GIR::TypeInfo $t) {
  ptr-mark($t.is-pointer);
}
multi sub ptr-mark (GIR::ArgInfo $a) {
  my $ptr = ($a.direction == (GI_DIRECTION_OUT, GI_DIRECTION_INOUT).any).so;
  return ptr-mark($a.type) unless $ptr;
  ptr-mark($ptr);
}

sub get-param-list ($mi) {
  return '' unless $mi.n-args;

  sub arg-str ($a) {
    #"{ $a.type.type-tag }{ $a.type.is-pointer ?? '*' !! '' }\t{ $a.name }";
    "{ $a.type.tag-name( prefix => $*p ) }{ ptr-mark($a) } { $a.name }";
  }

  return arg-str( $mi.get-arg(0) ) if $mi.n-args == 1;

  (" " x 25) ~ (
    gather for $mi.get-args[] {
      take arg-str($_)
    }
  ).join(",\n" ~ " " x 25)
}

sub list-interfaces {
  my $ret = '';

  if $*item.i-elems -> $nf {
    for ^$nf {
      my $i = $*item.get-interface($_);
      my $iname = $i.name;
      my $prefix = $*repo.get-c-prefix($i.namespace);
      $iname = $prefix ~ $iname if $prefix;

      $ret ~= "  { $iname }\n"
    }
  }
  $ret;
}

sub list-args ($mi, :$prefix = '') {
  class NoReturn {
    has $.name       = '';
    has $.is-pointer = False;
    has $.tag        = GI_TYPE_TAG_VOID;
  }

  my $rt = $mi.return-type // NoReturn.new;
  my $ret = '';
  my $name = $mi.name;
  $name = "{ $prefix }_{ $name }" if $prefix;

  $ret ~= '  ';
  if $mi.n-args == 1 {
    $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } ({
               get-param-list($mi) })\n\n";
    # $ret ~= "{ $rt.name }{ ptr-mark($rt) } {
    #       $mi.name } (\n{ '' })\n\n";=
  } elsif $mi.n-args {
    $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } (\n{
               get-param-list($mi) }\n{ ' ' x 23 })\n\n";
  } else {
    $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } ()\n\n";
  }
  $ret;
}

sub list-callables ($retrieve, $num) {
  my $ret = '';

  if $num -> $nm {
    $ret ~= list-args( $*item."$retrieve"($_) ) for ^$nm;
  }
  $ret;
}

sub list-methods {
  list-callables('get-method', $*item.m-elems);
}

sub list-signals {
  list-callables('get-signal', $*item.s-elems);
}

sub list-vfuncs {
  list-callables('get-vfunc', $*item.v-elems);
}

sub list-values {
  my $ret = '';

  if $*item.v-elems -> $nv {
    my @values = gather for ^$nv {
      take $*item.get-value($_);
    }
    my $mnl = @values.map( *.name.chars ).max;

    for @values {
      $ret ~= "  { .name.fmt("%-{ $mnl }s") } = { .value }\n";
    }
  }
  $ret;
}

multi sub print-item-info (GI_INFO_TYPE_CONSTANT) {
  $*item = GIR::ConstantInfo.new($*item.GIBaseInfo);

  say qq:to/CONSTINFO/;

  { list-constant($*item) }
  CONSTINFO
}
multi sub print-item-info (GI_INFO_TYPE_FUNCTION) {
  $*item = GIR::FunctionInfo.new($*item.GIBaseInfo);

  say qq:to/FUNCINFO/;

  { list-args( $*item, prefix => $*p.lc ) }
  FUNCINFO
}
multi sub print-item-info (GI_INFO_TYPE_ENUM) {
  $*item = GIR::EnumInfo.new($*item.GIBaseInfo);

  say qq:to/ENUMINFO/;

    Enum name: { $*item.name }
    ENUMINFO

  say qq:to/VALUEINFO/;
    Values: { $*item.v-elems }
    { list-values }
    VALUEINFO

  say qq:to/METHODINFO/    if $*all || $*methods;
    Methods: { $*item.m-elems }
    { list-methods }
    METHODINFO
}
multi sub print-item-info (GI_INFO_TYPE_OBJECT) {
  $*item = GIR::ObjectInfo.new($*item.GIBaseInfo);

  my $parent-name = $*item.parent ?? $*item.parent.name !! '';
  my $parent-prefix = $*repo.get-c-prefix($*item.parent.namespace);
  $parent-name //= 'None';
  $parent-name = $parent-prefix ~ $parent-name unless $parent-name eq 'None';

  say qq:to/OBJINFO/;

    Object name: { $*item.type-name } --- Parent: { $parent-name }
    OBJINFO

  say qq:to/CONSTANTINFO/  if $*all || $*constants;
    Constants: { $*item.c-elems }
    { list-constants }
    CONSTANTINFO

  say qq:to/FIELDINFO/     if $*all || $*fields;
    Fields: { $*item.f-elems }
    { list-fields }
    FIELDINFO

  say qq:to/PROPINFO/      if $*all || $*properties;
    Properties: { $*item.p-elems }
    { list-properties }
    PROPINFO

  say qq:to/IFACEINFO/     if $*all || $*interfaces;
    Requred interfaces: { $*item.i-elems }
    { list-interfaces }
    IFACEINFO

  say qq:to/METHODINFO/    if $*all || $*methods;
    Methods: { $*item.m-elems }
    { list-methods }
    METHODINFO

  say qq:to/SIGINFO/       if $*all || $*signals;
    Signals: { $*item.s-elems }
    { list-signals }
    SIGINFO

  say qq:to/VFUNCINFO/     if $*all || $*vfuncs
    V-Funcs: { $*item.v-elems }
    { list-vfuncs }
    VFUNCINFO
}

multi sub print-item-info ($a) {
  say "Type '$a' NYI";
}

sub print-all-items {
  my $ni = $*repo.get-n-infos($*namespace);
  say qq:to/INFO/;

  Prefix: { $*p }
  Number of Infos: { $ni }
  INFO

  my @infos = gather for ^$ni {
    take $*repo.get-info($*namespace, $_);
  };
  my $lin = @infos.map( *.name.chars ).max;

  for @infos {
    say "  { .name.fmt("%-{ $lin }s") } -- { .infotype }"
  }

  exit 0;
}

sub MAIN (
  $typelib,      #= Typelib to load
  $object?,      #= Object found within <typelib>
  :$all,         #= List everything
  :$constants,   #= List constants
  :$fields,      #= List fields
  :$properties,  #= List properties
  :$interfaces,  #= List interfaces
  :$methods,     #= List methods
  :$signals,     #= List signals
  :$values,      #= List values
  :$vfuncs       #= List vfuncs
) {
  # Exit upon ANY GError.
  $ERROR-IS-FATAL = True;

  my $*repo = GIR::Repository.get-default;
  my $t     = $*repo.require($typelib);
  my $*p    = $*repo.get-c-prefix($typelib);

  my $*namespace  = $typelib;
  my $*all        = $all;
  my $*constants  = $constants;
  my $*fields     = $fields;
  my $*properties = $properties;
  my $*interfaces = $interfaces;
  my $*methods    = $methods;
  my $*signals    = $signals;
  my $*values     = $values;
  my $*vfuncs     = $vfuncs;

  unless $*all || $object {
    say '--object or --all missing!';
    exit 1;
  }

  print-all-items if $*all && $object.not;

  my $*item = $*repo.find-by-name($typelib, $object);
  die "Could not find an object named '{ $object }'!" unless $*item;

  die "Do not know how to handle '$object'. Type unknown!"
    if $*item.infotype == GI_INFO_TYPE_UNRESOLVED;

  print-item-info($*item.infotype);
}
