# Out Of Band protocol specification

## Frame Format

Commands sent from the client to the server or the server to the client follow
the same frame format:

```
  frame = header, {field}, "end\n".
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

The frame header line is exactly 27 bytes, which enables reading it without
parsing. Once read, the length field can be used to read the whole frame, or the
frame can be parsed field by field. The router does not use the length field in
reading the frames it receives, so it may be set to zero for frames originating
from the client.

The sequence number is a random unique 31 bit number that is used to connect
replies to commands. Any response or result attached to the command will have
the same sequence number, so it can be used to demultiplex on the client side.

## Commands

### sete - SetEntity
Fields:
* REQUIRED po(0.0.0.50) - the signing entity to use

This sets the entity that is represented by the connected client. All DOTs are
generated from this entity, and messages are signed using its key.

### publ - Publish
Fields:
* REQUIRED kv(uri) - the URI to publish to. Can be given split as kv(mvk) and kv(uri_suffix)
* kv(primary_access_chain) - the hash of the primary access DOT chain to use
* kv(expiry) - the date in RFC3339 format for the message to expire
* kv(expirydelta) - the duration after now for the message to expire. Allowable suffixes include ms,s,m,h
* kv(elaborate_pac) - the elaboration level for the PAC. Allowable values are "partial" or "full". Omitting results in no elaboration.
* kv(autochain) - automatically build the PAC on the router
* ro(*) - will be included
* po(*) - will be included

This publishes a message to the given uri. A single `resp` frame will be
delivered with the same sequence number to convey the success or failure of the
publish operation

### subs - Subscribe
Fields:
* REQUIRED kv(uri) - the URI to subscribe to. Can be given split as kv(mvk) and kv(uri_suffix)
* kv(primary_access_chain) - the hash of the primary access DOT chain to use
* kv(expiry) - the date in RFC3339 format for the subscribe request to expire
* kv(expirydelta) - the duration after now for the subscribe request to expire. Allowable suffixes include ms,s,m,h
* kv(elaborate_pac) - the elaboration level for the PAC. Allowable values are "partial", "full" or "none". Omitting results in no elaboration ("none").
* kv(autochain) - boolean: automatically build the PAC on the router
* kv(unpack) - boolean: should the matching messages be unpacked
* ro(*) - will be included

This subscribes to the given URI. A single `resp` frame will be delivered
with the same sequence number to convey the success or failure of the subscribe
operation. A `rslt` frame will be delivered for every message matching the
subscription, if the `resp` frame indicated success. If `unpack` was specified,
then the messages will be unpacked into their constituent ROs and POs.

### pers - Persist
A persist frame is exactly the same as a publish frame.

### list - List
Fields:
* REQUIRED kv(uri) - the URI to list. Can be given split as kv(mvk) and kv(uri_suffix)
* kv(primary_access_chain) - the hash of the primary access DOT chain to use
* kv(expiry) - the date in RFC3339 format for the list request to expire
* kv(autochain) - boolean: automatically build the PAC on the router
* kv(expirydelta) - the duration after now for the list request to expire. Allowable suffixes include ms,s,m,h
* kv(elaborate_pac) - the elaboration level for the PAC. Allowable values are "partial", "full" or "none". Omitting results in no elaboration ("none").
* ro(*) - will be included

This lists the children of the given URI. A single `resp` frame will be delivered
with the same sequence number to convey the success or failure of the operation.
A `rslt` frame will be delivered for every child. The result frame will contain
two fields: kv(finished) which will be "true" if there are no more results, or
"false" if there are more results. If "false", there will also be kv("child")
containing the full URI of the child.

### quer - Query
Fields:
* REQUIRED kv(uri) - the URI to query. Can be given split as kv(mvk) and kv(uri_suffix)
* kv(primary_access_chain) - the hash of the primary access DOT chain to use
* kv(expiry) - the date in RFC3339 format for the query request to expire
* kv(expirydelta) - the duration after now for the query request to expire. Allowable suffixes include ms,s,m,h
* kv(autochain) - boolean: automatically build the PAC on the router
* kv(elaborate_pac) - the elaboration level for the PAC. Allowable values are "partial", "full" or "none". Omitting results in no elaboration ("none").
* kv(unpack) - boolean: should the matching messages be unpacked
* ro(*) - will be included

This queries the given URI. A single `resp` frame will be delivered
with the same sequence number to convey the success or failure of the operation.
If `resp` indicated success, a `rslt` frame will be delivered for every message
matching the query. If `unpack` was specified, then the matching messages will
be unpacked into their constituent ROs and POs.

### tsub - Tap Subscribe
A tap subscribe frame is the same as a subscribe frame. It is not currently implemented

### tque - Tap Query
A tap query frame is the same as a query frame. It is not currently implemented

### make - MakeEntity
Fields:
* kv(contact) - the contact information for this entity
* kv(comment) - the comment information for this entity
* kv(expiry) - the date in RFC3339 format for the entity to expire
* kv(expirydelta) - the duration after now for the entity to expire. Allowable suffixes include ms,s,m,h
* MULTIPLE kv(revoker) - the verifying key of an entity authorized to revoke this entity
* kv(omitcreationdate) - bool: if true, do not include the creation date in this entity

This creates a new entity, generating the keypair. It returns a `resp` frame
with an error if something went wrong, otherwise it returns a `rslt` frame with
kv(vk) and po(1.0.1.2) for the created entity.

### makd - MakeDOT
Fields:
* REQUIRED kv(to) - the VK to issue the DOT to
* kv(ttl) - the time to live for the DOT (allowed transfers)
* kv(ispermission) - bool: defaults to false. If true, this is an application level permission DOT
* kv(expiry) - the date in RFC3339 format for the DOT to expire
* kv(expirydelta) - the duration after now for the DOT to expire. Allowable suffixes include ms,s,m,h
* kv(contact) - the contact information for this DOT
* kv(comment) - the comment information for this DOT
* MULTIPLE kv(revoker) - the verifying key of an entity authorized to revoke this DOT
* kv(omitcreationdate) - bool: if true, do not include the creation date in this DOT
* kv(accesspermissions) - if this is an access DOT, these are the access permissions
* kv(uri) - if this is an access DOT this is the URI. Can be given split as kv(mvk) and kv(uri_suffix)

This creates a new DOT, from the connection's entity to the given entity.
It returns a `resp` frame with an error if something went wrong, otherwise it
returns a `rslt` frame with kv(hash) and a ro for the created DOT.

### makc - MakeChain
Fields:
* kv(ispermission) - bool: if true, this is an application level permission chain. Defaults to false
* kv(unelaborate) - bool: if true, return the RO of the unelaborated chain. Defaults to false
* MULTIPLE kv(dot) - the hash of a DOT to include in the chain, must appear in order

This creates a new DOT chain made of the given dots. It returns a `resp` frame
with an error if something went wrong, otherwise it returns a `rslt` frame with
kv(hash) and a po for the created DChain.

# New commands for 2.1.x

### putd - Publish a DOT to the registry
Fields:
* kv(account) - How to pay for the publish
* po(0.0.0.32) - The DOT to publish

This uses the given account idx for the currently set entity to publish the
given RO to the chain. Note that this will fail if the entities are not
already published. Returns kv("hash")

### pute - Publish an Entity to the registry
Fields:
* kv(account) - How to pay for the publish
* po(0.0.0.48) - The entity to publish
OR
* po(0.0.0.50) - The signing entity to publish (will strip SK)

This uses the given account idx for the currently set entity to publish the
given RO to the chain.

### putc - Publish a Chain to the regisry
Fields:
* kv(account) - How to pay for the publish
* po(0.0.0.2) - The access dchain to publish

This uses the given account idx for the currently set entity to publish the
given RO to the chain. Note that this will fail if the DOTs are not
already published.

### ebal - Entity balances
No fields are required.

Get the balances for the currently set entity's accounts. It returns a `resp`
frame with an error if something went wrong, otherwise it returns a `rslt` frame
with at least sixteen accounts of type PO
contains the account address in hex. kv(balance)  contains
rawbalance,humanreadable where the raw balance is in decimal wei and
humanreadable  is an imprecise but easy to understand string. Be careful
decoding rawbalance, as  balances of >1 Mether are possible, which equates to
>10^24 wei, more than fits  in a 64 bit number.

### abal - Address balance
Fields:
* kv(address) - 40 characters of hex address

Get the balance for the given address (not necessarily one you own). It returns
a `resp` frame with an error if something went wrong, otherwise it returns a
`rslt` frame with kv(balance) of the same form as `ebal`. For some addresses,
there may be a mapping from account address to the owner's VK. If this is the
case, there will be kv(vk) containing the owner's VK.

### bcip - Block Chain Interaction Parameters
Fields:
* OPTIONAL kv(confirmations) - The minimum number of confirmations for on-chain operations
* OPTIONAL kv(timeout) - The maximum number of blocks to wait for a transaction to occur
* OPTIONAL kv(maxage) - The maximum age of the block chain to permit before erroring (s)

All of the current values are returned.

### xfer - Transfer
Fields
* kv(account) - Which account to transfer from
* kv(address) - The address to transfer to (40 characters of hex)
* kv(valuewei) - The how much to transfer (in integer wei)
OR
* kv(valuefinney) - The how much to transfer (in integer finney)
OR
* kv(value) - The how much to transfer (in integer ether)
* OPTIONAL kv(gas) - The transaction gas. This generally does not need to be specified
* OPTIONAL kv(gasprice) - The gas price. This generally does not need to be specified
* OPTIONAL kv(data) - The binary data to include in the transaction. This generally does not need to be specified

Make a transfer from the active account to the given address. This is an
on-chain operation, so the chain interaction parameters come into play.

### mksa - Make short alias
Fields
 * kv(account) - Which account to transfer from
 * kv(content) - The content, in binary. If the content is longer than 32 bytes, it will be truncated.

Create a short alias. This is an on-chain operation (see `bcip`). If there was no error, the `rslt` frame will contain kv(hexkey) the key, in hex.

### mkla - Make long alias
Fields
 * kv(content) - The content, in binary. If the content is longer than 32 bytes, it will be truncated.
 * kv(key) - The key, as raw bytes. If the key is longer than 32 bytes it will be truncated. If the key is shorter
                it will be padded on the right with zeroes.

Create a long alias. This is an on-chain operation (see `bcip`). Note that it is not allowed to create a long alias
that collides with the short alias reservation (they are in the same namespace). Check the contract implementation for
details.

### resa - Resolve alias
Fields
 * kv(longkey) - A long key. If it is shorter than 32 bytes it will be padded on the right with zeroes
 OR
 * kv(shortkey) - A hex encoded short key.
 OR
 * kv(embedded) - A string with one or more full aliases in it, for example @longAlias</my/uri/@5BA3>/foo. Each alias will be resolved, turned into a string
 and have trailing zeroes trimmed.

 ### usrv - Update a SRV record
 * kv(account) - The account idx to pay with
 * kv(srv) - The text SRV record, preferably IP:port not hostname:port
 * OPTIONAL(po(ROEntityWKey)) - The entity to update the SRV record for. This
     allows the currently set entity to pay for another entity's SRV
     record. In the absence of this field, the SRV is for the current
     entity.

 ### ndro - New designated router offer
 Fields
 * kv(account) - The account idx to pay with
 * kv(nsvk) - The namespace verifying key to create an offer for. If it fails
              to parse as a 44-character VK, it will be tried as a long alias.
 * OPTIONAL(po(ROEntityWKey)) - The entity to create the DR offer from. This
              allows the currently set entity to pay for another entity's DR
              offer. In the absence of this field, the DR offer comes from
              the current entity.

 ### adro - Accept designated router offer
 Fields
 * kv(account) - The account idx to pay with
 * kv(drvk) - The designated router's verifying key If it fails
              to parse as a 44-character VK, it will be tried as a long alias.
 * OPTIONAL(po(ROEntityWKey)) - The entity to accept the DR offer from. This
              allows the currently set entity to pay for another entity's DR
              acceptance. In the absence of this field, the DR accept comes from
              the current entity.

 ### ldro - List designated router offers
 Fields
 * kv(nsvk) - The namespace to find DR offers for. If it fails
              to parse as a 44-character VK, it will be tried as a long alias.

 ### rsro = Resolve registry object
 Fields
 * kv(key) - The key to resolve. If not a 44 character hash/vk then it will be resolved
             as a long alias first.
