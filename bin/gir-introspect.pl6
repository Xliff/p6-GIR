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

sub get-param-list ($mi) {
  return '' unless $mi.n-args;

  sub arg-str ($a) {
    #"{ $a.type.type-tag }{ $a.type.is-pointer ?? '*' !! '' }\t{ $a.name }";
    "{ $a.type.tag }{ False ?? '*' !! '' }\t{ $a.name }";
  }

  return arg-str( $mi.get-arg(0) ) if $mi.n-args == 1;

  "\t\t" ~ (
    gather for $mi.get-args[] {
      take arg-str($_)
    }
  ).join(",\n\t\t")
}

sub ptr-mark ($rt) {
  $rt.is-pointer ?? '*' !! ''
}

sub list-methods {
  my $ret = '';

  class NoReturn {
    has $.name       = '';
    has $.is-pointer = False;
  }

  if $*o.m-elems -> $nm {
    for ^$nm {
      my $mi = $*o.get-method($_);
      my $rt = $mi.return-type // NoReturn.new;

      if $mi.n-args == 1 {
        $ret ~= "{ $rt.name }{ ptr-mark($rt) } { $mi.name } ({
                   get-param-list($mi) })\n";
        # $ret ~= "{ $rt.name }{ ptr-mark($rt) } {
        #       $mi.name } (\n{ '' })\n\n";=
      } elsif $mi.n-args {
        $ret ~= "{ $rt.name }{ ptr-mark($rt) } { $mi.name } (\n{
                   get-param-list($mi) }\n )\n";
      } else {
        $ret ~= "{ $rt.name }{ ptr-mark($rt) } { $mi.name } ()\n";
      }
    }
  }
  $ret;
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

  say qq:to/OBJINFO/;
    Prefix: { $repo.get-c-prefix($typelib) }

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
                 V-Funcs: { $*o.v-elems }
    OBJINFO

}
