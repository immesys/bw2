package core

import (
	"encoding/base64"

	"github.com/immesys/bw2/internal/crypto"
	"github.com/immesys/bw2/internal/store"
	"github.com/immesys/bw2/objects"
)

func makeROMessage(e *objects.Entity, ro objects.RoutingObject, uriSuffix string) *Message {
	m := Message{
		TopicSuffix:    uriSuffix,
		MVK:            e.GetVK(),
		RoutingObjects: []objects.RoutingObject{ro},
		PayloadObjects: []objects.PayloadObject{},
	}
	m.Encode(e.GetSK(), e.GetVK())
	m.Topic = base64.URLEncoding.EncodeToString(m.MVK) + "/" + m.TopicSuffix
	return &m
}

//DistributeRO will store an RO in the various
//correct places, as well as publish it on the router's
//uri. NOTE: will need to make terminus treat this uri specially
func DistributeRO(routerEntity *objects.Entity,
	ro objects.RoutingObject,
	cl *Client,
) {
	switch ro.GetRONum() {
	case objects.ROAccessDChain, objects.ROPermissionDChain:
		dc := ro.(*objects.DChain)
		if !store.ExistsDChain(dc.GetChainHash()) {
			store.PutDChain(dc)
			m := makeROMessage(routerEntity, dc,
				"$/chain/hash/"+crypto.FmtHash(dc.GetChainHash())[:43])
			cl.Persist(m)
		}
	case objects.ROAccessDOT, objects.ROPermissionDOT:
		dot := ro.(*objects.DOT)
		if !store.ExistsDOT(dot.GetHash()) {
			store.PutDOT(dot)
			m := makeROMessage(routerEntity, dot,
				"$/dot/hash/"+crypto.FmtHash(dot.GetHash())[:43])
			cl.Persist(m)
			m = makeROMessage(routerEntity, dot,
				"$/dot/fromto/"+crypto.FmtKey(dot.GetGiverVK())[:43]+"/"+
					crypto.FmtKey(dot.GetReceiverVK())[:43])
			cl.Persist(m)
		}
	case objects.ROEntity:
		ent := ro.(*objects.Entity)
		if !store.ExistsEntity(ent.GetVK()) {
			store.PutEntity(ent)
			m := makeROMessage(routerEntity, ent,
				"$/entity/vk/"+crypto.FmtHash(ent.GetVK())[:43])
			cl.Persist(m)
		}
	}
}
