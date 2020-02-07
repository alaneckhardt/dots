#!/usr/bin/python

import sys

def usage():
    """
    Prints usage
    """

    err("usage:")
    err("  undelete.py device text [position]")
    err("description:")
    err("  finds text on device")
    exit(1)
#enddef

def i(text): return unicode(text, "utf8")
def o(text):
    if type(text) == unicode: return text.encode("utf8")
    else: return str(text).encode("utf8")
def err(text): print >> sys.stderr, o(text)
def out(text): print o(text)

def main(arguments):
    """
    Program entrypoint
    @param arguments list
    """

    chunksize = 8192

    # usage
    argcount = len(arguments)
    if argcount != 2 and argcount != 3:
        usage()
    #endif

    device = i(arguments[0])
    text = arguments[1]
    position = int(arguments[2]) if argcount == 3 else 0

    with open(device, "rb") as descriptor:
        descriptor.seek(position)
        while True:
            chunk = descriptor.read(chunksize)
            if chunk == None: break
            index = chunk.find(text)
            if index == -1: continue

            print descriptor.tell()
            print chunk
            print
            print
        #endwhile
    #endwith

#enddef

# entrypoint
if __name__ == "__main__":
    main(sys.argv[1:])
#enddef
