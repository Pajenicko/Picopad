from os.path import join, isfile
import shutil

Import("env")

env.Replace(PROGNAME="%s" % env.GetProjectOption("name"))

FRAMEWORK_DIR = env.PioPlatform().get_package_dir("framework-arduinopico")
patchflag_path = join(FRAMEWORK_DIR, ".patching-done")

# patch file only if we didn't do it before
if not isfile(patchflag_path):
    # Patch memmap_default.ld
    original_file = join(FRAMEWORK_DIR, "lib", "memmap_default.ld")
    patched_file = join("patches", "memmap_default.ld")
    assert isfile(patched_file)
    shutil.copy2(patched_file, original_file)

    # Patch libpico.a
    original_file = join(FRAMEWORK_DIR, "lib", "libpico.a")
    patched_file = join("patches", "libpico.a")
    assert isfile(patched_file)
    shutil.copy2(patched_file, original_file)

    # touch the patch flag file
    with open(patchflag_path, "w") as fp:
        fp.write("")
