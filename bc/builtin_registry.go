package bc

import (
	"math/big"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/core/types"
)

const (
	StateUnknown = iota
	StateValid
	StateExpired
	StateRevoked
	StateError
)

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
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
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
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
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
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
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
	var isEntity bool
	ob, s, _ := bcc.bc.ResolveDOT(rvk.GetTarget())
	if ob != nil {
		targetufi = UFI_Registry_RevokeDOT
		if s != StateValid {
			confirmed(bwe.M(bwe.NotRevokable, "DOT is not valid in the registry"))
			return
		}
	} else {
		ob, s, _ := bcc.bc.ResolveEntity(rvk.GetTarget())
		if ob != nil {
			targetufi = UFI_Registry_RevokeEntity
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
		blob)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
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
	// First check what the registry thinks of the DOTHash
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Registry_DOTState), dothash)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
	var rverr error
	state := rvz[0].(*big.Int).Int64()
	switch state {
	case StateUnknown:
		return nil, StateUnknown, bwe.M(bwe.RegistryDOTResolutionFailed, "DOT is not in registry")
	case StateExpired:
		rverr = bwe.M(bwe.RegistryDOTInvalid, "DOT has expired")
	case StateRevoked:
		rverr = bwe.M(bwe.RegistryDOTInvalid, "DOT has been revoked")
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryDOTInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid, expired or revoked

	rvz, err = bc.CallOffChain(StringToUFI(UFI_Registry_DOTs), dothash)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
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

	//TODO we need to check entities and expiries ourself. Possibly do
	//opportunistic bounty hunting. It might be worth doing that higher
	//up where we have a cache of the objects.

	return dt, int(state), rverr
}

//Resolve an Entity from the registry. Also checks for revocations
//and expiry.
func (bc *blockChain) ResolveEntity(vk []byte) (*objects.Entity, int, error) {
	// First check what the registry thinks of the vk
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Registry_EntityState), vk)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
	var rverr error
	state := rvz[0].(*big.Int).Int64()
	switch state {
	case StateUnknown:
		return nil, StateUnknown, bwe.M(bwe.RegistryEntityResolutionFailed, "Entity is not in registry")
	case StateExpired:
		rverr = bwe.M(bwe.RegistryEntityInvalid, "Entity has expired")
	case StateRevoked:
		rverr = bwe.M(bwe.RegistryEntityInvalid, "Entity has been revoked")
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryEntityInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid, revoked or expired

	rvz, err = bc.CallOffChain(StringToUFI(UFI_Registry_Entities), vk)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
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

	//TODO we need to check entities and expiries ourself. Possibly do
	//opportunistic bounty hunting. It might be worth doing that higher
	//up where we have a cache of the objects.

	return ent, int(state), rverr
}

//Resolve a chain from the registry, Also checks for revocations
//and expiry from all the DOTs and Entities. Will error if any
//dots or entities do not resolve.
func (bc *blockChain) ResolveAccessDChain(chainhash []byte) (*objects.DChain, int, error) {
	// First check what the registry thinks of the vk
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Registry_DChainState), chainhash)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
	state := rvz[0].(*big.Int).Int64()
	var rverr error
	switch state {
	case StateUnknown:
		return nil, StateUnknown, bwe.M(bwe.RegistryChainResolutionFailed, "DChain is not in registry")
	case StateExpired:
		rverr = bwe.M(bwe.RegistryChainInvalid, "DChain has expired")
	case StateRevoked:
		rverr = bwe.M(bwe.RegistryChainInvalid, "DChain has been revoked")
	case StateValid:
		break
	default:
		return nil, StateError, bwe.M(bwe.RegistryChainInvalid, "Unknown state")
	}
	//If we got here, the state in the registry is valid

	rvz, err = bc.CallOffChain(StringToUFI(UFI_Registry_DChains), chainhash)
	if err != nil || len(rvz) != 1 {
		return nil, StateError, bwe.WrapM(bwe.UFIInvocationError, "Expected 1 rv: ", err)
	}
	blob := rvz[0].([]byte)
	if len(blob) == 0 {
		return nil, StateError, bwe.M(bwe.RegistryChainResolutionFailed, "DChain not found (but registry said it was ok!!)")
	}
	dci, err := objects.LoadRoutingObject(objects.ROAccessDChain, blob)
	if err != nil {
		return nil, StateError, bwe.WrapM(bwe.RegistryChainInvalid, "DChain Decoding failed (but registry said it was ok!!)", err)
	}
	dc := dci.(*objects.DChain) // This won't fail

	//TODO we need to check dots and entities and expiries ourself. Possibly do
	//opportunistic bounty hunting. It might be worth doing that higher
	//up where we have a cache of the objects.
	//Also that involves elaboration

	return dc, int(state), rverr
}
