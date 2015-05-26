package objects

type GenericPO struct {
	ponum   int
	content []byte
}

func LoadPayloadObject(ponum int, content []byte) (PayloadObject, error) {
	rv := GenericPO{ponum: ponum, content: content}
	return &rv, nil
}

func CreateOpaquePayloadObject(ponum int, content []byte) (PayloadObject, error) {
	rv := GenericPO{ponum: ponum, content: content}
	return &rv, nil
}

func CreateOpaquePayloadObjectDF(dotform string, content []byte) (PayloadObject, error) {
	ponum, err := PONumFromDotForm(dotform)
	if err != nil {
		return nil, err
	}
	rv := GenericPO{ponum: ponum, content: content}
	return &rv, nil
}
func (po *GenericPO) GetPONum() int {
	return po.ponum
}

func (po *GenericPO) GetContent() []byte {
	return po.content
}
