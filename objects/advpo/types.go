package advpo

import (
	"errors"
	"fmt"
	"strconv"
	"strings"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
)

type SimpleMessage struct {
	From     string
	URI      string
	POs      []PayloadObject
	ROs      []objects.RoutingObject
	POErrors []error
}

func ToSimpleMessage(m *core.Message) *SimpleMessage {
	poz := make([]PayloadObject, len(m.PayloadObjects))
	poe := make([]error, len(m.PayloadObjects))
	for i, po := range m.PayloadObjects {
		poz[i], poe[i] = LoadPayloadObject(po.GetPONum(), po.GetContent())
	}
	return &SimpleMessage{
		From:     crypto.FmtKey(*m.OriginVK),
		URI:      m.Topic,
		POs:      poz,
		ROs:      m.RoutingObjects,
		POErrors: poe,
	}
}

type SimpleChain struct {
	Hash        string
	Permissions string
	URI         string
	To          string
	Content     []byte
}

// Dump a given message to the console, deconstructing it as much as possible
func (sm *SimpleMessage) Dump() {
	fmt.Printf("Message from %s on %s:\n", sm.From, sm.URI)
	for _, po := range sm.POs {
		fmt.Println(po.TextRepresentation())
	}
}

// PONumDotForm turns an integer Payload Object number into dotted quad form
func PONumDotForm(ponum int) string {
	return fmt.Sprintf("%d.%d.%d.%d", ponum>>24, (ponum>>16)&0xFF, (ponum>>8)&0xFF, ponum&0xFF)
}

// PONumFromDotForm turns a dotted quad form into an integer Payload Object number
func PONumFromDotForm(dotform string) (int, error) {
	parts := strings.Split(dotform, ".")
	if len(parts) != 4 {
		return 0, errors.New("Bad dotform")
	}
	rv := 0
	for i := 0; i < 4; i++ {
		cx, err := strconv.ParseUint(parts[i], 10, 8)
		if err != nil {
			return 0, err
		}
		rv += (int(cx)) << uint(((3 - i) * 8))
	}
	return rv, nil
}

// FromDotForm is a shortcut for PONumFromDotForm that panics
// if there is an error
func FromDotForm(dotform string) int {
	rv, err := PONumFromDotForm(dotform)
	if err != nil {
		panic(err)
	}
	return rv
}

// GetOnePODF -Get a single Payload Object of the given Dot Form
// returns nil if there are none that match
func (sm *SimpleMessage) GetOnePODF(df string) PayloadObject {
	for _, p := range sm.POs {
		if p.IsTypeDF(df) {
			return p
		}
	}
	return nil
}
