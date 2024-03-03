use v6;

use GLib::Raw::Exports;
use GIR::Raw::Exports;

unit package GIR::Raw::Types;

need GLib::Raw::Debug;
need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Exceptions;
need GLib::Raw::Object;
need GLib::Raw::Structs;
need GLib::Raw::Subs;
need GLib::Raw::Struct_Subs;
need GLib::Roles::Pointers;
need GLib::Roles::Implementor;
need GIR::Raw::Enums;
need GIR::Raw::Structs;

BEGIN {
  glib-re-export($_) for |@glib-exports,
                         |@gir-exports;
}
