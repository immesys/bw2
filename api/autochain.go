package api

import (
	"fmt"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/util/bwe"
)

func (c *BosswaveClient) doAutoChain(mvk []byte, suffix string, perms string, autochain bool, ppac **objects.DChain) error {
	if c.GetUs() == nil {
		return bwe.M(bwe.NoEntity, "No entity set")
	}
	ch, err := c.BuildChain(&BuildChainParams{
		To:          c.GetUs().GetVK(),
		URI:         crypto.FmtKey(mvk) + "/" + suffix,
		Status:      nil,
		Permissions: perms,
	})

	go func() {
		for _ = range ch {
		}
	}()

	if err != nil {
		fmt.Println("hit err1")
		return err
	}
	realpac := <-ch
	//even if nil
	fmt.Println("read realpac as ", realpac)
	*ppac = realpac
	return nil

	//TODO real all the chains and choose the 'best' one (include checking for stars)
}

// 	panic(bwe.C(bwe.NoEntity))
// }
// log.Info("autochaining")
// mvk, suffix := bf.loadCommonURI()
// //XTAG new chainbuilder
//
// if err != nil {
// 	panic(bwe.AsBW(err))
// }
// log.Info("blocking on chain")
// realpac := <-ch
// log.Info("built")
// if realpac == nil {
// 	panic(bwe.C(bwe.ChainBuildFailed))
// }
// //XTAG: this is preeety ugly. We should create a reverse channel to stop
// //XTAG: chain building. That would save a lot of cpu time too
// go func() {
// 	for _ = range ch {
// 	}
// }()
// return realpac
// }
