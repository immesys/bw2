bw2.io
======

## How to install the alpha release

If you are using a 64 bit Ubuntu release >= 14.04 then the recommended method is:

```
curl get.bw2.io/alpha | sh
```

## What is new

Assuming you are familiar with BOSSWAVE, what is new in 2.1.0?

### Full decentralization

Starting with 2.1.0 there are no more centralized components, not even DNS. BW 2.0.x used to use DNS for storing three important records:
a) The mapping from a namespace symbolic name to the namespace verifying key
   (e.g. castle.bw2.io/my/url -> CSnDzka2Nuu5e0UmOR6FH9YEYwIdEx5GwaD_ms9rDV0=/my/url)
b) The mapping from a namespace verifying key to the designated router
   (e.g. CSnDzka2Nuu5e0UmOR6FH9YEYwIdEx5GwaD_ms9rDV0= -> _jP3esBVf5QfTRaJJ4reVXyiRTwHgtPziBSPA_lW4_Y=)
c) The mapping from a designated router verifying key to an IP address and port
   (e.g. _jP3esBVf5QfTRaJJ4reVXyiRTwHgtPziBSPA_lW4_Y= -> 128.32.37.201:4514)

While these records were secure in that they were signed and delivered using DNSSEC, they were centralized in that the client would always look on a specific domain for these records (bw2.io). In 2.1.0+ these three mappings still exist, but are managed in a smart contract on the blockchain:
- a is done by the 'Alias' contract which will be covered below
- b and c are done by the 'Affinity' contract which will also be covered below

### Consistent routing object views

In BW 2.0.x, every router had its own database of routing objects (Entities, DOTs and DOT Chains). When a new routing object was created, the creator needed to ensure that everyone who might want to use that object was sent a copy of it. This worked well for most cases (the designated router was usually sent a copy and other clients knew to ask it for the objects) but often a chain could not be built because your local router was not aware of all the objects necessary to form a chain of trust, or a message was rejected by the remote service because it was not aware of some critical DOTs. BW has always supported fully self-standing proofs ("fully elaborated" chains) so these were relied upon as a way to ensure that your message was always received, but it did not alleviate the chain building problems.

BW 2.1.0 fixes this by providing every router on with a consistent view of all routing objects. If a person creates an entity or grants a DOT on one machine, everyone else will know about it after a bounded propogation time. Furthermore, the publisher of the object will have a guarantee that everyone else knows about the object. This guarantee is significantly stronger than the conventional one (offered by standard DHT propogation schemes) that says *some* nodes will know of the existence of the object. It is strong enough that you can invert it to get a proof of nonexistance. A service can know that there a specific object has not been published. This is actually extremely useful for revocations, a problem that plagues many crypto systems.

### Currency and contracts

As alluded to above, BW 2.1.0 integrates a heavily modified version of the Ethereum blockchain. Every BW entity has a set of accounts associated with it, and those accounts can have Ether in them. Ether can be used to make microtransactions and interact with smart contracts. Many of the new features in BW 2.1.0 are implemented as contracts, so for example an operation such as publishing a DOT will require a small amount of Ether.

## Getting started

To jump right in to the good parts of BW 2.1.0, let us walk through creating your own namespace and working with it.

### Creating an entity

To start with, you are going to need an entity that has some BW Ether to *bankroll* your operations. Create an entity, and make sure to tell bosswave to not try publish it (you don't have the money to publish yet!) Save it to "highroller.ent":

```
bw2 mke --nopublish -o highroller.ent
```

If you take a look at this entity, you will see it has several accounts attached to it, all of which are empty (your numbers will be different from mine):

```
$ bw2 inspect highroller.ent

┳ Type: Entity key file
┣┳ Entity VK=jMYG9Oj0bqbmITTSqdACFBztgNcVR2oE1w4tglmQyGQ=
┃┣ Signature: valid
┃┣ Registry: UNKNOWN
┃┣ Keypair: ok
┃┣ Balances:
┃┃┣  0 (0x801c65f2e06c72326a383da70e266271befced2a) 0.000000 Ξ
┃┃┣  1 (0x9ccd2a8b1f9c64c3fa46cb08c4013c69d04097aa) 0.000000 Ξ
┃┃┣  2 (0x0d3e4927ab9922102de34d3a80f16732f9fd54d5) 0.000000 Ξ
┃┃┣  3 (0x2dc672b035fe78d68c883710a6b1c6407e122775) 0.000000 Ξ
┃┃┣  4 (0x11d18aae1491e5b9966d2eff5b48c40d9133018e) 0.000000 Ξ
┃┃┣  5 (0xd9329448391a5060a42584df484062ea56c40adc) 0.000000 Ξ
┃┃┣  6 (0xe10de834ba801e67afc87e4887534849229a4d39) 0.000000 Ξ
┃┃┣  7 (0xe295064d24fd67718495ee67dbacd36588e2d43d) 0.000000 Ξ
┃┃┣  8 (0x7a001bfece365cd822ecf3af75fe8d2a14de4ff9) 0.000000 Ξ
┃┃┣  9 (0xe3d1e1ad516cf5b32598518cf5d5c0ac7cdc9d4d) 0.000000 Ξ
┃┃┣ 10 (0x91f2620f56a1dc1d6e0ba43faa652588aa7db249) 0.000000 Ξ
┃┃┣ 11 (0x8e660a6b238e9b314adbcf5aaf98a5bc15e1f06b) 0.000000 Ξ
┃┃┣ 12 (0x2202c20c75bf98c7fe6c3676a85420b5c25cfad4) 0.000000 Ξ
┃┃┣ 13 (0xfc7565d1505b41a93c88dd08f7a1dfd67f8c73e5) 0.000000 Ξ
┃┃┣ 14 (0x8f8208cb48070244bf7b34bd11cb92f48d317c17) 0.000000 Ξ
┃┃┣ 15 (0xfe4d5e616da0f98a4407f186ac82b6661753f2fc) 0.000000 Ξ
┃┣ Created: 2016-04-04T19:58:17-07:00
┃┣ Expires: 2016-05-04T19:58:17-07:00
```

Now, we need to fulfill this entity's purpose by giving it a bunch of cryptocurrency. Generally you will mine this Ether or purchase it. During development, however, I have created several "cold storage" tokens that can be redeemed. Get one of those and scrape off the sticker. There will be four groups of 4 characters underneath. Transfer the currency to the entity with:

```
bw2 redeem <token> --to <account>
```

Where <account> is the address of the first account in the entity you saw above, for example:

```
bw2 redeem d4ce 7a2d d948 19cd --to 0x801c65f2e06c72326a383da70e266271befced2a
```

It will take a few seconds to decode the cold storage token, and then you will see a prompt that looks like:

```
Current BCIP set to 2 confirmation blocks or 20 block timeout
confirming:🔗🔗🔗 (last block genesis was 28 seconds ago)
```

This is the on-chain confirmation status. It will show at the end of every on-chain bw2 command. Essentially it says that your current Block Chain Interaction Parameters (BCIP) say that you need to wait for 2 blocks after the initial appearance of the transaction in order to consider it successful. 2 confirmations is generally about 4 or 5 blocks (the little chain link icons), because the first block's genesis was before you made the transaction (miner's choose the block contents, then spend roughly 15 seconds sealing them). The second block may or may not have your transaction depending on how fast your transaction propogated through the network, the third block will have it, the fourth is the first confirmation and the fifth is the second confirmation.

Once the confirmations have been received, it will tell you the transaction was successful. Now you should have about 200 Ξther.

Many things require your entity to be published (like publishing DOTs involving the entity). Entities are published by default when created (paid for by a second 'bankroll' entity) but we specified --nopublish. Lets inspect our entity and publish it. We are using a new (but common) parameter now: '--bankroll'. Sometimes, when doing things like creating DOTs, bw2 will default to trying to charge the "from" entity for the operation. Sometimes that entity does not have any money, and doesn't really need any. You can specify an entity whose purpose is simply to pay for the operation (from account 0) with the --bankroll parameter.

```
bw2 inspect --publish --bankroll highroller.ent highroller.ent
┳ Type: Entity key file
┣┳ Entity VK=jMYG9Oj0bqbmITTSqdACFBztgNcVR2oE1w4tglmQyGQ=
┃┣ Signature: valid
┃┣ Registry: UNKNOWN
┃┣ Keypair: ok
┃┣ Balances:
┃┃┣  0 (0x801c65f2e06c72326a383da70e266271befced2a) 29.399832 Ξ
┃┃┣  1 (0x9ccd2a8b1f9c64c3fa46cb08c4013c69d04097aa) 0.000000 Ξ
┃┃┣  2 (0x0d3e4927ab9922102de34d3a80f16732f9fd54d5) 0.000000 Ξ
 ... snip ...
Waiting for entity jMYG9Oj0bqbmITTSqdACFBztgNcVR2oE1w4tglmQyGQ=

Current BCIP set to 2 confirmation blocks or 20 block timeout
confirming:🔗🔗🔗🔗 (last block genesis was 3 seconds ago)  
Successfully published Entity jMYG9Oj0bqbmITTSqdACFBztgNcVR2oE1w4tglmQyGQ=
```

You will notice that it said "Registry: UNKNOWN" in red. If you run `bw2 i highroller.ent` again, it should now say "valid" as we have published it.

As we will do quite a few things that need bankrolling as we go on, it can be tedious to keep including '-b highroller.ent' with every command. You can specify a default bankroller by setting an environment variable (I put mine in my ~/.profile file):

```
export BW2_DEFAULT_BANKROLL=`pwd`/highroller.ent
```

### Creating a namespace

Let's create an entity that we will use as a namespace authority (the root of a URL tree). This time, we will specify some additional info so that people looking your entity up can see your contact information. We'll also extend the default expiry (30d) to one year:

```
bw2 mke --contact "Oski Bear <demo@user.com>" \
        --comment "Namespace Authority" \
        --expiry 1y \
        --outfile ns.ent
```

This will now create and publish (using the bankroll parameter we set in the previous section) the entity. If you inspect it you should see it says it is valid on the registry. As we want to use this as a namespace, let us also create an alias for it's verifying key so that URIs are more readable:

```
bw2 mkalias --long "oski.demo" --b64 yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=
```

Where the b64 parameter is the verifying key (VK) copied from `bw2 i ns.ent`. If you are following this guide, you need to choose your own alias name, otherwise you will get:

```
Error creating alias: [514] Alias exists (with a different value)
```

This is because aliases are unique and immutable. Assuming you succeed, you (and other people) can run

```
bw2 i oski.demo
┳ Type: Entity (no key)
┣┳ Entity VK=yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=
┃┣ Signature: valid
┃┣ Registry: valid
┃┣ Contact: Oski Bear <demo@user.com>
┃┣ Comment: Namespace Authority
┃┣ Created: 2016-04-04T20:34:11-07:00
┃┣ Expires: 2017-04-04T20:34:11-07:00
```

You will notice that it says the type is Entity (no key), this is because that information was obtained from the global registry, not the file on your computer, and the registry only contains the public key.

Now that we have our namespace entity, we need to bind it to a designated router in order for people to be able to send traffic on it. Designated routers are just like normal bosswave nodes except that they must have a public IP address. As it stands, your router would make a poor designated router because nobody knows about it's key nor about how to connect it. The first part we can solve by publishing the entity the same way as we did earlier. The second part we solve by updating the SRV record to our IP and port:

```
sudo bw2 i --publish /etc/bw2/router.ent
sudo bw2 usrv --dr usrv --dr /etc/bw2/router.ent --srv 128.32.37.230:4514

The sudo is required because the local router's private key (stored by default in /etc/bw2/) should not be accessible to you. Now, you can make your router *offer* to be the designated router for our namespace like so:

```
sudo bw2 mkdroffer --dr /etc/bw2/router.ent --ns oski.demo
```

You can verify that this worked by querying for open routing offers for the `oski.demo` namespace:

```
bw2 listDRoffers --ns oski.demo
No accepted offers found
There are 1 open offers:
 SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
```

To finish the binding (called an affinity) between the namespace and the designated router, you need to accept the offer using the namespace's key:

```
bw2 acceptDRoffer --ns ns.ent --dr SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
```

Note that you need to specify the private key file for the namespace, you cannot use the public key alias "oski.demo" because the acceptance needs to be signed by the namespace. If you query for routing offers for `oski.demo` again, you should see that there is an active affinity:

```
bw2 listDRoffers --ns oski.demo
 Active affinity:
   NS : yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=
   DR : SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
  SRV : 128.32.37.230:4514
 There are 1 open offers:
  SNZv19fX34Zyj0tNu_EzLDmB7kDLOFrFcfnzSaWsHiA=
```

Congratulations, you are now the proud owner of your very own namespace. All permissions on the `oski.demo` namespace have to be granted directly or indirectly from the ns.ent private key.

### Granting permissions

For the sake of example, let us create a few entities that will represent colleagues. We defer the publish to the end to avoid multiple waits for confirmations

```
bw2 mke -o alice.ent --nopublish
bw2 mke -o bob.ent --nopublish
bw2 mke -o carol.ent --nopublish
bw2 i --publish *.ent
```

To keep things simple, we are going to use some dummy URIs. Later, we will see how URIs are structured and how to deploy BW services.

Let us say that Alice is the head of engineering. She ought to be able to do anything under the engineering section of the namespace. We can codify that as:

```
bw2 mkdot --from ns.ent --to alice.ent --uri "oski.demo/engineering/*" --ttl 5 --permissions "PC*"
```

This says that `alice.ent` is allowed to publish (P) and subscribe (C) including wildcards (*) on any URI beginning with oski.demo/engineering. The TTL parameter specifies over how many hops this this trust can be *re-delegated*. By default it is zero which says that we trust alice (one hop), but do not trust the people that she trusts (more than one hop). Note that although we are using alice.ent (the private key file) as a target for convenience, we could also use the full VK or an alias as the 'to' parameter. The 'from' parameter must be a private keyfile.

Let us say that Bob is in charge of making reports, so Alice wants him to be able to read all the resources from the 'epic' project:

```
bw2 mkdot --from alice.ent --to bob.ent --uri "oski.demo/engineering/projects/epic/*" --permissions "C*"
```

Now let us see how this chain of trust is working. Let's ask bw2 to try find a chain of trust that allows bob to subscribe to some sensor data. As a small note, if you are following along extremely fast, the client BCIP of 2 confirmations is less strict than the code that validates permissions, which requires 5 confirmations, so you may need to wait 3 blocks (a minute or two) after executing the previous mkdot command and the following builchain command.

```
bw2 buildchain -t bob.ent --uri "oski.demo/engineering/projects/epic/sensorobj/interface" -x "C"
```

You should see something similar to:

```
┣┳ DChain hash= bBrkiAnbIYafEMjYk0jwDVybgcOXUhSSZFztTh0uwEQ=
┃┣ Registry: UNKNOWN
┃┣ Elaborated: True
┃┣ Grants: C*
┃┣ On: yDrnmqzJd6C7DF0c575upjQl3vOeCPSS9y4UVlKK8SY=/engineering/projects/epic/*
┃┣ End TTL: 0
```

You can also publish the chain by adding --publish to your command, but that is not necessary. If you want to see more information about the chain, try adding --verbose to the build chain command.
