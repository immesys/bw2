package adapter

import "github.com/immesys/bw2/api"

type Adapter interface {
	Start(bw api.BW)
}
