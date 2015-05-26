# Out Of Band protocol specification

## Frame Format

Commands sent from the client to the server or the server to the client follow
the same frame format
criteria
 - easy to use from both polling + async
 - don't rely on logic that is hard to represent
    - no binary numbers, no base64, etc

client->router commands:

<command> <length 10 digit> <id unsigned decimal 31 bit>\n
kv <key>:<valuelen>\n
value\n
po x.x.x.x:<int> <len>\n
[object of len bytes]\n
po x.x.x.x:<int> <len>\n
[object]\n
end

router->client responses first line is 4+1+10+1+10+1 = 27 chars incl newline:
<command 4 bytes> <len decimal leading space 10 chars (starting after newline)> <id unsigned decimal 31 bit 10 chars>\n
kv <key>:<valuelen>\n
<value>
ro x <len>\n
[ro of len]
po x <len>\n
[po of len]
end

seven primary commands:
publ, subs, pers, list, quer, tsub, tque

additional commands:
setp - set parameters that will apply to further commands
putd - put a dot to a router
pute - put an entity to a router
putc - put a chain to a router
makd - make a dot
make - make an entity
makc - make a chain
bldc - build a chain
adpd - add a preferred dot
adpc - add a preferred chain
dlpd - delete a preferred dot
dlpc - delete a preferred chain
