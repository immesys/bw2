package api

import (
	"time"

	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
)

type PublishParams struct {
	MVK                []byte
	URI                string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
	PayloadObjects     []objects.PayloadObject
	Expiry             *time.Time
	ExpiryDelta        *time.Duration
}
type PublishCallback func(sm *core.StatusMessage)

func Publish(params *PublishParams, cb PublishCallback) {

}

type SubscribeParams struct {
	MVK                []byte
	URI                string
	PrimaryAccessChain *objects.DChain
	RoutingObjects     []objects.RoutingObject
}
type SubscribeInitialCallback func(sm *core.StatusMessage)
type SubscribeMessageCallback func(m *core.Message)

func Subscribe(params *SubscribeParams, actionCB SubscribeInitialCallback, messageCB SubscribeMessageCallback) {

}
