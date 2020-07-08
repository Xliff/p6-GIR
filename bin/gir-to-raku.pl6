grammar GirIntrospectGrammar {
    regex TOP {
        \s+
        [
        <EnumFlags>         |
        <ObjectInterfaces>  |
        <StructUnions>      |
        <FunctionCallbacks> |
        <Fields>            |
        <Constant>
        ]+
    }

    token YesNo { 'Yes' | 'No'   }
    token RW    { [ 'R' | 'W' ]+ }
    token value { <-[\s,()\[\]]>+  }
    token type  { \w+[ '[' <value> ']' ]? [ \s '*' ]? }

    rule Property {
        <value> '(' <RW> ')'
    }

    rule FunctionCallback {
        <type> <function_name=value> [
            '('
                [ <type> <param_name=value> ]+ %% ','
            ')'
            |
            '()'
        ]
     }

    rule Properties {
        'Properties:' (\d+)
        [ <Property>+ ]?
    }

    rule Fields {
        'Fields:' (\d+)
        [ [ <type> <Property> ]+ ]?
    }

    rule Methods {
        'Methods:' (\d+)
        [ <FunctionCallback>+ ]?
    }

    rule EnumFlags {
        [ 'Flags' | 'Enum' ] 'name:' <value>
        'Values:' (\d+)
        [ <value> '=' <value> ]+
        <Methods>
    }

    rule StructUnions {
        [ 'Struct' | 'Union' ] 'name:' <value> '-- Size:' (\d+) 'bytes'
        'Registered:' <YesNo>

        <Fields>
        <Methods>
     }

    rule Constant {
        'Constant:' <value> '=' <value> '(' <type> ')'
    }

    rule Constants {
        'Constants:' (\d+)
        [ <Constant>+ ]?
    }

    # Too permissive. Regex?
    token Interfaces {
        'Required interfaces:' \s (\d+) \s+
        [ [ <value> $$ \s+ ]+ ] ?
    }

    rule FunctionCallbacks {
        [ 'Function' | 'Callback' ]':'
        <FunctionCallback>
    }

    rule Signals {
        'Signals:' (\d+)
        [ <FunctionCallback>+ ]?
    }

    rule VFuncs {
        'V-Funcs:' (\d+)
        [ <FunctionCallback>+ ]?
    }

    rule ObjectInterfaces {
        [ 'Object' | 'Interface' ] 'name:' <value> [ '--- Parent: ' <value> ]?
        <Constants>
        <Fields>
        <Properties>
        <Interfaces>?
        <Methods>
        <Signals>
        <VFuncs>
    }

}
