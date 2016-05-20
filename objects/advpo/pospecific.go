package advpo

import (
	"fmt"
	"time"

	"github.com/immesys/bw2/objects"
)

type MetadataTuple struct {
	Value     string `msgpack:"val"`
	Timestamp int64  `msgpack:"ts"`
}

func (m *MetadataTuple) Time() time.Time {
	return time.Unix(0, m.Timestamp)
}

//StringPayloadObject implements 64.0.1.0/32 : String
func CreateStringPayloadObject(v string) TextPayloadObject {
	return CreateTextPayloadObject(FromDotForm("64.0.1.0"), v)
}

type MetadataPayloadObject interface {
	PayloadObject
	Value() *MetadataTuple
}
type MetadataPayloadObjectImpl struct {
	MsgPackPayloadObjectImpl
}

func LoadMetadataPayloadObject(ponum int, contents []byte) (*MetadataPayloadObjectImpl, error) {
	bpl, _ := LoadMsgPackPayloadObject(ponum, contents)
	return &MetadataPayloadObjectImpl{*bpl}, nil
}
func LoadMetadataPayloadObjectPO(ponum int, contents []byte) (PayloadObject, error) {
	return LoadMetadataPayloadObject(ponum, contents)
}
func CreateMetadataPayloadObject(tup *MetadataTuple) *MetadataPayloadObjectImpl {
	mp, _ := CreateMsgPackPayloadObject(objects.PONumSMetadata, tup)
	return &MetadataPayloadObjectImpl{*mp}
}
func (po *MetadataPayloadObjectImpl) TextRepresentation() string {
	return fmt.Sprintf("PO %s len %d (metadata) @%s:\n%s\n", PONumDotForm(po.ponum),
		len(po.contents), time.Unix(0, po.Value().Timestamp), po.Value().Value)
}
func (po *MetadataPayloadObjectImpl) Value() *MetadataTuple {
	mt := MetadataTuple{}
	po.ValueInto(&mt)
	return &mt
}
