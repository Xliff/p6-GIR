use v6.c;

use GIR::Raw::Types;

use GLib::Object::Type;
use GIR::Repository;
use GIR::ObjectInfo;

sub list-constants {
  my $ret = '';
  if $*o.c-elems -> $nc {
    for ^$nc {
      my $ci = $*o.get-constant($_);
      next unless $ci.name;

      # cw: Eventually shall add the value!
      $ret ~= "  { $ci.type.name } { $ci.name }\n"
    }
  }
  $ret;
}

sub list-fields {
  my $ret = '';
  if $*o.f-elems -> $nf {
    for ^$nf {
      my $fi = $*o.get-field($_);
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
  if $*o.p-elems -> $nf {
    for ^$nf {
      my $fi = $*o.get-property($_);
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

sub list-callables ($retrieve, $num) {
  my $ret = '';

  class NoReturn {
    has $.name       = '';
    has $.is-pointer = False;
    has $.tag        = GI_TYPE_TAG_VOID;
  }

  if $num -> $nm {
    for ^$nm {
      my $mi = $*o."$retrieve"($_);
      my $rt = $mi.return-type // NoReturn.new;

      $ret ~= '  ';
      if $mi.n-args == 1 {
        $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                     ptr-mark($rt) ).fmt('%-20s') } { $mi.name } ({
                   get-param-list($mi) })\n\n";
        # $ret ~= "{ $rt.name }{ ptr-mark($rt) } {
        #       $mi.name } (\n{ '' })\n\n";=
      } elsif $mi.n-args {
        $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                     ptr-mark($rt) ).fmt('%-20s') } { $mi.name } (\n{
                   get-param-list($mi) }\n{ ' ' x 23 })\n\n";
      } else {
        $ret ~= "{ ( $rt.tag-name( :prefix($*p) ) ~ ' ' ~
                     ptr-mark($rt) ).fmt('%-20s') } { $mi.name } ()\n\n";
      }
    }
  }
  $ret;
}

sub list-methods {
  list-callables('get-method', $*o.m-elems);
}

sub list-signals {
  list-callables('get-signal', $*o.s-elems);
}

sub list-vfuncs {
  list-callables('get-vfunc', $*o.v-elems);
}

sub MAIN (
  $typelib,     #= Typelib to load
  $object       #= Object found within <typelib>
) {
  # Exit upon ANY error.
  $ERROR-IS-FATAL = True;

  my $repo = GIR::Repository.get-default;
  my $t    = $repo.require($typelib);
  my $bi   = $repo.find-by-name($typelib, $object);
  my $gt   = GLib::Object::Type.from_name($object);

  $bi = $repo.find-by-gtype($gt) unless $bi || $gt.not;

  die "Could not find an object named '{ $object }'!" unless $bi;

  die "'$object' is not a GObject!"
    unless $bi.infotype == GI_INFO_TYPE_OBJECT;

  my $*o = GIR::ObjectInfo.new($bi.GIBaseInfo);

  my $parent-name = $*o.parent ?? $*o.parent.name !! '';
  $parent-name //= 'None';

  my $*p = $repo.get-c-prefix($typelib);
  say qq:to/OBJINFO/;
    Prefix: { $*p }

    Object name: { $*o.type-name } --- Parent: { $parent-name }

    Constants: { $*o.c-elems }
    { list-constants.chomp }

    Fields: { $*o.f-elems }
    { list-fields.chomp }

    Properties: { $*o.p-elems }
    { list-properties.chomp }

    Requred interfaces: { $*o.i-elems }

    Methods: { $*o.m-elems }
    { list-methods.chomp }

    Signals: { $*o.s-elems }
    { list-signals.chomp }

    V-Funcs: { $*o.v-elems }
    { list-vfuncs.chomp }
    OBJINFO

}
