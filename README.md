bw2.io
======

## How to install bosswave

If you are using a 64 bit Ubuntu release >= 14.04 then the recommended method is:

```
curl get.bw2.io/core | sh
```

## Manual installation

If you do not wish to install it at the system level, you can download just the binary and do the configuration manually:

```
curl get.bw2.io/linux/amd64/bw2_lv_2.0.3 -o bw2
./bw2 makeconf # Creates bw2.ini
./bw2 router # runs the local router
```

The default configuration file from makeconf stores the bosswave database in the current directory, so you will need to run `bw2 router` from the same directory each time, or modify the config file to point to an absolute path.

## Getting started

Identity in bosswave is attached to keypairs called entities. You need to create an entity to represent yourself, and then get permission from someone to use a URI namespace (or create your own). To begin, read the help documentation for `bw2 mkentity` then:

```
bw2 mkentity \
  --contact "Your Name <your@email.com>" \
  --comment "Description of entity e.g 'test' " \
  --expiry "24h" \
  --outfile "~/.ssh/id_bw2"
```

You should see an output like:
```
Entity created
SK:  xlI_Hq1EG0hpwwq7sSoan_YrP909vBnbal8tnze-LFQ=
VK:  ac0FZkgOrmWSZw5qpmm8YclvvIDM3rrcVxQpFN2jbAg=
Wrote key to file:  /home/user/.ssh/id_bw2
```
The SK is your Signing Key (private key). Do not share that with anyone. VK is your Verifying Key (public key) you can share that and make it as public as you like. For example, perhaps you receive an email from a colleague saying

```
Hi, as we discussed (in person) earlier, please allow me to publish to castle.bw2.io/example/uri/*
My key is ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ==
```

First lets try resolving that key to make sure they did not make a typo. We have never seen that key personally, so
our local router probably does not know who it is:
```
$ bw2 resolve -i ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ=
Could not resolve that ID
```
But I bet that if they want permissions on castle.bw2.io that that router may know who they are:
```
$ bw2 resolve -i ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ= -r castle.bw2.io
┣┳ Entity ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ=
┃┣ Signature valid
┃┣ Contact: Michael Andersen
┃┣ Comment: Michael Dev
┃┣ Created: 2015-06-01T20:54:56-07:00
┃┣ Expires: 2016-07-22T11:54:56-07:00
```

Voila. Now remember that anyone can put anything in the contact and comment section, so the reason we trust this key is because the full VK was put in the email and we had previously met in person and talked about getting these permissions, not because of what we read here. Resolving the key just helps prove there were no typos. If you were extra secure, you might demand that you obtain the public key through a more secure exchange method (emails can be tampered with).

Now, assuming you trust the person to do the action they are asking permission for, you can codify that trust in a Declaration Of Trust (DOT). Read the command help `bw2 mkdot -h` and then:

```
bw2 mkdot --uri "castle.bw2.io/example/uri/*" \
 --permissions P \
 --from ~/.ssh/id_bw2 \
 --to ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ= \
 --comment "Permission to example subtree" 
 --outfile michaelsDOT
```

This will create the DOT, and our local router will know about it, but unless our colleague can find the DOT, he can never use it. To fix this, we could have added a `--publishto` option to mkdot to put it somewhere public. We can also do that later by inspecting the object with `--publishto` set, for example:
```
$ bw2 inspect michaelsDOT --publishto castle.bw2.io
Inspecting:  michaelsDOT 
┳ Type: Access DOT
┣┳ DOT YYsP-tWWLcqmYYt5dQwFUkwwpG-iKc6YA1Ci9hZYtOM=
┃┣ Signature valid
┃┣ From: ac0FZkgOrmWSZw5qpmm8YclvvIDM3rrcVxQpFN2jbAg=
┃┣┳ Entity ac0FZkgOrmWSZw5qpmm8YclvvIDM3rrcVxQpFN2jbAg=
┃┃┣ Signature valid
┃┃┣ Contact: Your Name <your@email.com>
┃┃┣ Comment: Description of entity e.g 'test' 
┃┃┣ Created: 2016-03-19T11:37:58-07:00
┃┃┣ Expires: 2016-03-20T11:37:58-07:00
┃┣ To: ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ=
┃┣┳ Entity ca2zbPNtHtyKrB-4KEBPaSUUc_SVTRa5xAiSj8QWVLQ=
┃┃┣ Signature valid
┃┃┣ Contact: Michael Andersen
┃┃┣ Comment: Michael Dev
┃┃┣ Created: 2015-06-01T20:54:56-07:00
┃┃┣ Expires: 2016-07-22T11:54:56-07:00
┃┣ URI: CSnDzka2Nuu5e0UmOR6FH9YEYwIdEx5GwaD_ms9rDV0=/example/uri/*
┃┣ Permissions: P
┃┣ Created: 2016-03-19T11:38:17-07:00
┃┣ Expires: 2016-04-18T11:38:17-07:00
```

