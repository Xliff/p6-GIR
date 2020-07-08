use v6.c;

use GIR::Raw::Types;

use GLib::Object::Type;
use GIR::Repository;
use GIR::ObjectInfo;

sub list-constant ($ci) {
  my $val = $ci.value;
  my $tn = $ci.type.tag-name;

  $val = "'{ $val }'" if $tn = 'char';
  "Constant:  { $ci.name } = { $val } ({ $*p.lc ~ $tn })\n";
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

sub fix-tag-name($ti) {
  my $tag-name = $ti.tag-name( prefix => $*p );

  if $ti.tag == GI_TYPE_TAG_ARRAY {
    my $param = $ti.get-param-type(0);
    my $prefix = $*repo.get-c-prefix($param.namespace);

    my @additions;
    @additions.push: $param.tag-name( :$prefix ) ~ ptr-mark($ti);
    if (my $s = $ti.array-fixed-size) > 0 {
      @additions.push: "size = $s";
    }
    $tag-name ~= "[{ @additions.join(',') }]";
  }
  $tag-name;
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

sub list-propfields ($nf, $method) {
  my $ret = '';
  if $nf {
    my ($tmax, $fmax) = 0 xx 2;
    my @f = do gather for ^$nf {
      my $f  = $*item."$method"($_);
      my $tn = fix-tag-name($f.type) // '';
      my $v  = {
        flags      => $f.flags,
        field-name => $f.name,
        type-name  => $tn,
        pointer    => ptr-mark($f.type),
        # Check for a vfunc by testing if <field name> eq <type name>
        virtual    => $f.name eq $tn.substr($*p.chars)
      };
      # If a vfunc, then special case the name to 'void'
      $v<type-name>  = 'void'         if $v<virtual>;
      # Append a pointer mark if a pointer was detected.
      $v<type-name> ~= $v<pointer>    if $v<pointer>;
      # Add the pointer mark if the field is a vfunc. These usually will
      # NOT be detected as pointers. However, just in case... we CYA.
      $v<type-name> ~= ptr-mark(True) if $v<virtual> && $v<pointer>.so.not;

      $fmax = ($fmax, $v<field-name>.chars).max;
      $tmax = ($tmax, $v<type-name>.chars).max;
      take $v;
    }

    for @f {
      my $rw = '';

      $rw ~= 'R' if .<flags> +& GI_FIELD_IS_READABLE;
      $rw ~= 'W' if .<flags> +& GI_FIELD_IS_WRITABLE;
      $rw ~= 'V' if .<virtual>;
      $ret ~= "  {  .<type-name>.fmt("%-{ $tmax }s") } {
                   .<field-name>.fmt("%-{ $fmax }s") } ({ $rw })\n";
    }
  }
  $ret;
}

sub list-fields {
  if $*item.f-elems -> $nf {
    list-propfields($nf, 'get-field');
  }
}

sub list-properties {
  if $*item.p-elems -> $nf {
    list-propfields($nf, 'get-property');
  }
}

sub get-param-list ($mi) {
  return '' unless $mi.n-args;

  sub arg-str ($a) {
    "{ fix-tag-name($a.type) }{ ptr-mark($a) } { $a.name }";
  }

  return arg-str( $mi.get-arg(0) ) if $mi.n-args == 1;

  my $indent = $*lin + 7;
  (' ' x $indent ) ~ (
    gather for $mi.get-args[] {
      take arg-str($_)
    }
  ).join(",\n" ~ " " x $indent)
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

  my ($rt, $ret, $name) = ($mi.return-type // NoReturn.new, '  ', $mi.name);
  my $return-type = fix-tag-name($rt) ~ ptr-mark($rt);
  $return-type .= fmt("%-{ $*lin }s");
  $name = "{ $prefix }_{ $name }" if $prefix;

  if $mi.n-args == 1 {
    $ret ~= "{ $return-type } { $name } ({
               get-param-list($mi) })\n\n";
  } elsif $mi.n-args {
    $ret ~= "{ $return-type } { $name } (\n{
               get-param-list($mi) }\n{ ' ' x ($*lin + 5) })\n\n";
  } else {
    $ret ~= "{ $return-type } { $name } ()\n\n";
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

  ($*p ~ $*item.name) ~~ m:g/<[A..Z]><[a..z]>+/;
  my $enum-prefix = $/.map( *.Str.uc ).join('_');

  if $*item.v-elems -> $nv {
    my @values = gather for ^$nv {
      take $*item.get-value($_);
    }
    my $mnl = @values.map( *.name.chars ).max + $enum-prefix.chars + 1;
    my $mvl = @values.map( *.value.chars ).max;

    for @values {
      my $ein = $enum-prefix ~ '_' ~ .name.uc.subst('-', '_');

      $ret ~= "  { $ein.fmt("%-{ $mnl }s") } = {
                 .value.fmt("%-{ $mvl }s") } '{ .name }'\n";
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
  my $item-type = $a == GI_INFO_TYPE_FUNCTION ?? 'Function' !! 'Callback';

  say qq:to/FUNCINFO/;
  { $item-type }:
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

    { $typename } name: { $*p ~ $*item.name }
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

  my ($parent-name, $parent-prefix) = do if $a == GI_INFO_TYPE_OBJECT {
    (
      $*item.parent ?? $*item.parent.name !! '' // 'None',
      $*repo.get-c-prefix($*item.parent.namespace) // ''
    );
  }
  $parent-name //= 'None';
  $parent-name = $parent-prefix ~ $parent-name unless $parent-name eq 'None';

  say qq:to/OBJINFO/;

    { $typename } name: { $*item.type-name } --- Parent: { $parent-name }
    OBJINFO

  say qq:to/CONSTANTINFO/  if $*all || $*constants;
    Constants: { $*item.c-elems }
    { list-constants }
    CONSTANTINFO

  if $a == GI_INFO_TYPE_OBJECT {
    say qq:to/FIELDINFO/     if $*all || $*fields;
      Fields: { $*item.f-elems }
      { list-fields }
      FIELDINFO
  }

  say qq:to/PROPINFO/      if $*all || $*properties;
    Properties: { $*item.p-elems }
    { list-properties }
    PROPINFO

  if $a == GI_INFO_TYPE_OBJECT {
    say qq:to/IFACEINFO/     if $*all || $*interfaces;
      Required interfaces: { $*item.i-elems }
      { list-interfaces }
      IFACEINFO
  }

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
    unless $t == GIInfoTypeEnum.enums.any {
      say "Invalid type detected: { $t }!";
      exit 1;
    }
    $t ~~ Int ?? GIInfoTypeEnum.enums{$t} !! GIInfoTypeEnum($t);
  }

  sub printItemInfo {
    die "Do not know how to handle '{ $*info.name }'. Type unknown!"
      if $*item.infotype == GI_INFO_TYPE_UNRESOLVED;

    $list ?? list-item()
          !! print-item-info($*item.infotype);
  }

  #$*include = GIInfoTypeEnum.enums.values unless $*include;
  for $*include, $*exclude {
    $_ = .map({ checkInclusiveType($_) }).eager if .elems;
  }
  $*include.grep( *.Int != $*exclude.enums.values.any ) if $*exclude;

  # cw: XXX - This block may need to be rewritten for speed. There are too
  #           many loops through the repo infos.
  my @items = do if $pattern.not {
    $*repo.get-infos($typelib);
  } elsif $pattern.contains('*') {
    $pattern = '. ' ~ $pattern if $pattern.starts-with('*');
    $*repo.get-infos($typelib).grep({
      use MONKEY-SEE-NO-EVAL;

      # cw: This is the slowdown!
      EVAL ".name ~~ / $pattern /";
    });
  } else {
    $*repo.find-by-name($typelib, $pattern);
  }

  my $*item;
  # cw: $*lin is incorrect, here. This is the WHOLE list, not the filtered
  #     one, so $*lin takes the max of items that are sight-unseen.
  my $*lin = @items.map( *.name.chars ).max;

  for @items {
    if $*include {
      next unless .infotype == $*include.any;
    }
    $*item = $_;

    printItemInfo;
  }

}
