from os.path import join, isfile
from os import remove
import shutil

Import("env")

env.Replace(PROGNAME="%s" % env.GetProjectOption("name"))

FRAMEWORK_DIR = env.PioPlatform().get_package_dir("framework-arduinopico")
patchflag_path = join(FRAMEWORK_DIR, ".patching-done")

# patch file only if we didn't do it before
original_file = join(FRAMEWORK_DIR, "lib", "memmap_default.ld")
patched_file = join("patches", "memmap_default_original.ld")
assert isfile(patched_file)
shutil.copy2(patched_file, original_file)

# patch file only if we didn't do it before
original_file = join(FRAMEWORK_DIR, "lib", "libpico.a")
patched_file = join("patches", "libpico_original.a")
assert isfile(patched_file)
shutil.copy2(patched_file, original_file)

if isfile(patchflag_path):
    remove(patchflag_path)
