# tools for low level contract development

This is a collection of terribly written tools for my use, to develop contracts

bwfile2hex.py: convert an entity/dot to a hex string that can be pasted in js
ccenv.js: include this in geth console to get a "contract compile" environment
csols.py: compile "contract.sol" into "contract.com" which can be included into js
          I typically say "watch csols.py" so it keeps running
framework.js: some utility functions I use interactively in geth console. It has
              my passphrase in it :-)
mktest.ipy: edit this to create contract test sequences. It generates "gen.js" which
            apparently gets quite large if you have big tests...
test_shorten.ipy: an example test (this one does short alias)
test_tooling.ipy: the test generation tools
uficompile.ipy: take a sol file and give you the UFIs, e.g:
  uficompile.ipy mycontract.sol theaddressitisat:
    -- all your ufis
  If you say "gen" after the address, it will generate copy-pastable go code
uutohex.py: convert urlencoded data to hex
