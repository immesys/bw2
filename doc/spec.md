# Bosswave 2 Protocol Documentation

This document is the canonical bosswave2 (bw2) protocol documentation. Client implementors should consult this document.

## Nomenclature

Bosswave 2 differs from the original BOSSWAVE in the nomenclature of some of the components of the system.

The endpoints in a bw2 network are referred to as *entities*, and are identified by a *verifying key* or *vk*. Strictly, any process in posession of the corresponding *signing key* or *sk* is considered to be that
entity. So a load balanced entity may in fact comprise several hosts despite being a single entity. Despite this, this document generally utilizes examples that assume an entity is a singular process.

A bw2 packet is referred to as a *message* and is in no way restricted by the underlying network packet size.

The component that distributes messages from *clients* that are *producers* to clients that are *consumers* is called a *layer 7 router* or simply *router* in bosswave 2. This differs from the original BOSSWAVE which refered to these as brokers. This is an attempt to prevent new users of bosswave from comparing it to traditional pub/sub architectures, as this will lead to many false assumptions about the system.

There exists a distributed hash table referred to as *the DHT* throughout this document which is used to store certain bootstrapping information.

A *hash* in this system refers to a sha256 hash.

*Capabilities* are granted to entities in the system by a chain of *Declarations of Trust* or *DoTs* from the canonical owner of that capability to entity being granted the capability. Each DoT consists of the VK of the grantor, the VK of the grantee, and a representation of the capability. Generally a DoT is referred to by its hash, and if the full version is required, it is resolved from the DHT.

A chain of DoTs from the canonical owner to another entity is called a *DoT chain* or *DChain*. Often this is also referred to by hash.

A *URI* in this sytem follows the schema of:

	bw://root_element/more/path/elements/

The first element of the URI is the url safe base64 encoded verifying key of the canonical owner of the uri. This is referred to as the *master verifying key* or *MVK*. If this is replaced with a host name, the VK can be retrieved via a TXT record lookup on _bw2_vk.hostname via DNS, although implementers SHOULD reject any DNS servers not using DNSSEC.

A *routing table* is the equivalent of the affinity certificate in the original BOSSWAVE. It is a signed document listing the URI prefixes, corresponding router verifying key, and preference weight for URI's under a given verifying key. If a producer lists multiple routers with the same prefix, it SHOULD duplicate all
its messages and send them to all the listed routers. In this way, a consumer wishing to use a URI may choose any of the listed routers. This requirement is not a MUST, however, as network problems to one router should not prevent the producer from sending messages to the other routers on the routing table.

## Underlying network

Bosswave 2 is an overlay network, constructed upon TCP/IP. The native bosswave protocol is over TCP, and the recommended port is 28589. Routers MAY also choose to support BW/HTTP, BW/UDP. In addition there
from clients or other routers.

## Router messages

### Data message structure:
	MESSAGE TYPE 1 byte
		0x01 : PUBLISH
		0x02 : SUBSCRIBE
		0x03 : TAP
		0x04 : QUERY
		0x05 : TAP_QUERY
		0x06 : LS
		0x07

	<type specific block>
	routing_objects
	payload_objects
	tag_objects

	routing object:
		object type
			0x01 : Access DChain hash
			0x11 : Permission DChain hash
			0x02 : Access full DChain of DoT hashes
			0x12 : Permission full DChain of DoT hashes
			0x20 : DoT
			0xFF : no more objects
		object length: 1 byte (omitted if type is 0xff)
	payload object:
		4 bytes : object type
			0.0.0.0 : no more objects
		4 bytes : length (not including these 8 bytes)
		HEADER LENGTH: 1 byte
	tag object:
		same as routing object

Note that if Full DChains or DoTs exist before a message, they will be considered
in the context of that message, so a client can give a self-contained proof of
permission in one message. Depending on router configuration, this may be the only
way to get a router to accept a message (a cache free, non-hash-resolving config
for example).

### PUBLISH
	COMMAND_TYPE: 0x01
	MESSAGE ID: 2 byte
	CONSUMER_LIMIT: 1 byte, 0x00 implies no limit
	PERSIST: 1 byte
		0x00: do not persist
		0x01: persist forever
		0x4?: bottom 6 bits are seconds
		0x8?: bottom 6 bits are minutes
		0xc?: bottom 6 bits are hours
	SIGNATURE: 32 bytes
		the signature covers everything from the MVK until the last payload
		object. It does NOT cover any tag objects
	MVK: 32 bytes
	URI SUFFIX LEN: 2 bytes
	URI SUFFIX: <URI LEN> bytes
	routing objects
	payload objects
	tag objects

	If the routing objects contains a dchain or a dchain hash, the first one found
	will be used to authenticate the message. If the hash cannot be resolved, or
	the dots in the chain cannot be resolved, BWCP_UNRESOLVEABLE will be sent with
	the list of hashes that could not be resolved.

### SUBSCRIBE
	MESSAGE_ID: 2 byte
	MVK: 32 bytes
	URI SUFFIX LEN: 2 bytes
	URI SUFFIX: <URI LEN> bytes
	routing objects, especially access DChain

	A URI would always be of the form:
	master_verifying_key/further/elements

	so as an optimisation, we transfer the MVK in binary. The URI is UTF-8 encoded, '/'
	reserved for path seperators, '+' reserved for any one path element and '*' is reserved
	as a match all. Note that both '+' and '*' require more permissions than a simple subscribe

### TAP
	A tap body is identical to a subscribe body

### QUERY
	MESSAGE_ID: 2 byte
	MVK: 32 bytes
	URI SUFFIX LEN: 2 bytes
	URI SUFFIX: <URI LEN> bytes
	routing objects, especially access DChain

	Wildcards are permitted in a query uri

### TAP_QUERY
	A tap_query body is identical to a query body

### LS
	MESSAGE ID: 2 byte
	MVK: 32 bytes
	URI SUFFIX LEN: 2 bytes
	URI SUFFIX: <URI LEN> bytes
	routing objects, especially access DChain

	An LS message will return a list of known immediate children for a given URI. A known child can only
	exist if the children streams have persisted messages

### CONNECT_SYN
	CNONCE: 32 bytes
	CLIENT VK: 32 bytes
	FLAGS:
		0x01 : 1=empty queues, 0=retain queues

### CONNECT_ACK
	SIGNED_SNONCE: 64 bytes

## SERVER -> CLIENT MESSAGES

### CONNECT_SYNACK
	SNONCE: 32 bytes
	SIGNED_CNONCE: 64 bytes


### OBTAIN_AFFINITY

Clients obtain


## Router verified capabilities

Although bosswave 2 is creating an overlay network for the purpose of increasing in-core functionality, we are still attempting to only implement a minimal subset in-core. As such, only four capabilities are known to the routers. These are verified in-core. These always start at the router's VK and pass through the MVK for the URI. They may pass through multiple DoTs in the chain before reaching the final entity. The DChain hashes for 'first tier' capabilities are included in the routing objects.

### CONSUME(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to consume any uri having the given prefix. Consuming differs from tapping in that it counts in deliver-to-N messages. A client cannot consume URI's containing a + or a * with this permission.

### CONSUME_PLUS(uri_prefix)

This implies all the capabilities of CONSUME, but also allows the use of '+' (single level wildcard) within a URI.

### CONSUME_STAR(uri_prefix)

This implies all the capabilities of CONSUME_PLUS, but also allows the use of '*' (multiple level wildcard) within the URI.

### TAP(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to tap any uri having the given prefix. Tapping does not count in deliver-to-N messages.

### TAP_PLUS(uri_prefix)

Like CONSUME_PLUS but using TAP semantics

### TAP_STAR(uri_prefix)

Like CONSUME_STAR but using TAP semantics

### PUBLISH(uri_prefix, tx_limit, store_limit)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to publish messages to any uri below the given path. Tx_limit is the number of bytes the grantee can publish in a time period (including headers). The time period is not currently defined. The store_limit, if nonzero, allows the grantee to publish messages that persist on the server. These messages can be obtained by consumers using the QUERY message. Store_limit is the total number of bytes (including metadata) that can be stored.

### LIST(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to list the known children URIs for any URI beneath the prefix.


Payload objects
---------------

Allocations:

1.0.0.0/8 Reserved for BOSSWAVE internal objects

1.0.1.0 Symlink
A symlink contains a URI that should be transparently resolved for operations.

1.0.1.1 Privilege escalation
A PrivEsc object indicates that it is possible for the recipient to escalate their
privileges. It can be used for publicly accessible information (Any client messaging
X URI will receive a DoT to access this URI). Or for conversion of permissions (show
me your DCHain to URI X and I will issue you permissions for DChain Y, useful for simlinks).


Declaration of Trust
--------------------

Note to self: include way to make a DoT dependant on the validity of another DoT or DChain

Router configuration options
----------------------------

## Hash cache

A router can store a cache of DChains and DoTs so that hashes can be resolved and evaluated. This
takes memory, but means messages can be more succinct

## DHT resolution

Instead of sending a BWCP_UNRESOLVEABLE response to hash that is not in the cache, the router will
first attempt to resolve it from the DHT.

## Relay

If traffic is sent to the router, but it is not the designated carrier on the URI's routing table,
should the router forward the traffic to the correct router, instead of sending BWCP_NOTCARRIER.
Similarly if a client subscribes to a URI outside the domain of the router, should it subscribe
upstream or should it reject.

## Elaborate (ondemand, preemptive, none)
For a relay router it can also be configured to add DChain or DoTs to the message context if it
recognizes hashes within the message. This can be done on all messages (preemtive) or only upon
receipt of a BWCP_UNRESOLVEABLE message.

## OOB clients

An out-of-band client can connect via other connection mechanisms, and have the router do protocol
translation. These mechansims might be unix domain socket, HTTP, or a symmetrically encrypted session.

## Peering whitelist

Although a router may be responsible for a given URI, it may only wish to serve responses to clients
that can show a chain proving they are on the whitelist. This is useful for constructing high traffic
topics: you can have multiple endpoint routers that handle the traffic, and stay synchronized via
a spanning tree of core routers that peer. Note that these permissions are not the same as pub/sub
on the underlying data.

System architecture
-------------------

Like the Internet, Bosswave consists of routers talking to eachother. The behaviour of a router,
and what it is willing to do varies depending on where it is in the system. These generally fall
into a few categories:

## Core router

This is a router that is offering services to many clients, generally across administrative domains.

Probable configuration:
Hash cache: Maybe, with very aggressive eviction
Relaying: No
Elaborate: No
OOB clients: No
Peering whitelist: Yes


## Service providing router

This would be a router with many clients, but generally within an administrative domain, and within
a single network. It is probably on the whitelist for cross-domain URI's, although it does not require
whitelisted peers itself.

Hash cache: Maybe
Relaying: Yes
Elaborate: Maybe ondemand
OOB clients: No
Peering whitelist: No

## Endpoint service

This would be a process running on a computer, acting as the bosswave point of presence
Hash cache: Yes
Relaying: Yes
Elaborate: Yes
OOB clients: Yes, probably loopback or domain socket
Peering whitelist: No




Implementation plan
-------------------

Go based router software.
- supports elaborated DChain verification
- Supports publish + subscribe (no + or *, no publish to 1)
- Supports text based OOB

routers subscribe to routers. To handle a core router restart and the subsequent loss
of subscription information, clients should retain a list of their subscriptions and
resubscribe if the connection is terminated.
