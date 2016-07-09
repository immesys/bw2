package bc

import (
	"math/big"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/eth"
)

const (
	StateUnknown = iota
	StateValid
	StateExpired
	StateRevoked
	StateError
)

const RegistryLag = 5

//Publish the given entity
func (bcc *bcClient) PublishEntity(acc int, ent *objects.Entity, confirmed func(err error)) {
	blob := ent.GetContent()
	if len(blob) < 96 {
		panic(bwe.M(bwe.BadOperation, "Entity not encoded"))
	}
	ob, _, _ := bcc.bc.ResolveEntity(ent.GetVK())
	if ob != nil {
		//Entity already exists
		confirmed(nil)
		return
	}
	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Registry_AddEntity), "", "", "",
		blob)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *eth.RPCTransaction, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			//Check to see if entity state is valid
			_, _, err = bcc.bc.ResolveEntity(ent.GetVK())
			if err != nil {
				confirmed(bwe.WrapM(bwe.RegistryEntityInvalid, "Could not publish: ", err))
				return
			}
			//We are good
			confirmed(nil)
		})
}

//Publish the given DOT. The entities must be published already
func (bcc *bcClient) PublishDOT(acc int, dot *objects.DOT, confirmed func(err error)) {
	blob := dot.GetContent()
	if len(blob) < 96 {
		panic(bwe.M(bwe.BadOperation, "DOT not encoded"))
	}
	ob, _, _ := bcc.bc.ResolveDOT(dot.GetHash())
	if ob != nil {
		//DOT already exists
		confirmed(nil)
		return
	}

	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Registry_AddDOT), "", "", "",
		blob)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *eth.RPCTransaction, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			//Check to see if entity state is valid
			_, _, err = bcc.bc.ResolveDOT(dot.GetHash())
			if err != nil {
				confirmed(bwe.WrapM(bwe.RegistryDOTInvalid, "Could not publish: ", err))
				return
			}
			//We are good
			confirmed(nil)
		})
}

//Publish the given DChain. The dots and entities must be published already
func (bcc *bcClient) PublishAccessDChain(acc int, chain *objects.DChain, confirmed func(err error)) {
	blob := chain.GetContent()
	if len(blob) < 32 {
		panic(bwe.M(bwe.BadOperation, "Chain not encoded"))
	}
	ob, _, _ := bcc.bc.ResolveAccessDChain(chain.GetChainHash())
	if ob != nil {
		//Chain already exists
		confirmed(nil)
		return
	}

	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Registry_AddChain), "", "", "",
		blob)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *eth.RPCTransaction, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			//Check to see if entity state is valid
			_, _, err = bcc.bc.ResolveAccessDChain(chain.GetChainHash())
			if err != nil {
				confirmed(bwe.WrapM(bwe.RegistryChainInvalid, "Could not publish: ", err))
				return
			}
			//We are good
			confirmed(nil)
		})
}
func (bcc *bcClient) PublishRevocation(acc int, rvk *objects.Revocation, confirmed func(err error)) {
	blob := rvk.GetContent()
	if len(blob) < 128 {
		panic(bwe.M(bwe.BadOperation, "Revocation not encoded"))
	}
	var targetufi string
	var targetparam Bytes32
	var isEntity bool
	ob, s, _ := bcc.bc.ResolveDOT(rvk.GetTarget())
	if ob != nil {
		targetufi = UFI_Registry_RevokeDOT
		targetparam = SliceToBytes32(ob.GetHash())
		if s != StateValid {
			confirmed(bwe.M(bwe.NotRevokable, "DOT is not valid in the registry"))
			return
		}
	} else {
		ob, s, _ := bcc.bc.ResolveEntity(rvk.GetTarget())
		if ob != nil {
			targetufi = UFI_Registry_RevokeEntity
			targetparam = SliceToBytes32(ob.GetVK())
			if s != StateValid {
				confirmed(bwe.M(bwe.NotRevokable, "Entity is not valid in the registry"))
				return
			}
			isEntity = true
		} else {
			//This should have been caught way earlier
			confirmed(bwe.M(bwe.NotRevokable, "Could not resolve target to DOT or Entity"))
			return
		}
	}

	txhash, err := bcc.CallOnChain(acc, StringToUFI(targetufi), "", "", "",
		targetparam, blob)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *eth.RPCTransaction, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			if isEntity {
				_, s, err = bcc.bc.ResolveEntity(rvk.GetTarget())
				if s != StateRevoked {
					confirmed(bwe.WrapM(bwe.RegistryEntityInvalid, "Could not revoke: ", err))
					return
				}
			} else {
				_, s, err = bcc.bc.ResolveDOT(rvk.GetTarget())
				if s != StateRevoked {
					confirmed(bwe.WrapM(bwe.RegistryDOTInvalid, "Could not revoke: ", err))
					return
				}
			}
			//We are good
			confirmed(nil)
		})
}

//Resolve a DOT from the registry. Also checks for revocations (of the DOT)
//and expiry. Will also check for entity revocations and expiry.
//Note that if it is expired or revoked it will still return the DOT,
//so check the error not for nil
func (bc *blockChain) ResolveDOT(dothash []byte) (*objects.DOT, int, error) {
	// First check what the registry thinks of the DOTHash in the very latest block
	rvz, err := bc.CallOffSpecificChain(PendingBlock, StringToUFI(UFI_Registry_DOTs), dothash)
	if err != nil || len(rvz) != 3 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
	}
	state := rvz[1].(*big.Int).Int64()
	switch state {
	case StateUnknown:
		return nil, StateUnknown, nil
	case StateExpired:
		fallthrough
	case StateRevoked:
		fallthrough
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryDOTInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid, expired or revoked
	blob := rvz[0].([]byte)
	if len(blob) == 0 {
		return nil, StateError, bwe.M(bwe.RegistryDOTResolutionFailed, "DOT not found (but registry said it was ok!!)")
	}
	dti, err := objects.LoadRoutingObject(objects.ROAccessDOT, blob)
	if err != nil {
		return nil, StateError, bwe.WrapM(bwe.RegistryDOTInvalid, "DOT Decoding failed (but registry said it was ok!!)", err)
	}
	dt := dti.(*objects.DOT) // This won't fail
	if !dt.SigValid() {
		return nil, StateError, bwe.M(bwe.RegistryDOTInvalid, "DOT signature invalid (but registry said it was ok!!)")
	}

	if state == StateValid {
		//Ok lets see if it was still valid Lag blocks ago
		rvz, err := bc.CallOffSpecificChain(int64(bc.CurrentBlock()-RegistryLag), StringToUFI(UFI_Registry_DOTs), dothash)
		if err != nil || len(rvz) != 3 {
			return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
		}
		state = rvz[1].(*big.Int).Int64()
	}

	//TODO we need to check entities and expiries ourself. Possibly do
	//opportunistic bounty hunting. It might be worth doing that higher
	//up where we have a cache of the objects.

	return dt, int(state), nil
}

//Resolve an Entity from the registry. Also checks for revocations
//and expiry.
func (bc *blockChain) ResolveEntity(vk []byte) (*objects.Entity, int, error) {
	// First check what the registry thinks of the vk
	rvz, err := bc.CallOffSpecificChain(PendingBlock, StringToUFI(UFI_Registry_Entities), vk)
	if err != nil || len(rvz) != 3 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
	}
	state := rvz[1].(*big.Int).Int64()
	switch state {
	case StateUnknown:
		return nil, StateUnknown, nil
	case StateExpired:
		fallthrough
	case StateRevoked:
		fallthrough
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryEntityInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid, revoked or expired
	blob := rvz[0].([]byte)
	if len(blob) == 0 {
		return nil, StateError, bwe.M(bwe.RegistryEntityResolutionFailed, "Entity not found (but registry said it was ok!!)")
	}
	enti, err := objects.LoadRoutingObject(objects.ROEntity, blob)
	if err != nil {
		return nil, StateError, bwe.WrapM(bwe.RegistryEntityInvalid, "Entity Decoding failed (but registry said it was ok!!)", err)
	}
	ent := enti.(*objects.Entity) // This won't fail
	if !ent.SigValid() {
		return nil, StateError, bwe.M(bwe.RegistryEntityInvalid, "Entity signature invalid (but registry said it was ok!!)")
	}

	if state == StateValid {
		//Ok lets see if it was still valid Lag blocks ago
		rvz, err := bc.CallOffSpecificChain(int64(bc.CurrentBlock()-RegistryLag), StringToUFI(UFI_Registry_Entities), vk)
		if err != nil || len(rvz) != 3 {
			return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
		}
		state = rvz[1].(*big.Int).Int64()
	}

	return ent, int(state), nil
}

//Resolve a chain from the registry, Also checks for revocations
//and expiry from all the DOTs and Entities. Will error if any
//dots or entities do not resolve.
func (bc *blockChain) ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error) {
	// First check what the registry thinks of the vk
	rvz, err := bc.CallOffSpecificChain(PendingBlock, StringToUFI(UFI_Registry_DChains), chainhash)
	if err != nil || len(rvz) != 3 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
	}
	state := rvz[1].(*big.Int).Int64()
	switch state {
	case StateUnknown:
		return nil, StateUnknown, nil
	case StateExpired:
		fallthrough
	case StateRevoked:
		fallthrough
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryChainInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid
	blob := rvz[0].([]byte)
	if len(blob) == 0 {
		return nil, StateError, bwe.M(bwe.RegistryChainResolutionFailed, "DChain not found (but registry said it was ok!!)")
	}
	dci, err := objects.LoadRoutingObject(objects.ROAccessDChain, blob)
	if err != nil {
		return nil, StateError, bwe.WrapM(bwe.RegistryChainInvalid, "DChain Decoding failed (but registry said it was ok!!)", err)
	}
	dc := dci.(*objects.DChain) // This won't fail

	if state == StateValid {
		rvz, err := bc.CallOffSpecificChain(int64(bc.CurrentBlock()-RegistryLag), StringToUFI(UFI_Registry_DChains), chainhash)
		if err != nil || len(rvz) != 3 {
			return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 3 rv: ", err)
		}
		state = rvz[1].(*big.Int).Int64()
	}
	//TODO we need to check dots and entities and expiries ourself. Possibly do
	//opportunistic bounty hunting. It might be worth doing that higher
	//up where we have a cache of the objects.
	//Also that involves elaboration

	return dc, int(state), nil
}

func (bc *blockChain) ResolveDOTsFromVK(vk Bytes32) ([]Bytes32, error) {
	rv := []Bytes32{}
	for i := 0; ; i++ {
		rvz, err := bc.CallOffSpecificChain(int64(bc.CurrentBlock()-RegistryLag), StringToUFI(UFI_Registry_DOTFromVK), vk, i)
		if err != nil || len(rvz) != 1 {
			return nil, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
		}
		hash := SliceToBytes32(rvz[0].([]byte))
		//We know a dot hash will never be zero
		if hash.Zero() {
			return rv, nil
		}
		rv = append(rv, hash)
	}
}
