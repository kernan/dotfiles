import os
import platform
import vim

def AbsolutePath(relPath):
    return os.path.join(os.getcwd(), relPath)

def GetPlatformName():
    system = platform.system()
    if system == "Linux":
        return "LINUX"
    elif system == "Windows":
        return "WIN32"
    else:
        return "nul"

def FlagsForFile(filename):
    filetype = vim.eval("&filetype")
    if filetype == "c":
        flags = [
                "-std=c11",
                "-x", "c"
                "-Wall",
                "-Wextra",
                "-I", AbsolutePath("inc"),
                "-I", AbsolutePath("include"),
                "-DDEBUG",
                "-D%s" % GetPlatformName()
                ]
    elif filetype == "cpp":
        flags = [
                "-std=c++11",
                "-x", "c++",
                "-Wall",
                "-Wextra",
                "-I", AbsolutePath("inc"),
                "-I", AbsolutePath("include"),
                "-DDEBUG",
                "-D%s" % GetPlatformName()
                ]
    return {"flags": flags, "do_cache": True}
