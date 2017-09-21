import Test.Cabal.Prelude
import Data.Foldable
main :: IO ()
main = setupTest $ do
  workdir <- fmap testWorkDir getTestEnv
  setup "configure" [ "--enable-tests", "--enable-benchmarks"]
  let libBuildDir = workdir </> "work" </> "dist" </> "build"
      exeBuildDir = workdir </> "work" </> "dist" </> "build" </> "exe"
      testBuildDir = workdir </> "work" </> "dist" </> "build" </> "test" </> "test-tmp"
      benchBuildDir = workdir </> "work" </> "dist" </> "build" </> "bench" </> "bench-tmp"
      libHi = libBuildDir </> "Lib.hi"
      exeHi = exeBuildDir </> "Main.hi"
      testHi = testBuildDir </> "Main.hi"
      benchHi = benchBuildDir </> "Main.hi"
      libO = libBuildDir </> "Lib.o"
      exeO = exeBuildDir </> "Main.o"
      testO = testBuildDir </> "Main.o"
      benchO = benchBuildDir </> "Main.o"
  setup "build" ["typecheck-only", "--typecheck"]
  shouldExist libHi
  shouldNotExist libO

  setup "build" ["test", "--typecheck"]
  shouldExist testHi
  shouldNotExist testO

  setup "build" ["bench", "--typecheck"]
  shouldExist benchHi
  shouldNotExist benchO

  fails $ setup "build" ["exe", "--typecheck"]
  shouldNotExist exeHi
  shouldNotExist exeO
