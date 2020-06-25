use v6.c;

use GIR::Raw::Types;

use GLib::Object::Type;
use GIR::Repository;
use GIR::ObjectInfo;

sub MAIN (
  $typelib,     #= Typelib to load
  $object       #= Object found within <typelib>
) {
  # Exit upon ANY error.
  $ERROR-IS-FATAL = True;

  my $repo = GIR::Repository.get-default;
  my $t    = $repo.require($typelib);
  my $bi   = $repo.find-by-name($typelib, $object);

  my $gt = GLib::Object::Type.from_name($object);

  $gt.say;

  $bi = $repo.find-by-gtype($gt)
    unless $bi;

  die "Could not find an object named '{ $object }'!" unless $bi;

  die "'$object' is not a GObject!"
    unless $bi.infotype == GI_INFO_TYPE_OBJECT;

  my $o = GIR::ObjectInfo.new($bi.GIBaseInfo);

  my $parent-name = $o.parent ?? $o.parent.name !! '';
  $parent-name //= 'None';

  say qq:to/OBJINFO/;
    Object name: { $o.type-name } --- Parent: { $parent-name }

               Constants: { $o.c-elems }
                  Fields: { $o.f-elems }
              Properties: { $o.p-elems }
      Requred interfaces: { $o.i-elems }
                 Methods: { $o.m-elems }
                 Signals: { $o.s-elems }
                 V-Funcs: { $o.v-elems }
   OBJINFO

}
