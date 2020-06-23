use v6;

use CompUnit::Util :re-export;

use GLib::Raw::Exports;
use GIR::Raw::Exports;

unit package GIR::Raw::Types;

need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Object;
need GLib::Raw::Structs;
need GLib::Raw::Subs;
need GLib::Raw::Struct_Subs;
need GIR::Raw::Enums;
need GIR::Raw::Structs;

BEGIN {
  re-export($_) for |@glib-exports,
                    |@gir-exports;
}
