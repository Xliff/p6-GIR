use v6.c;

unit package GIR::Raw::Exports;

our @gir-exports is export;

BEGIN {
  @gir-exports = <
    GIR::Raw::Structs
    GIR::Raw::Enums
  >;
}
