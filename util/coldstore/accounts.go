package coldstore

import (
	"bytes"
	"crypto/ecdsa"
	"math/big"

	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
	"github.com/immesys/bw2bc/common"
	ethcrypto "github.com/immesys/bw2bc/crypto"
	"golang.org/x/crypto/sha3"
)

// GetAccountHex will get the entity's account based on its index
// it is not part of objects because it depends on bw2bc
func GetAccountHex(ro *objects.Entity, index int) (string, error) {
	if ro.GetSK() == nil || len(ro.GetSK()) != 32 {
		return "", bwe.M(bwe.BadOperation, "No signing key for account extrapolation")
	}
	seed := make([]byte, 64)
	copy(seed[0:32], ro.GetSK())
	copy(seed[32:64], common.BigToBytes(big.NewInt(int64(index)), 256))
	rand := sha3.Sum512(seed)
	reader := bytes.NewReader(rand[:])
	privateKeyECDSA, err := ecdsa.GenerateKey(ethcrypto.S256(), reader)
	if err != nil {
		panic(err)
	}
	addr := ethcrypto.PubkeyToAddress(privateKeyECDSA.PublicKey)
	return addr.Hex(), nil
}
