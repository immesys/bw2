package bc

import (
	"bytes"
	"fmt"
	"math/big"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
	"github.com/immesys/bw2bc/core/types"
	"github.com/immesys/bw2bc/crypto/sha3"
)

func (bcc *bcClient) CreateRoutingOffer(acc int, dr *objects.Entity, nsvk []byte,
	confirmed func(err error)) {
	//First lets find out what our nonce is
	rv, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_DRNonces), dr.GetVK())
	if err != nil {
		panic(err)
	}
	nonce := rv[0].(*big.Int)
	nonce.Add(nonce, big.NewInt(1))

	//Lets create the signature
	d := sha3.NewKeccak256()
	d.Write([]byte("OfferRouting"))
	d.Write(dr.GetVK())
	d.Write(nsvk)
	d.Write(common.BigToBytes(nonce, 256))
	hsh := d.Sum(nil)
	sig := make([]byte, 64)
	crypto.SignBlob(dr.GetSK(), dr.GetVK(), sig, hsh)

	//Then let us try create offer
	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Affinity_OfferRouting), "", "", "",
		dr.GetVK(), nsvk, nonce, sig)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	//meh we need to rewrite this function
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
			//Check to see if it all matches now:
			rvz, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_AffinityOffers),
				dr.GetVK(), nsvk)
			if err != nil {
				confirmed(err)
				return
			}
			if rvz[0].(*big.Int).Cmp(nonce) != 0 {
				confirmed(fmt.Errorf("Nonce did not match %v vs %v", nonce.Text(10), rvz[0].(*big.Int).Text(10)))
				return
			}
			confirmed(nil)
		})
}

func (bcc *bcClient) CreateSRVRecord(acc int, dr *objects.Entity, record string,
	confirmed func(err error)) {
	//First lets find out what our nonce is
	rv, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_DRNonces), dr.GetVK())
	if err != nil {
		panic(err)
	}
	nonce := rv[0].(*big.Int)
	nonce.Add(nonce, big.NewInt(1))

	//Lets create the signature
	d := sha3.NewKeccak256()
	d.Write([]byte("SetDesignatedRouterSRV"))
	d.Write(dr.GetVK())
	d.Write(common.BigToBytes(nonce, 256))
	d.Write([]byte(record))
	hsh := d.Sum(nil)
	sig := make([]byte, 64)
	crypto.SignBlob(dr.GetSK(), dr.GetVK(), sig, hsh)

	//Then let us set the record
	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Affinity_SetDesignatedRouterSRV), "", "", "",
		dr.GetVK(), nonce, []byte(record), sig)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	//meh we need to rewrite this function
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
			fmt.Println("A")
			if err != nil {
				confirmed(err)
				return
			}
			fmt.Println("B")
			//Check to see if it all matches now:
			rvz, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_DRSRV),
				dr.GetVK())
			if err != nil {
				confirmed(err)
				return
			}
			fmt.Println("C")
			if string(rvz[0].([]byte)) != record {
				fmt.Println("E")
				confirmed(fmt.Errorf("SRV record didn't match"))
				return
			} else {
				fmt.Println("D")
				fmt.Printf("record confirmed %s == %s\n", string(rvz[0].([]byte)), record)
			}
			fmt.Println("F")
			confirmed(nil)
		})
}

func (bc *blockChain) FindRoutingOffers(nsvk []byte) (drs [][]byte) {
	//func (bc *blockChain) CallOnLogsSinceInt(since int64, hexaddr string, topics [][]common.Hash, cb func(l *vm.Log) bool) {
	lgs := bc.FindLogsBetween(0, -1, UFI_Affinity_Address, [][]Bytes32{[]Bytes32{
		HexToBytes32(EventSig_Affinity_NewAffinityOffer), //sig
		Bytes32{}, //drvk
		SliceToBytes32(nsvk),
	}}, true)
	rv := [][]byte{}
	seendr := make(map[Bytes32]struct{})
	//In reverse order, check for open offers
	for i := len(lgs) - 1; i >= 0; i-- {
		drvk := lgs[i].Topics()[1]
		//if valid offer still
		rvz, err := bc.CallOffChain(StringToUFI(UFI_Affinity_AffinityOffers), drvk, nsvk)
		if err != nil || len(rvz) != 1 {
			panic(err) //not expecting here
		}
		if rvz[0].(*big.Int).Int64() != 0 {
			_, seen := seendr[drvk]
			if !seen {
				rv = append(rv, drvk[:])
				seendr[drvk] = struct{}{}
			}
		}
	}
	return rv
}

func (bc *blockChain) FindRoutingAffinities(drvk []byte) (nsvks [][]byte) {
	//func (bc *blockChain) CallOnLogsSinceInt(since int64, hexaddr string, topics [][]common.Hash, cb func(l *vm.Log) bool) {
	lgs := bc.FindLogsBetween(0, -1, UFI_Affinity_Address, [][]Bytes32{[]Bytes32{
		HexToBytes32(EventSig_Affinity_NewDesignatedRouter), //sig
		Bytes32{}, //nsvk
		SliceToBytes32(drvk),
	}}, true)
	rv := [][]byte{}
	checked := make(map[Bytes32]bool)
	//Check all of these to see if they are still current
	for _, lg := range lgs {
		nsvk := lg.Topics()[1]
		if _, ok := checked[nsvk]; ok {
			continue
		}
		resdrvk, err := bc.GetDesignatedRouterFor(nsvk[:])
		if err == nil && bytes.Equal(drvk, resdrvk) {
			rv = append(rv, nsvk[:])
		}
		checked[nsvk] = true
	}
	return rv
}

func (bcc *bcClient) AcceptRoutingOffer(acc int, ns *objects.Entity, drvk []byte, confirmed func(err error)) {
	//First lets find out what our nonce is
	fmt.Printf("ADRO ns=%s dr=%s\n", crypto.FmtKey(ns.GetVK()), crypto.FmtKey(drvk))
	rv, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_NSNonces), ns.GetVK())
	if err != nil {
		panic(err)
	}
	nonce := rv[0].(*big.Int)
	nonce.Add(nonce, big.NewInt(1))
	//Lets create the signature
	d := sha3.NewKeccak256()
	d.Write([]byte("AcceptRouting"))
	d.Write(ns.GetVK())
	d.Write(drvk)
	d.Write(common.BigToBytes(nonce, 256))
	hsh := d.Sum(nil)
	sig := make([]byte, 64)
	crypto.SignBlob(ns.GetSK(), ns.GetVK(), sig, hsh)

	//Then let us try accept offer
	txhash, err := bcc.CallOnChain(acc, StringToUFI(UFI_Affinity_AcceptRouting), "", "", "",
		ns.GetVK(), drvk, nonce, sig)
	if err != nil {
		confirmed(err)
		return
	}
	//And wait for it to confirm
	//meh we need to rewrite this function
	bcc.bc.GetTransactionDetailsInt(txhash, bcc.DefaultTimeout, bcc.DefaultConfirmations,
		nil, func(bn uint64, rcpt *types.Receipt, err error) {
			if err != nil {
				confirmed(err)
				return
			}
			//Check to see if it all matches now:
			rvz, err := bcc.bc.CallOffChain(StringToUFI(UFI_Affinity_DesignatedRouterFor),
				ns.GetVK())
			if err != nil {
				confirmed(err)
				return
			}
			if bytes.Equal(rvz[0].([]byte), drvk) {
				confirmed(nil)
			} else {
				confirmed(fmt.Errorf("Designated router record did not match"))
			}
		})
}

func (bc *blockChain) GetDesignatedRouterFor(nsvk []byte) ([]byte, error) {
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Affinity_DesignatedRouterFor), nsvk)
	if err != nil {
		return nil, err
	}
	if bytes.Equal(rvz[0].([]byte), make([]byte, 32)) {
		return nil, fmt.Errorf("Designated router not found")
	}
	return rvz[0].([]byte), nil
}

func (bc *blockChain) GetSRVRecordFor(drvk []byte) (string, error) {
	rvz, err := bc.CallOffChain(StringToUFI(UFI_Affinity_DRSRV), drvk)
	if err != nil {
		return "", err
	}
	if len(rvz[0].([]byte)) == 0 {
		return "", fmt.Errorf("SRV record not found")
	}
	//fmt.Println("srv lookup: ", string(rvz[0].([]byte)))
	return string(rvz[0].([]byte)), nil
}
