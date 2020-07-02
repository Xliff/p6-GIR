# p6-GIR

## Installation

Make a directory to contain the p6-GLib-based projects. Once made, then set the P6_GTK_HOME environment variable to that directory:

```
$ export P6_GTK_HOME=/path/to/projects
```

Switch to that directory and clone both p6-GLib and p6-GIR

```
$ git clone https://github.com/Xliff/p6-GLib.git
$ git clone https://github.com/Xliff/p6-GIR.git
$ cd p6-GLib
$ zef install --deps-only .
```

[Optional] To build all of GIR and the required GLib modules, you can change to the p6-GIR directory and do:

```
./build.sh
```

If you just want to run `gir-introspect`, you can do:

```
./p6gtkexec bin/gir-introspect
```

Unfortunately, compile times are very long for this project, but I hope you find it interesting!

Some nifty examples that can be done using GIR:

List all objects in a typelib `(this example uses GIO)`:
```
use GIR::Raw::Types;
use GIR::Repository;

my $repo = GIR::Repository.get-default;
my $t = $repo.require("Gio");

$repo.get-n-infos("Gio").say;
for ^$repo.get-n-infos("Gio") {
  my $bi = $repo.get-info("Gio", $_);
  next unless $bi.infotype == GI_INFO_TYPE_OBJECT;
  say "{ $bi.name } - { $bi.infotype }"
}
```

List all signals provided by a GObject:
```
use GIR::Raw::Types;
use GIR::ObjectInfo;
use GIR::Repository;

my $repo = GIR::Repository.get-default;
my $t = $repo.require("Gio");
my $fmi = GIR::ObjectInfo.new(
  $repo.find-by-name("Gio", "MountOperation", :raw)
);

say $fmi.get-signal($_).name for ^$fmi.s-elems;
```

List all properties provided by a GObject:
```
use GIR::Raw::Types;
use GIR::ObjectInfo;
use GIR::Repository;

my $repo = GIR::Repository.get-default;
my $t = $repo.require("Gio");
my $fmi = GIR::ObjectInfo.new(
  $repo.find-by-name("Gio", "MountOperation", :raw)
);

say $fmi.get-property($_).name for ^$fmi.p-elems;
```
