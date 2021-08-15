module LanguageServer.IdePurescript.Config where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (either)
import Foreign (F, Foreign, readArray, readBoolean, readInt, readString)
import Foreign.Index ((!))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Traversable (traverse)
import PscIde.Server (LogLevel(..))
import PscIde.Command (CodegenTarget(..))

getConfigMaybe :: forall a. (Foreign -> F a) -> String -> Foreign -> Maybe a
getConfigMaybe readValue key settings = do
    either (const Nothing) Just $ runExcept val
    where
        val = do
            ps <- settings ! "purescript"
            res <- ps ! key
            readValue res

getConfig :: forall a. (Foreign -> F a) -> String -> a -> Foreign -> a
getConfig readValue key default settings =
    fromMaybe default $ getConfigMaybe readValue key settings

getBoolean :: String -> Boolean -> Foreign -> Boolean
getBoolean = getConfig readBoolean

getString :: String -> String -> Foreign -> String
getString = getConfig readString

getInt :: String -> Int -> Foreign -> Int
getInt = getConfig readInt

type ConfigFn a = Foreign -> a

pursExe :: ConfigFn String
pursExe = getString "pursExe" "purs"

pscIdePort :: ConfigFn (Maybe Int)
pscIdePort = getConfigMaybe readInt "pscIdePort"

autoCompleteAllModules :: ConfigFn Boolean
autoCompleteAllModules = getBoolean "autocompleteAllModules" true

buildCommand :: ConfigFn String
buildCommand = getString "buildCommand" "spago build --purs-args --json-errors"

addNpmPath :: ConfigFn Boolean
addNpmPath = getBoolean "addNpmPath" false

packagePath :: ConfigFn String
packagePath = getString "packagePath" ""

srcPath :: ConfigFn String
srcPath = getString "sourcePath" "src"

sourceGlobs :: ConfigFn (Array String)
sourceGlobs = getConfig (readArray >=> traverse readString) "sourceGlobs" []

censorCodes :: ConfigFn (Array String)
censorCodes = getConfig (readArray >=> traverse readString) "censorWarnings" []

autoStartPscIde :: ConfigFn Boolean
autoStartPscIde = getBoolean "autoStartPscIde" true

autocompleteAddImport :: ConfigFn Boolean
autocompleteAddImport = getBoolean "autocompleteAddImport" true

autocompleteGrouped :: ConfigFn Boolean
autocompleteGrouped = getBoolean "autocompleteGrouped" false

autocompleteLimit :: ConfigFn (Maybe Int)
autocompleteLimit = getConfigMaybe readInt "autocompleteLimit"

importsPreferredModules :: ConfigFn (Array String)
importsPreferredModules = getConfig (readArray >=> traverse readString) "importsPreferredModules" []

preludeModule :: ConfigFn String
preludeModule = getString "preludeModule" "Prelude"

fastRebuild :: ConfigFn Boolean
fastRebuild = getBoolean "fastRebuild" true

buildOpenedFiles :: ConfigFn Boolean
buildOpenedFiles = getBoolean "buildOpenedFiles" false

-- | Output directory - if specified, passed to purs, otherwise no argument is passed (purs default to 'output')
outputDirectory :: ConfigFn (Maybe String)
outputDirectory = getConfigMaybe readString "outputDirectory"

-- | Effective output directory (taking account of purs default)
effectiveOutputDirectory :: ConfigFn String
effectiveOutputDirectory = fromMaybe "output" <<< ignoreEmpty <<< outputDirectory

addPscPackageSources :: ConfigFn Boolean
addPscPackageSources = getBoolean "addPscPackageSources" false

addSpagoSources :: ConfigFn Boolean
addSpagoSources = getBoolean "addSpagoSources" false

logLevel :: ConfigFn (Maybe LogLevel)
logLevel = getString "pscIdelogLevel" "" >>> case _ of
    "all" -> Just All
    "none" -> Just None
    "debug" -> Just Debug
    "perf" -> Just Perf
    _ -> Nothing

data Formatter
    = NoFormatter
    | Purty
    | PursTidy
    | Pose

formatter :: ConfigFn Formatter
formatter = getString "formatter" "" >>> case _ of
    "none" -> NoFormatter
    "purty" -> Purty
    "purs-tidy" -> PursTidy
    "pose" -> Pose
    _ -> Purty

codegenTargets :: ConfigFn (Maybe (Array CodegenTarget))
codegenTargets =  getConfigMaybe (readArray >=> traverse readString) "codegenTargets" >>>
    map (map Other)

ignoreEmpty :: Maybe String -> Maybe String
ignoreEmpty (Just "") = Nothing
ignoreEmpty x = x