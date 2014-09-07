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

A *routing table* is the equivalent of the affinity certificate in the original BOSSWAVE. It is a signed document listing the URI prefixes, corresponding router verifying key, and preference weight for URI's under a given verifying key. If a client lists multiple routers with the same prefix, it promises to duplicate all
its messages and send them to all the listed routers. In this way, a consumer wishing to use a URI may choose any of the listed routers.

## Underlying network

Bosswave 2 is an overlay network, constructed upon TCP/IP. Routers listen on TCP port 28589 for connections
from clients or other routers.

## Router messages

### Message structure
	MESSAGE TYPE 1 byte
		0x01 : PUBLISH

	<type specific block>
	routing_objects
	payload_objects

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

Note that if Full DChains or DoTs exist before a message, they will be considered
in the context of that message, so a client can give a self-contained proof of
permission in one message.

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
		object
	MVK: 32 bytes
	URI SUFFIX LEN: 2 bytes
	URI SUFFIX: <URI LEN> bytes
	routing objects
	payload objects

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
	as a match all

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



Parameters:
	






### OBTAIN_AFFINITY

Clients obtain 


## Router verified capabilities

Although bosswave 2 is creating an overlay network for the purpose of increasing in-core functionality, we are still attempting to only implement a minimal subset in-core. As such, only four capabilities are known to the routers. These are verified in-core. These always start at the router's VK and pass through the MVK for the URI. They may pass through multiple DoTs in the chain before reaching the final entity. The DChain hash for 'first tier' capabilities is included in the bw2 headers themselves. 

### CONSUME(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to consume any uri having the given prefix. Consuming differs from tapping in that it counts in deliver-to-N messages.

### TAP(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to tap any uri having the given prefix. Tapping does not count in deliver-to-N messages.

### PUBLISH(uri_prefix, tx_limit, store_limit)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to publish messages to any uri below the given path. Tx_limit is the number of bytes the grantee can publish in a time period (including headers). The time period is not currently defined. The store_limit, if nonzero, allows the grantee to publish messages that persist on the server. These messages can be obtained by consumers using the QUERY message. Store_limit is the total number of bytes (including metadata) that can be stored.

### LIST(uri_prefix)

This capability is granted from the router via the MVK to a potential consumer. It allows the grantee to list the known children URIs for any URI beneath the prefix.




Messages
--------

