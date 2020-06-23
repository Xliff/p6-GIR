use v6.c;

use GLib::Raw::Definitions;

unit package GIR::Raw::Enums;

constant GIArrayType is export := guint32;
our enum GIArrayTypeEnum is export <
  GI_ARRAY_TYPE_C
  GI_ARRAY_TYPE_ARRAY
  GI_ARRAY_TYPE_PTR_ARRAY
  GI_ARRAY_TYPE_BYTE_ARRAY
>;

constant GIDirection is export := guint32;
our enum GIDirectionEnum is export <
  GI_DIRECTION_IN
  GI_DIRECTION_OUT
  GI_DIRECTION_INOUT
>;

constant GIFieldInfoFlags is export := guint32;
our enum GIFieldInfoFlagsEnum is export (
  GI_FIELD_IS_READABLE => 1 +< 0,
  GI_FIELD_IS_WRITABLE => 1 +< 1,
);

constant GIFunctionInfoFlags is export := guint32;
our enum GIFunctionInfoFlagsEnum is export (
  GI_FUNCTION_IS_METHOD      => 1 +< 0,
  GI_FUNCTION_IS_CONSTRUCTOR => 1 +< 1,
  GI_FUNCTION_IS_GETTER      => 1 +< 2,
  GI_FUNCTION_IS_SETTER      => 1 +< 3,
  GI_FUNCTION_WRAPS_VFUNC    => 1 +< 4,
  GI_FUNCTION_THROWS         => 1 +< 5,
);

constant GIInfoType is export := guint32;
our enum GIInfoTypeEnum is export <
  GI_INFO_TYPE_INVALID
  GI_INFO_TYPE_FUNCTION
  GI_INFO_TYPE_CALLBACK
  GI_INFO_TYPE_STRUCT
  GI_INFO_TYPE_BOXED
  GI_INFO_TYPE_ENUM
  GI_INFO_TYPE_FLAGS
  GI_INFO_TYPE_OBJECT
  GI_INFO_TYPE_INTERFACE
  GI_INFO_TYPE_CONSTANT
  GI_INFO_TYPE_INVALID_0
  GI_INFO_TYPE_UNION
  GI_INFO_TYPE_VALUE
  GI_INFO_TYPE_SIGNAL
  GI_INFO_TYPE_VFUNC
  GI_INFO_TYPE_PROPERTY
  GI_INFO_TYPE_FIELD
  GI_INFO_TYPE_ARG
  GI_INFO_TYPE_TYPE
  GI_INFO_TYPE_UNRESOLVED
>;

constant GIRepositoryError is export := guint32;
our enum GIRepositoryErrorEnum is export <
  G_IREPOSITORY_ERROR_TYPELIB_NOT_FOUND
  G_IREPOSITORY_ERROR_NAMESPACE_MISMATCH
  G_IREPOSITORY_ERROR_NAMESPACE_VERSION_CONFLICT
  G_IREPOSITORY_ERROR_LIBRARY_NOT_FOUND
>;

constant GIRepositoryLoadFlags is export := guint32;
our enum GIRepositoryLoadFlagsEnum is export (
  G_IREPOSITORY_LOAD_FLAG_LAZY => 1 +< 0,
);

constant GIScopeType is export := guint32;
our enum GIScopeTypeEnum is export <
  GI_SCOPE_TYPE_INVALID
  GI_SCOPE_TYPE_CALL
  GI_SCOPE_TYPE_ASYNC
  GI_SCOPE_TYPE_NOTIFIED
>;

constant GITransfer is export := guint32;
our enum GITransferEnum is export <
  GI_TRANSFER_NOTHING
  GI_TRANSFER_CONTAINER
  GI_TRANSFER_EVERYTHING
>;

constant GITypeTag is export := guint32;
our enum GITypeTagEnum is export (
  GI_TYPE_TAG_VOID      =>  0,
  GI_TYPE_TAG_BOOLEAN   =>  1,
  GI_TYPE_TAG_INT8      =>  2,
  GI_TYPE_TAG_UINT8     =>  3,
  GI_TYPE_TAG_INT16     =>  4,
  GI_TYPE_TAG_UINT16    =>  5,
  GI_TYPE_TAG_INT32     =>  6,
  GI_TYPE_TAG_UINT32    =>  7,
  GI_TYPE_TAG_INT64     =>  8,
  GI_TYPE_TAG_UINT64    =>  9,
  GI_TYPE_TAG_FLOAT     => 10,
  GI_TYPE_TAG_DOUBLE    => 11,
  GI_TYPE_TAG_GTYPE     => 12,
  GI_TYPE_TAG_UTF8      => 13,
  GI_TYPE_TAG_FILENAME  => 14,
  GI_TYPE_TAG_ARRAY     => 15,
  GI_TYPE_TAG_INTERFACE => 16,
  GI_TYPE_TAG_GLIST     => 17,
  GI_TYPE_TAG_GSLIST    => 18,
  GI_TYPE_TAG_GHASH     => 19,
  GI_TYPE_TAG_ERROR     => 20,
  GI_TYPE_TAG_UNICHAR   => 21,
);

constant GIVFuncInfoFlags is export := guint32;
our enum GIVFuncInfoFlagsEnum is export (
  GI_VFUNC_MUST_CHAIN_UP     => 1 +< 0,
  GI_VFUNC_MUST_OVERRIDE     => 1 +< 1,
  GI_VFUNC_MUST_NOT_OVERRIDE => 1 +< 2,
  GI_VFUNC_THROWS            => 1 +< 3,
);

constant GInvokeError is export := guint32;
our enum GInvokeErrorEnum is export <
  G_INVOKE_ERROR_FAILED
  G_INVOKE_ERROR_SYMBOL_NOT_FOUND
  G_INVOKE_ERROR_ARGUMENT_MISMATCH
>;
