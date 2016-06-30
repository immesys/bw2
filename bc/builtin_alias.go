package bc

import (
	"math/big"

	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/eth"
)

//TODO rewrite this to use UFI

//Builtin contract interfaces
const (
	// AliasAddress        = "0x04a640aeb0c0af5cad4ea8705de3608ad036106c"
	// AliasSigResolve     = "ea992c5d"
	// AliasSigCreateShort = "bf75fdb5"
	// AliasSigSet         = "111e73ff"
	AliasCreateCost = "1000000000000000000" //1 Ether

	// UFIs for Alias
	UFI_Alias_Address = "04a640aeb0c0af5cad4ea8705de3608ad036106c"
	// DB(uint256 ) -> bytes32
	UFI_Alias_DB = "04a640aeb0c0af5cad4ea8705de3608ad036106c018b51ab1040000000000000"
	// AliasPrice() -> uint256
	UFI_Alias_AliasPrice = "04a640aeb0c0af5cad4ea8705de3608ad036106c068dd2a60100000000000000"
	// SetAlias(uint256 k, bytes32 v) ->
	UFI_Alias_SetAlias = "04a640aeb0c0af5cad4ea8705de3608ad036106c111e73ff1400000000000000"
	// LastShort() -> uint256
	UFI_Alias_LastShort = "04a640aeb0c0af5cad4ea8705de3608ad036106c11e026a50100000000000000"
	// AliasMin() -> uint256
	UFI_Alias_AliasMin = "04a640aeb0c0af5cad4ea8705de3608ad036106c8bb523ae0100000000000000"
	// CreateShortAlias(bytes32 v) ->
	UFI_Alias_CreateShortAlias = "04a640aeb0c0af5cad4ea8705de3608ad036106cbf75fdb54000000000000000"
	// AliasFor(bytes32 ) -> uint256
	UFI_Alias_AliasFor = "04a640aeb0c0af5cad4ea8705de3608ad036106cc83560ea4010000000000000"
	// Resolve(uint256 k) -> bytes32
	UFI_Alias_Resolve = "04a640aeb0c0af5cad4ea8705de3608ad036106cea992c5d1040000000000000"
	// Admin() -> address
	UFI_Alias_Admin = "04a640aeb0c0af5cad4ea8705de3608ad036106cff1b636d0?00000000000000"
	// EVENT  AliasCreated(uint256 key, bytes32 value)
	EventSig_Alias_AliasCreated = "170b239b7d2c41f8c5caacdafe7409cda0f4b5012440739feea0576a40a156eb"
)

func (bc *blockChain) ResolveShortAlias(alias uint64) (res Bytes32, iszero bool, err error) {
	key := big.NewInt(int64(alias))
	keyarr := SliceToBytes32(common.BigToBytes(key, 256))
	res, iszero, err = bc.ResolveAlias(keyarr)
	return
}

func (bc *blockChain) ResolveAlias(key Bytes32) (res Bytes32, iszero bool, err error) {
	// First check what the registry thinks of the DOTHash
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Alias_Resolve), common.Bytes2Big(key[:]))
	if err != nil || len(rvz) != 1 {
		return Bytes32{}, true, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}

	res = SliceToBytes32(rvz[0].([]byte))
	iszer := res == Bytes32{}
	return res, iszer, nil
}

//CreateShortAlias creates an alias, waits (Confirmations) then locates the
//created short ID and sends it to the callback. If it times out (10 blocks)
//then and error is passed
func (bcc *bcClient) CreateShortAlias(acc int, val Bytes32, confirmed func(alias uint64, err error)) {
	if val.Zero() {
		confirmed(0, bwe.M(bwe.AliasError, "You cannot create an alias to zero"))
		return
	}

	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Alias_CreateShortAlias), AliasCreateCost, "", "", val)
	if err != nil {
		confirmed(0, err)
		return
	}

	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, tran *eth.RPCTransaction, err error) {
			if err != nil {
				confirmed(0, err)
				return
			}
			rcpt := bcc.bc.GetTransactionReceipt(tran.Hash.Hex())
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

	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Alias_SetAlias), AliasCreateCost, "", "", key, val)
	if err != nil {
		confirmed(err)
		return
	}

	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bnum uint64, rcpt *eth.RPCTransaction, err error) {
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
