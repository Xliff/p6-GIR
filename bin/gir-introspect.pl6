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

multi sub ptr-mark(Bool $b) {
  $b ?? ' *' !! '';
}
multi sub ptr-mark(GIR::TypeInfo $t) {
  ptr-mark($t.is-pointer);
}
multi sub ptr-mark (GIR::ArgInfo $a) {
  my $ptr = ($a.direction == (GI_DIRECTION_OUT, GI_DIRECTION_INOUT).any).so;

  return ptr-mark($a.type) unless $ptr;
  ptr-mark($ptr);
}

sub list-fields {
  my $ret = '';
  if $*item.f-elems -> $nf {
    my ($tmax, $fmax) = 0 xx 2;
    my @f = do gather for ^$nf {
      my $f = $*item.get-field($_);
      my $v = {
        flags      => $f.flags,
        field-name => $f.name,
        type-name  => ($f.type.tag-name( prefix => $*p ) // '') ~
                       ptr-mark($f.type)
      };

      $fmax = ($fmax, $v<field-name>.chars).max;
      $tmax = ($tmax, $v<type-name>.chars).max;
      take $v;
    }

    for @f {
      my $rw = '';

      $rw ~= 'R' if .<flags> +& GI_FIELD_IS_READABLE;
      $rw ~= 'W' if .<flags> +& GI_FIELD_IS_WRITABLE;
      $ret ~= "  {  .<type-name>.fmt("%-{ $tmax }s") } {
                   .<field-name>.fmt("%-{ $fmax}s") } ({ $rw })\n";
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
    $ret ~= "{ ( $rt.tag-name( prefix => $*p ) ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } ({
               get-param-list($mi) })\n\n";
  } elsif $mi.n-args {
    $ret ~= "{ ( $rt.tag-name( prefix => $*p ) ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } (\n{
               get-param-list($mi) }\n{ ' ' x 23 })\n\n";
  } else {
    $ret ~= "{ ( $rt.tag-name( prefix => $*p ) ~
                 ptr-mark($rt) ).fmt('%-20s') } { $name } ()\n\n";
  }
  $ret;
}

sub list-callables ($retrieve, $num, :$prefix = '') {
  my $ret = '';

  if $num -> $nm {
    $ret ~= list-args($*item."$retrieve"($_), :$prefix) for ^$nm;
  }
  $ret;
}

sub list-methods {
  my $prefix = $*p.lc ~ '_' ~ $*item.name.lc;

  list-callables('get-method',  $*item.m-elems, :$prefix);
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
multi sub print-item-info (
  $a where * == GI_INFO_TYPE_FUNCTION | GI_INFO_TYPE_CALLBACK
) {
  my $prefix;

  $*item = GIR::FunctionInfo.new($*item.GIBaseInfo);
  $prefix = $*p.lc if $a == GI_INFO_TYPE_FUNCTION;

  say qq:to/FUNCINFO/;

  { list-args( $*item, :$prefix ) }
  FUNCINFO
}
multi sub print-item-info (
  $a where * == GI_INFO_TYPE_STRUCT | GI_INFO_TYPE_UNION
) {
  my $typename;
  ($typename, $*item) = do {
    when $a == GI_INFO_TYPE_STRUCT {
      ( 'Struct', GIR::StructInfo.new($*item.GIBaseInfo) )
    }

    default {
      ( 'Union', GIR::UnionInfo.new($*item.GIBaseInfo) )
    }
  }

  say qq:to/STRUCTINFO/;

    { $typename } name: { $*p ~ $*item.name } -- Size: { $*item.size } bytes
    Registered: { $*item.is-gtype ?? 'Yes' !! 'No' }
    STRUCTINFO

  say qq:to/FIELDINFO/     if $*all || $*fields;
    Fields: { $*item.f-elems }
    { list-fields }
    FIELDINFO

  say qq:to/METHODINFO/    if $*all || $*methods;
    Methods: { $*item.m-elems }
    { list-methods }
    METHODINFO
}
multi sub print-item-info (
  $a where * == GI_INFO_TYPE_ENUM | GI_INFO_TYPE_FLAGS
) {
  my $typename = $a == GI_INFO_TYPE_ENUM ?? 'Enum' !! 'Flags';

  $*item = GIR::EnumInfo.new($*item.GIBaseInfo);

  say qq:to/ENUMINFO/;

    { $typename } name: { $*item.name }
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
multi sub print-item-info (
  $a where * == GI_INFO_TYPE_OBJECT | GI_INFO_TYPE_INTERFACE
) {
  my $typename;
  ($typename, $*item) = do {
    when $a == GI_INFO_TYPE_OBJECT {
      ( 'Object', GIR::ObjectInfo.new($*item.GIBaseInfo) )
    }

    default {
      ( 'Interface', GIR::InterfaceInfo.new($*item.GIBaseInfo) )
    }
  }

  my $parent-name = $*item.parent ?? $*item.parent.name !! '';
  my $parent-prefix = $*repo.get-c-prefix($*item.parent.namespace);
  $parent-name //= 'None';
  $parent-name = $parent-prefix ~ $parent-name unless $parent-name eq 'None';

  say qq:to/OBJINFO/;

    { $typename } name: { $*item.type-name } --- Parent: { $parent-name }
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

sub list-item {
  once {
    say qq:to/INFO/;

    Prefix: { $*p }
    Number of Infos: { $*repo.get-n-infos($*namespace) }
    INFO
  }

  say "  { $*item.name.fmt("%-{ $*lin }s") } -- { $*item.infotype }"
}

sub MAIN (
  $typelib,            #= Typelib to load
  $pattern? is copy,   #= Object to introspect
  :$exclude = (),      #= Comma separated list of types to exclude (takes priority over items listed in --include)
  :$include = (),      #= Comma separated list of types to show
  :$list,              #= Print info list
  :$all,               #= List all information
  :$constants,         #= List constants
  :$fields,            #= List fields
  :$properties,        #= List properties
  :$interfaces,        #= List interfaces
  :$methods,           #= List methods
  :$signals,           #= List signals
  :$values,            #= List values
  :$vfuncs             #= List vfuncs
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
  my $*exclude    = $exclude.split(/',' \s+/).grep( *.so );
  my $*include    = $include.split(/',' \s+/).grep( *.so );

  unless $list || $pattern {
    say 'Must call program with --list or an object name pattern!';
    exit 1;
  }

  $pattern //= '';
  $pattern.substr-rw(0, $*p.chars) = '' if $pattern.substr-eq($*p | $*p.lc, 0);

  sub checkInclusiveType ($t) {
    unless $t eq GIInfoTypeEnum.enums.keys.any {
      say "Invalid type detected: { $t }!";
      exit 1;
    }
    GIInfoTypeEnum.enums{$t};
  }

  sub printItemInfo {
    die "Do not know how to handle '{ $*info.name }'. Type unknown!"
      if $*item.infotype == GI_INFO_TYPE_UNRESOLVED;

    $list ?? list-item()
          !! print-item-info($*item.infotype);
  }

  for $*include, $*exclude {
    $_ .= map({ checkInclusiveType($_) }) if .elems;
  }
  $*include.grep( *.Int != $*exclude.enums.values.any ) if $*exclude;

  my @items = do if $pattern.not {
    $*repo.get-infos($typelib);
  } elsif $pattern.contains('*') {
    $pattern = '. ' ~ $pattern if $pattern.starts-with('*');
    $*repo.get-infos($typelib).grep({
      use MONKEY-SEE-NO-EVAL;
      EVAL ".name ~~ / $pattern /"
    });
  } else {
    $*repo.find-by-name($typelib, $pattern);
  }

  my $*item;
  my $*lin = @items.map( *.name.chars ).max;
  for @items {
    if $*include {
      next unless .infotype == $*include.any;
    }
    $*item = $_;
    printItemInfo;
  }

}
