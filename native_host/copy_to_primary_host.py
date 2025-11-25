#!/usr/bin/env python3
import sys, json, subprocess, struct

def read_msg():
    rawlen = sys.stdin.buffer.read(4)
    if len(rawlen) == 0:
        sys.exit(0)
    msglen = struct.unpack('I', rawlen)[0]
    msg = sys.stdin.buffer.read(msglen)
    return json.loads(msg)

def write_primary(text):
    try:
        subprocess.run(["xclip", "-selection", "primary"], input=text.encode(), check=True)
    except Exception:
        pass

while True:
    msg = read_msg()
    if "text" in msg:
        write_primary(msg["text"])
