
var ma = "0x87beea80b6188fef1cacf29b33128165d788338e"
var hot = "0xe0412e6b048d07534c734e1d16886a67d0923c3f"
personal.unlockAccount(ma, "password")

var ivkvalue = 0;

eth.coinbase = ma
miner.setEtherbase("e0412e6b048d07534c734e1d16886a67d0923c3f")
miner.stop()
miner.start(1)
function bal() {
  var ebal = web3.fromWei(eth.getBalance(ma), "ether")
  //var wdiff = web3.toWei(100, "ether") - eth.getBalance(eth.accounts[0])
  console.log("DEV BAL: ", ebal, "E")

  ebal = web3.fromWei(eth.getBalance("0xe0412e6b048d07534c734e1d16886a67d0923c3f"), "ether")
  console.log("HOT BAL: ", ebal, "E")

}

function loadDev(amt) {
  eth.sendTransaction({"from":hot,to:ma,value:web3.toWei(amt)})
}
bal()
var vouchers = [
  "456D106BDDBAEA21807F75B965A920DCF283F9B7",
  "6DDFBA002767FF1ADED3BF3DC31AFE14F60D0AD1",
  "6CA0B1F988A7BA053D33D942B9E94C791667B873",
  "46EDEFA2A159B7C41984847508BC89E70CC94901",
  "AC3DAB39D12F755F6F73A0CECCE43DFA3BA3D42D",
  "E072483BB5B54165748C2A1959AD60602C3D6FF1",
  "39CAEF2CF912A2E55F14D1EB033C7C2367797BB6",
  "2B9B6EBA1DB2274F8C62C4F0C08C27CAD8BAAAC4",
  "B4A0BD2F14A5A67D6965AE81053B9B30CD62C567",
  "55DBB7E7D685E2C4BBFEFC685823FF248C00B8F6",
  "64345242308AEB43DCDF381413873CF66DD0E0B3",
  "EF32FB34A52D3C6499A69888B578421B04AF0192",
  "6E56B59E67BE68A417DCB01A82938E7C9EC8544B",
  "EFCB48F7A2BF87EF38EB87B3EF38F5A1F48CEAFE",
  "456C221F7C7E2A7596A81F6BA2F790B0B4090E36",
  "C3FBB2E7A6D3AAA7586C97572C3674291E81B909",
  "D87FFD7243E774A418A255FDDD84D6AF8BF679C6",
  "7753E07027C3E30D36DE8E222CD1AFAA1345D761",
  "C96CA4974860159273B1C6D2AEA24D67F7DA9FAB",
  "A4AECD1BC8CD80311F07658C9E6CD0844C01E1CB",
  "377403BE109DB75E9B9B7BFE857B6A741C763893",
  "2DF1A6B088D46565FFAC7C88DE2F4190812330A8",
  "72D6ED25C6FC05CD1A344164A8A4A5765E0E3FC3",
  "FB06C0A7E45B7B0A51374921820F8D85DA6A5EE0",
  "6C61D692DF8891819994467967A519D438F841FC",
  "EFE1B8BFAB1AB6300EAC00B0A37796F3B0195D94",
  "E7884C7CF6FA69E9A48D4B3A33B3343A6E430F78",
  "A7D58FC8B71F3BE16FCC6BE6310EEE2166B0872E",
  "1C77BE7764186F4BE5951AA0F1189438BBA35567",
  "3C27902B2384ADF60457AAC7EF693D4114C2ADD9",
  "708AC939A7AB593822143E03814F7CCC30BDDE55",
  "621428F514CB66CA99FE3005F327D3B18CEC7F87",
  "607FCCB928274941AE2587B02B4110CAB8EC483D",
  "E944ABBEB3E2D0C4EF502D16E06AFB831C2B6AFC",
  "C65534B1B14C037DB6AFFDDE125250E5519BDDFE",
  "34A4C9A07DBC63B302BDE6697E4548B1B81EC457",
  "B4E60F5E543B528BF6308737AD40555C088EBBC7",
  "3DFEB1F007AE0EBF957C387069A349E7DCD5E500",
  "530BB859BC46D10266C05A0CF348F98EC9D7C163",
  "5FB6E4B92E898A438A850702FC3C47A6124CCCC5",
  "CE2ED7E1EA5AF47372488B3DC146B16B8BB4F5DA",
  "76493A666450A64253BF1A789756474A531CC410",
  "69C7EF9395D936836DA1C19EE8B42FE86B736A35",
  "F3A7922584BB97E0F3F0019B0BEE324C0CA1AFF0",
  "E69A695DC31C223FD11F2840020C4270B90AE86F",
  "61F4D535D4C385DD00EB681720F8303A198AAB5D",
  "7964068D0C47B6C059BF5A734C17B47E0C1886BF",
  "D5C354BB3F8041F619E5163A999EFE981E0497C9",
  "BEE94EFAA84A791F226A29F40A99FAC4B24B2DA9",
  "DC9A26F2DBAAEE42250DB0C96437322EB3824339"
]
function disburse(ethamt) {
  var weiamt = web3.toWei(ethamt, "ether");
  if (eth.getBalance(ma) < weiamt*10) {
    console.log("Insufficient dev balance");
    return;
  }
  for (var i = 0; i < vouchers.length; i++) {
    eth.sendTransaction({from:ma, to:vouchers[i],value:weiamt});
  }
}
function voucherbal() {

  for (var i = 0; i < vouchers.length; i++) {
    ebal = web3.fromWei(eth.getBalance(vouchers[i]), "ether");
    console.log(vouchers[i], "->", ebal, "E");
  }
}
/*
function topup() {
  var wdiff = web3.toWei(100, "ether") - eth.getBalance(eth.accounts[0])
  if (wdiff > 0) {
    eth.sendTransaction({from:auxa, to:ma, value:wdiff})
    return true
  }
  return false
}
*/
function cc(name) {
  var compiled = web3.eth.compile.solidity(csrc)
  return compiled[name]
}

function busysleep(millis)
 {
  var date = new Date();
  var curDate = null;
  do { curDate = new Date(); }
  while(curDate-date < millis);
}

function driveDownDifficulty() {
  var iteration = 0
  var lastdiff = eth.getBlock("latest").difficulty
  while (true) {
    var thn = (new Date()).getTime()
    console.log("Iteration: ", iteration);
    iteration += 1;
    miner.start(1);
    admin.sleepBlocks(1);
    miner.stop(40);
    bh = eth.getBlock("latest")
    console.log("mined block",bh.number,"difficulty",bh.difficulty, "delta",(bh.difficulty-lastdiff));
    lastdiff = bh.difficulty;
    for (var k=0;k<300;k++) {
      if (eth.pendingTransactions == null) {
        busysleep(100);
      } else {
        break;
      }
    }

  }
}
function ass(name) {
  var x = this
  return function(v) {
    x[name] = v
  }
}
function ld(co, args, cb, codeoverride) {
  //Information from https://www.ethereum.org/greeter
  //and https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethcontract
  var contract = web3.eth.contract(co.info.abiDefinition)
  var sdf1 = web3.toWei(100, "ether") - eth.getBalance(ma)
  var decb = function(e, c) {
    if (e) {
      console.log("Contract error: ", e)
    } else {
      if (c.address) {
        var sdf2 = web3.toWei(100, "ether") - eth.getBalance(ma)
        console.log("Contract cost: ", web3.fromWei(sdf2-sdf1, "finney"), "finney")
        console.log("Artifact addr: ", c.address)
        if (cb) {
          cb(c)
        }
      }
    }
  }
  if (codeoverride == undefined) {
    codeoverride = co.code
  }
  var ac = args.concat([{from:ma, data: codeoverride, gas: 3000000, gasprice: web3.toWei(50, "shannon")}, decb])

  //var rv = contract.new(args[0], {from:ma, data: co.code, gas: 3000000}, decb)
  //var rv = contract.new(ac[0], ac[1], ac[2])
  var rv = contract.new.apply(contract, ac)
  return true
}

function ldcc(name, args, assname, cb) {
  var cn = cc(name)
  var x = this
  ld(cn, args, function(c) {
    x[assname] = c
    if (cb) {
      cb(c)
    }
  })
}

function setIvkValue(val, unit) {
  ivkvalue = web3.toWei(val, unit);
}
function ivk(fn, args, cb) {
  var sdf1 = web3.toWei(100, "ether") - eth.getBalance(ma);
  fn.sendTransaction.apply(fn, args.concat([{from:ma, value:ivkvalue, gas: 3000000, gasprice: web3.toWei(50,"shannon")},
    function(err, addr) {
      //console.log("icb")
      //console.log("trc:", addr)
      if(!err) {
        var f = eth.filter("latest")
        f.watch(function(bh) {
          var trr = eth.getTransactionReceipt(addr);
          if (trr != null) {
            var sdf2 = web3.toWei(100, "ether") - eth.getBalance(ma);
            console.log("TX cost: ", web3.fromWei(sdf2-sdf1, "finney"), "finney");
            console.log("TX in block ", trr.blockNumber);
            console.log("TX used ", trr.gasUsed, " gas");
            console.log("TX logs: ");
            for (var i = 0; i < trr.length; i++) {
              console.log(trr[i]);
            }
            f.stopWatching();
            if (cb) {
              cb();
            }
          } else {
            console.log("TX not in this block\n");
          }
        })
      } else {
        console.log("IVK ERROR: ", err);
      }
    }]));
}

var NSABI = [{
    constant: true,
    inputs: [{
        name: "",
        type: "bytes8"
    }],
    name: "db",
    outputs: [{
        name: "",
        type: "address"
    }],
    type: "function"
}, {
    constant: true,
    inputs: [],
    name: "coordinator",
    outputs: [{
        name: "",
        type: "address"
    }],
    type: "function"
}, {
    constant: true,
    inputs: [{
        name: "k",
        type: "bytes8"
    }],
    name: "get",
    outputs: [{
        name: "",
        type: "address"
    }],
    type: "function"
}, {
    constant: false,
    inputs: [{
        name: "k",
        type: "bytes8"
    }, {
        name: "v",
        type: "address"
    }],
    name: "set",
    outputs: [],
    type: "function"
}, {
    inputs: [],
    type: "constructor"
}]
var NS = eth.contract(NSABI).at("0x531fe3193c0b3e9b808772807919b3ca94ec383e")
var anEntity = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
var aDot = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
var v32 = "gggggggggggggggggggggggggggggggg"
var achain = ["gggggggggggggggggggggggggggggggg", 'hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh', 'iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii', 'jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj']
