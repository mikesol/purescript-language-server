{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "purescript-language-server"
, dependencies =
  [ "aff"
  , "aff-promise"
  , "argonaut"
  , "argonaut-codecs"
  , "argonaut-core"
  , "arrays"
  , "avar"
  , "bifunctors"
  , "console"
  , "contravariant"
  , "control"
  , "datetime"
  , "effect"
  , "either"
  , "enums"
  , "errors"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "foreign-generic"
  , "foreign-object"
  , "integers"
  , "lists"
  , "maybe"
  , "newtype"
  , "node-buffer"
  , "node-child-process"
  , "node-fs"
  , "node-fs-aff"
  , "node-path"
  , "node-process"
  , "node-streams"
  , "nonempty"
  , "nullable"
  , "prelude"
  , "profunctor"
  , "psc-ide"
  , "psci-support"
  , "random"
  , "refs"
  , "strings"
  , "stringutils"
  , "test-unit"
  , "transformers"
  , "tuples"
  , "unsafe-coerce"
  , "uuid"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
