# Out Of Band protocol specification

## Frame Format

Commands sent from the client to the server or the server to the client follow
the same frame format:

```
  frame = header, {field}, "end".
  header = command, " ", framelength, " ", seqno, "\n".
  framelength = tendigit.
  seqno = tendigit.
  tendigit = digit, digit, digit, digit, digit,
             digit, digit, digit, digit, digit.
  digit = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9".
  command = "publ"  (* publish to a uri               *) |
            "pers"  (* persist to a uri               *) |
            "subs"  (* subscribe to a uri             *) |
            "list"  (* list the children of a URI     *) |
            "quer"  (* query a given URI              *) |
            "tsub"  (* tap subscribe a URI            *) |
            "tque"  (* tap query a given URI          *) |
            "putd"  (* put a dot to a router          *) |
            "pute"  (* put an entity to a router      *) |
            "putc"  (* put a chain to a router        *) |
            "makd"  (* make a dot                     *) |
            "make"  (* make an entity                 *) |
            "makc"  (* make a chain                   *) |
            "bldc"  (* build a chain                  *) |
            "adpd"  (* add a preferred dot            *) |
            "adpc"  (* add a preferred chain          *) |
            "dlpd"  (* delete a preferred dot         *) |
            "dlpc"  (* delete a preferred chain       *) |
            "sete"  (* set the entity the client uses *).
  field = KVfield | POfield | ROfield.
  fieldlen = digit, {digit}.
  keychar = "a"|"b"|"c"|"d"|"e"|"f"|"g"|"h"|"i"|"j"|"k"|"l"|
            "m"|"n"|"o"|"p"|"q"|"r"|"s"|"t"|"u"|"v"|"w"|"x"|
            "y"|"z"|"0"|"1"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"_".
  onetwo = "1" | "2".
  octet = [onetwo], [digit], digit.
  dotform = octet, ".", octet, ".", octet, ".", octet.
  ponum = digit, {digit}.
  key = keychar, {keychar}.
  KVfield = "kv ", key, " ", fieldlen, "\n", BLOB, "\n".
  POtype = POtypedot | POtypenum | POtypeboth.
  POtypedot = dotform,":".
  POtypenum = ":",ponum.
  POtypeboth = dotform, ":", ponum.
  POfield = "po ", POtype, " ", fieldlen, "\n", BLOB, "\n".
  ROfield = "ro ", octet, " ", fieldlen, "\n", BLOB, "\n".
```

## Overview

The frame header line is exactly 27 bytes, which enables reading it without parsing.
Once read, the length field can be used to read the whole frame, or the frame can be
parsed field by field. The router does not use the length field in reading the
frames it receives, so it may be set to zero for frames originating from the client.

The sequence number is a random unique 31 bit number that is used to connect replies
to commands. Any response or result attached to the command will have the same
sequence number, so it can be used to demultiplex on the client side.

## Commands

### sete - SetEntity
Fields:
* REQ po(1.0.1.2) - the signing entity to use

This sets the entity that is represented by the connected client. All DOTs are generated from this entity, and messages are signed using its key.

### publ - Publish
Fields:
* REQ kv(uri) - the URI to publish to
* kv(primary_access_chain)
