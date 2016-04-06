package main

import (
	"fmt"
	"os"
	"os/signal"
	"time"

	"github.com/immesys/bw2/bc"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2bc/common"
)

func main() {

	ent := "F53BB6287609178BE0E94E27BE1EDB2025935A67B4A8D7CFC014CED4031D74588CB7B41E9941E45D373789EB49FF2771564AC72758D65F102D667B56C29F57570208004AE683F4103E1403089C48288B5D46471400A370BA59EB084A737ECE6F6DF0E448CC78CFA207A84BDCB5F7304BB082E524254C27883970C928AD5322E070E151739D1961AD1DB7B7D7B1ABD75CE91C43940D"
	entbin := common.FromHex(ent)
	e, err := objects.NewEntity(objects.ROEntity, entbin[32:])
	if err != nil {
		panic(err)
	}
	entity := e.(*objects.Entity)
	entity.SetSK(entbin[:32])

	randEnt := objects.CreateNewEntity("", "", nil)
	chain, _ := bc.NewBlockChain("/home/immesys/w/bwvm/bw2intbc/")
	client := chain.GetClient(entity)
	/*
		_, err = chain.GetAddresses()
		if err != nil {
			panic(err)
		}*/
	_ = randEnt
	var lasttime int64
	var lastdiff uint64

	chain.CallOnNewBlocks(func(b *bc.Block) bool {
		/*fmt.Println("Entity accounts: ")
		for idx, acc := range addrs {
			_, balstr, err := chain.GetBalance(idx)
			if err != nil {
				panic(err)
			}
			if idx <= 2 {
				fmt.Printf(" %2d - %s : %s\n", idx, acc.Hex(), balstr)
			}
		}*/
		dt := b.Time - lasttime
		lasttime = b.Time
		dd := int64(b.Difficulty) - int64(lastdiff)
		lastdiff = b.Difficulty
		fmt.Printf("Got block %d +%ds  diff=%d (%+d)\n", b.Number, dt, b.Difficulty, dd)
		return false
	})
	client.SetDefaultConfirmations(1)

	//then := chain.CurrentBlock()
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, os.Interrupt)
	go func() {
		<-chain.AfterBlockAgeLT(20)
		<-time.After(2 * time.Second)
		fmt.Println("submitting")
		/*	client.CreateRoutingOffer(entity, randEnt.GetVK(), func(err error) {
			fmt.Printf("\033[61mGOT RESULT OF CRO: %+v\n\033[0m", err)
			go func() {
				//<-chain.AfterBlocks(2)
				drs := chain.FindRoutingOffers(randEnt.GetVK())
				fmt.Println("Routing offers: ")
				fmt.Printf("nsvk is %032x\n", randEnt.GetVK())
				fmt.Printf("drvk is %032x\n", entity.GetVK())
				for _, dr := range drs {
					fmt.Printf("  - Found routing offer: %x\n", dr)
				}
			}()
		})*/
//		fmt.Println("doing srv record\n")
//		client.CreateSRVRecord(0, entity, "5.6.7.8:3000", func(err error) {
//			fmt.Printf("Create serv record: %+v\n", err)
//		})

		/*	client.CreateShortAlias(bc.Bytes32{1, 2, 3, 3}, func(alias uint64, err error) {
			fmt.Printf("!!!!!!!!!!!!!!!!rv: %+v %+v\n", alias, err)
		})*/
	}()

	for {
		time.Sleep(5000 * time.Millisecond)
		peer, st, cur, max := chain.SyncProgress()
		fmt.Printf("syncprogress: %v %v %v %v - CUR %v\n", peer, st, cur, max, chain.CurrentBlock())
		select {
		case <-sig:
			time.Sleep(1 * time.Second)
			os.Exit(1)
		default:
		}
	}
}

//enode://a0310d154f0e9c478a6e5e4be7341e5a06fe2ed30ab035af09ef2d2aa61802bffc093b76effe44eb291fe081bcf7707dc17f200a1477a113eaf2f1d87c9af5d2@127.0.0.1:30303
