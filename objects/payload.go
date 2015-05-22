package objects

type GenericPO struct {
	ponum   int
	content []byte
}

func LoadPayloadObject(ponum int, content []byte) (PayloadObject, error) {
	rv := GenericPO{ponum: ponum, content: content}
	return &rv, nil
}

func (po *GenericPO) GetPONum() int {
	return po.ponum
}

func (po *GenericPO) GetContent() []byte {
	return po.content
}
