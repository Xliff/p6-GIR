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

    token YesNo { 'Yes' | 'No'         }
    token flags { [ 'R' | 'W' | 'V' ]+ }
    token value { <-[\s,()\[\]]>+      }

    token type  {
        \w+
        [
          '['
            <type=value>
            [ \s $<ptr>=('*') ]?
            [ ',size = ' $<len>=(\d+) ]?
          ']'
        ]?
        [ \s '*' ]?
    }

    rule Property {
        <type> <value> '(' <flags> ')'
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
        [ <Property>+ ]?
    }

    rule Methods {
        'Methods:' (\d+)
        [ <FunctionCallback>+ ]?
    }

    rule EnumFlags {
        [ 'Flags' | 'Enum' ] 'name:' <name=value>
        'Values:' (\d+)
        [ <key=value> '=' <value> '\''$<nick>=(\w+)'\'' ]+
        <Methods>
    }

    rule StructUnions {
        [ 'Struct' | 'Union' ] 'name:' <name=value>
        '-- Size:' $<size>=(\d+) 'bytes'
        'Registered:' <YesNo>

        <Fields>
        <Methods>
     }

    rule Constant {
        'Constant:' <name=value> '=' <value> '(' <type> ')'
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
        [ 'Object' | 'Interface' ] 'name:' <name=value>
        [ '--- Parent: ' <parent=value> ]?
        <Constants>
        <Fields>
        <Properties>
        <Interfaces>?
        <Methods>
        <Signals>
        <VFuncs>
    }

}
