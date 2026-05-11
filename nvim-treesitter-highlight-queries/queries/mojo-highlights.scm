; Variables
(identifier) @variable

; Reset highlighting in f-string interpolations
(interpolation) @none @nospell

; Identifier naming conventions
((identifier) @type
  (#lua-match? @type "^_*[A-Z][A-Za-z0-9_]*$"))

((identifier) @constant
  (#lua-match? @constant "^_*[A-Z][A-Z0-9_]*$"))

((identifier) @constant.builtin
  (#lua-match? @constant.builtin "^__[a-zA-Z0-9_]*__$"))

((identifier) @constant.builtin
  (#any-of? @constant.builtin
    ; https://docs.python.org/3/library/constants.html
    "NotImplemented" "Ellipsis" "quit" "exit" "copyright" "credits" "license"))

"_" @character.special ; match wildcard

((assignment
  left: (identifier) @type.definition
  (type
    (identifier) @_annotation))
  (#eq? @_annotation "TypeAlias"))

((assignment
  left: (identifier) @type.definition
  right: (call
    function: (identifier) @_func))
  (#any-of? @_func "TypeVar" "NewType"))

; Function definitions
(function_definition
  name: (identifier) @function)

(type
  (identifier) @type)

(generic_type
  (identifier) @type)

(defaultable_type
  (identifier) @type)

; Conformance lists
; https://mojolang.org/nightly/docs/reference/struct-declarations/#conformance-lists
(conformance_list
  [
    (identifier) @type
    (subscript (identifier) @type)
  ]
  (#lua-match? @type "^_*[A-Z][A-Za-z0-9_]*$"))

((call
  function: (identifier) @_isinstance
  arguments: (argument_list
    (_)
    (identifier) @type))
  (#eq? @_isinstance "isinstance"))

((call
  function: (identifier) @_issubclass
  arguments: (argument_list
    (identifier) @type
    (identifier) @type))
  (#eq? @_issubclass "issubclass"))

; Literals
(none) @constant.builtin

[
  (true)
  (false)
] @boolean

(integer) @number

(float) @number.float

(comment) @comment @spell

((module
  .
  (comment) @keyword.directive @nospell)
  (#lua-match? @keyword.directive "^#!/"))

(string) @string

[
  (escape_sequence)
  (escape_interpolation)
] @string.escape

; Docstrings
(module
  .
  (comment)*
  .
  (string
    (string_content) @spell)+ @string.documentation)

([
  (assignment)
  (type_alias_statement)
]
  .
  (string
    (string_content) @spell)+ @string.documentation)

(function_definition
  body: (block
    .
    (string
      (string_content) @spell)+ @string.documentation))

(class_definition
  body: (block
    .
    (string
      (string_content) @spell)+ @string.documentation))

(trait_definition
  body: (block
    .
    (string
      (string_content) @spell)+ @string.documentation))

; Tokens
[
  "-"
  "-="
  ":="
  "!="
  "*"
  "**"
  "**="
  "*="
  "/"
  "//"
  "//="
  "/="
  "&"
  "&="
  "%"
  "%="
  "^"
  "^="
  "+"
  "+="
  "<"
  "<<"
  "<<="
  "<="
  "<>"
  "="
  "=="
  ">"
  ">="
  ">>"
  ">>="
  "@"
  "@="
  "|"
  "|="
  "~"
  "->"
] @operator

; Keywords
[
  "and"
  "in"
  "is"
  "not"
  "or"
  "is not"
  "not in"
  "del"
] @keyword.operator

[
  "def"
  "lambda"
] @keyword.function

[
  "assert"
  "exec"
  "global"
  "nonlocal"
  "pass"
  "print"
  "with"
  "as"
  ; Mojo specifics
  "comptime"
  "var"
  "where"
] @keyword

; Mojo specifics
[
  "deinit"
  "mut"
  "out"
  "read"
  "ref"
] @keyword.modifier

[
  "class"
  ; Mojo specifics
  "struct"
  "trait"
] @keyword.type

(type_alias_statement
  "type" @keyword.type)

[
  "async"
  "await"
] @keyword.coroutine

[
  "return"
  "yield"
] @keyword.return

(yield
  "from" @keyword.return)

(future_import_statement
  "from" @keyword.import
  "__future__" @module.builtin)

(import_from_statement
  "from" @keyword.import
  module_name:
    [
      (dotted_name
        (identifier) @module)
      (relative_import
        (dotted_name
          (identifier) @module))
    ])

"import" @keyword.import

(aliased_import
  "as" @keyword.import)

(wildcard_import
  "*" @character.special)

(import_statement
  name: 
    [
      (dotted_name
        (identifier) @module)
      (aliased_import
        name: (dotted_name
          (identifier) @module)
        comptime: (identifier) @module)
    ])

[
  "if"
  "elif"
  "else"
  "match"
  "case"
] @keyword.conditional

[
  "for"
  "while"
  "break"
  "continue"
] @keyword.repeat

[
  "try"
  "except"
  "raise"
  "finally"
  ; Mojo specifics
  "raises"
] @keyword.exception

(raise_statement
  "from" @keyword.exception)

(try_statement
  (else_clause
    "else" @keyword.exception))

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

(interpolation
  "{" @punctuation.special
  "}" @punctuation.special)

(format_expression
  "{" @punctuation.special
  "}" @punctuation.special)

; Mojo specifics
(mlir_type "!" @punctuation.special (#set! priority 110))
(mlir_type ">" @punctuation.special (#set! priority 110))
(mlir_type "<" @punctuation.special (#set! priority 110))
(mlir_type "->" @punctuation.special (#set! priority 110))
(mlir_type "(" @punctuation.special (#set! priority 110))
(mlir_type ")" @punctuation.special (#set! priority 110))
(mlir_type "." @punctuation.special (#set! priority 110))
(mlir_type ":" @punctuation.special (#set! priority 110))
(mlir_type "+" @punctuation.special (#set! priority 110))
(mlir_type "-" @punctuation.special (#set! priority 110))
(mlir_type "*" @punctuation.special (#set! priority 110))
(mlir_type "," @punctuation (#set! priority 110))

(line_continuation) @punctuation.special

(type_conversion) @function.macro

[
  ","
  "."
  ":"
  ";"
  (ellipsis)
] @punctuation.delimiter

; Mojo specifics
(mlir_type) @type.builtin

((identifier) @type.builtin
  (#any-of? @type.builtin
    ; https://docs.python.org/3/library/exceptions.html
    "BaseException" "Exception" "ArithmeticError" "BufferError" "LookupError" "AssertionError"
    "AttributeError" "EOFError" "FloatingPointError" "GeneratorExit" "ImportError"
    "ModuleNotFoundError" "IndexError" "KeyError" "KeyboardInterrupt" "MemoryError" "NameError"
    "NotImplementedError" "OSError" "OverflowError" "RecursionError" "ReferenceError" "RuntimeError"
    "StopIteration" "StopAsyncIteration" "SyntaxError" "IndentationError" "TabError" "SystemError"
    "SystemExit" "TypeError" "UnboundLocalError" "UnicodeError" "UnicodeEncodeError"
    "UnicodeDecodeError" "UnicodeTranslateError" "ValueError" "ZeroDivisionError" "EnvironmentError"
    "IOError" "WindowsError" "BlockingIOError" "ChildProcessError" "ConnectionError"
    "BrokenPipeError" "ConnectionAbortedError" "ConnectionRefusedError" "ConnectionResetError"
    "FileExistsError" "FileNotFoundError" "InterruptedError" "IsADirectoryError"
    "NotADirectoryError" "PermissionError" "ProcessLookupError" "TimeoutError" "Warning"
    "UserWarning" "DeprecationWarning" "PendingDeprecationWarning" "SyntaxWarning" "RuntimeWarning"
    "FutureWarning" "ImportWarning" "UnicodeWarning" "BytesWarning" "ResourceWarning"
    ; https://docs.python.org/3/library/stdtypes.html
    "bool" "int" "float" "complex" "list" "tuple" "range" "str" "bytes" "bytearray" "memoryview"
    "set" "frozenset" "dict" "type" "object"))

(parameters
  [
    ; Normal parameters
    (identifier) @variable.parameter
    ; Variadic parameters *args, **kwargs
    (list_splat_pattern ; *args
      (identifier) @variable.parameter)
    (dictionary_splat_pattern ; **kwargs
      (identifier) @variable.parameter)
    ; Typed variadic parameters
    (typed_parameter
      (list_splat_pattern ; *args: type
        (identifier) @variable.parameter))
    (typed_parameter
      (dictionary_splat_pattern ; *kwargs: type
        (identifier) @variable.parameter))
  ])

; Lambda parameters
(lambda_parameters
  [
    (identifier) @variable.parameter
    (tuple_pattern
      (identifier) @variable.parameter)
    (list_splat_pattern
      (identifier) @variable.parameter)
    (dictionary_splat_pattern
      (identifier) @variable.parameter)
  ])

; Default parameters
(keyword_argument
  name: (identifier) @variable.parameter)

; Naming parameters on call-site
(default_parameter
  name: (identifier) @variable.parameter)

(typed_parameter
  name: (identifier) @variable.parameter)

; Comptime and type parameters
(constrained_type
  .
  (type
    [
      (identifier) @variable.parameter
      (generic_type (identifier) @variable.parameter)
    ])
  (#match? @variable.parameter "^[a-z0-9_].*$"))

(type_alias_statement
  left: (defaultable_type 
    [
      (identifier) @variable.parameter
      (generic_type (identifier) @variable.parameter)
    ])
  (#lua-match? @variable.parameter "^[a-z0-9_].*$"))

; Self references
[
  (parameters
    (identifier) @variable.builtin)
  (attribute
    (identifier) @variable.builtin)
  (#any-of? @variable.builtin "self" "cls")
]

; After @type.builtin bacause builtins (such as `type`) are valid as attribute name
((attribute
  attribute: (identifier) @variable.member)
  (#lua-match? @variable.member "^[a-z0-9_].*$"))

; Class definitions
(class_definition
  name: (identifier) @type)

((class_definition
  body: (block
    (assignment
      left:
        [
          (identifier) @variable.member
          (_
            (identifier) @variable.member)
        ])))
  (#lua-match? @variable.member "^[a-z0-9_].*$"))

(class_definition
  body: (block
    [
      (function_definition
        name: (identifier) @function.method)
      (decorated_definition
        definition: (function_definition
          name: (identifier) @function.method))
    ]))

((class_definition
  body: (block
    [
      (function_definition
        name: (identifier) @constructor)
      (decorated_definition
        definition: (function_definition
          name: (identifier) @constructor))
    ]))
  (#any-of? @constructor "__new__" "__init__"))

; Function calls
(call
  [
    function: (identifier) @function.call
    function: (attribute
      attribute: (identifier) @function.method.call)
  ])

((call
  [
    function: (identifier) @constructor
    function: (attribute
      attribute: (identifier) @constructor)
  ])
  (#lua-match? @constructor "^_*[A-Z]"))

; Builtin functions
((call
  function: (identifier) @function.builtin)
  (#any-of? @function.builtin
    "abs" "all" "any" "ascii" "bin" "bool" "breakpoint" "bytearray" "bytes" "callable" "chr"
    "classmethod" "compile" "complex" "delattr" "dict" "dir" "divmod" "enumerate" "eval" "exec"
    "filter" "float" "format" "frozenset" "getattr" "globals" "hasattr" "hash" "help" "hex" "id"
    "input" "int" "isinstance" "issubclass" "iter" "len" "list" "locals" "map" "max" "memoryview"
    "min" "next" "object" "oct" "open" "ord" "pow" "print" "property" "range" "repr" "reversed"
    "round" "set" "setattr" "slice" "sorted" "staticmethod" "str" "sum" "super" "tuple" "type"
    "vars" "zip" "__import__"
    ; Mojo specifics
    "__mlir_attr" "__mlir_op" "__mlir_type"))

; Regex from the `re` module
(call
  function: (attribute
    object: (identifier) @_re)
  arguments: (argument_list
    [
      (string
        (string_content) @string.regexp)
      (concatenated_string
        (string
          (string_content) @string.regexp))
    ])
  (#eq? @_re "re"))

; Decorators
(decorator
  "@" @attribute
  (#set! priority 101)
  [
    (identifier) @attribute
    (attribute
      attribute: (identifier) @attribute)
    (call
      (identifier) @attribute)
    (call
      (attribute
        attribute: (identifier) @attribute))
  ]
)

((decorator
  (identifier) @attribute.builtin)
  (#any-of? @attribute.builtin
    "classmethod" "property" "staticmethod"
    ; Mojo specifics
    "always_inline"))

; Mojo specifics
((decorator
  (call
    (identifier) @attribute.builtin))
  (#eq? @attribute.builtin "always_inline"))
