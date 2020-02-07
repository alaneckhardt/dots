#!/usr/bin/python
"""
FILE         $Id$
AUTHOR       Jan Prochazka <jan.prochazka@firma.seznam.cz>

Copyright (c) 2014 Seznam.cz, a.s.
All rights reserved.
"""


import os
import sys
import subprocess
from threading import Thread
from threading import Lock


def usage():
    """
    Prints usage
    """

    err("usage:")
    err("  parallel.py parts command args1 arg2 ... < input > output")
    err("description:")
    err("  paralellizes job")
    exit(1)
#enddef

def i(text): return unicode(text, "utf8")
def o(text):
    if type(text) == unicode: return text.encode("utf8")
    else: return str(text).encode("utf8")
def err(text): print >> sys.stderr, o(text)
def out(text): print o(text)


def consume(process, lock):
    """
    Reads stdin and writes to proces input
    @param process Popen
    @param lock Lock
    """

    lock.acquire()
    for line in sys.stdin:
        lock.release()
        process.stdin.write(line)
        lock.acquire()
    #endfor
    lock.release()
    process.stdin.close()
#enddef

def produce(process, lock):
    """
    Reads process output and writes it to stdout
    @param process Popen
    @param lock Lock
    """

    for line in process.stdout:
        lock.acquire()
        sys.stdout.write(line)
        lock.release()
    #endwhile
#enddef

def main(arguments):
    """
    Program entrypoint
    @param arguments list
    """

    # usage
    argcount = len(arguments)
    if argcount < 2:
        usage()
    #endif

    try: parts = int(arguments[0])
    except ValueError: usage()
    command = arguments[1:]

    err("allocating workers ...")
    os.nice(5)
    producers = []
    stdinlock = Lock()
    stdoutlock = Lock()
    for _ in xrange(0, parts):
        process = subprocess.Popen(command, stdin = subprocess.PIPE, stdout = subprocess.PIPE)

        producer = Thread(target = produce, args = (process, stdoutlock))
        producer.daemon = True
        producer.start()
        producers.append(producer)

        consumer = Thread(target = consume, args = (process, stdinlock))
        consumer.daemon = True
        consumer.start()
    #endwhile

    err("working ...")
    for producer in producers:
        producer.join()
    #endfor
#enddef

# entrypoint
if __name__ == "__main__":
    main(sys.argv[1:])
#enddef

