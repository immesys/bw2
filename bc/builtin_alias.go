package bc

import (
	"fmt"
	"math/big"

	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core/types"
)

//TODO rewrite this to use UFI

//Builtin contract interfaces
const (
	AliasAddress         = "0x04a640aeb0c0af5cad4ea8705de3608ad036106c"
	AliasSigResolve      = "ea992c5d"
	AliasSigCreateShort  = "bf75fdb5"
	AliasSigSet          = "111e73ff"
	AliasCreateCost      = "1000000000000000000" //1 Ether
	DevOverridePeerCount = true
)

func (bc *blockChain) ResolveShortAlias(alias uint64) (res Bytes32, iszero bool, err error) {
	key := big.NewInt(int64(alias))
	keyarr := SliceToBytes32(common.BigToBytes(key, 256))
	res, iszero, err = bc.ResolveAlias(keyarr)
	return
}

func (bc *blockChain) ResolveAlias(key Bytes32) (res Bytes32, iszero bool, err error) {
	calldat := "0x" + AliasSigResolve + key.Hex()
	fmt.Println("Resolve calldat is ", calldat)
	rv, _, err := bc.UX().Call("", AliasAddress, "", "", "", calldat)
	if err != nil {
		return Bytes32{}, false, err
	}
	fmt.Println("Resolve Key is ", key.Hex())
	fmt.Println("Resolve RV  is ", rv)
	copy(res[:], common.FromHex(rv))
	if (res == Bytes32{}) {
		iszero = true
	}
	return
}

//CreateShortAlias creates an alias, waits (Confirmations) then locates the
//created short ID and sends it to the callback. If it times out (10 blocks)
//then and error is passed
func (bcc *bcClient) CreateShortAlias(acc int, val Bytes32, confirmed func(alias uint64, err error)) {
	if val.Zero() {
		confirmed(0, bwe.M(bwe.AliasError, "You cannot create an alias to zero"))
		return
	}
	code := AliasSigCreateShort + val.Hex()
	txhash, err := bcc.Transact(acc, AliasAddress, AliasCreateCost, "", "", code)
	if err != nil {
		confirmed(0, err)
		return
	}

	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, rcpt *types.Receipt, err error) {
			if err != nil {
				confirmed(0, err)
				return
			}
			for _, lg := range rcpt.Logs {
				if lg.Topics[2] == common.Hash(val) {
					short := common.BytesToBig(lg.Topics[1][:]).Int64()
					confirmed(uint64(short), nil)
					return
				}
			}
			confirmed(0, bwe.M(bwe.AliasError, "Contract did not create alias"))
		})
}

func (bcc *bcClient) SetAlias(acc int, key Bytes32, val Bytes32, confirmed func(err error)) {
	fmt.Printf("Doing set alias\n   acc=%d\n   key=%x\n   val=%x\n", acc, key[:], val[:])
	if val.Zero() {
		confirmed(bwe.M(bwe.AliasError, "You cannot create an alias to zero"))
		return
	}
	rval, zero, err := bcc.bc.ResolveAlias(key)
	if err != nil {
		confirmed(bwe.WrapM(bwe.AliasError, "Preresolve error: ", err))
		return
	}
	if !zero {
		if rval == val {
			confirmed(bwe.M(bwe.AliasExists, "Alias exists (with the same value)"))
		} else {
			confirmed(bwe.M(bwe.AliasExists, "Alias exists (with a different value)"))
		}
		return
	}
	code := AliasSigSet + key.Hex() + val.Hex()
	txhash, err := bcc.Transact(acc, AliasAddress, AliasCreateCost, "", "", code)
	if err != nil {
		confirmed(err)
		return
	}

	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, rcpt *types.Receipt, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			v, _, err := bcc.bc.ResolveAlias(key)
			if err != nil {
				confirmed(err)
				return
			}
			if v != val {
				confirmed(bwe.M(bwe.AliasError, "Created alias contents do not match"))
				return
			}
			confirmed(nil)
			return
		})
}
