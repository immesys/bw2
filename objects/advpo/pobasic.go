package advpo

import (
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"

	_ "github.com/ugorji/go/codec"
	"gopkg.in/vmihailenco/msgpack.v2"
	"gopkg.in/yaml.v2"
)

type POConstructor struct {
	PONum       string
	Mask        int
	Constructor func(int, []byte) (PayloadObject, error)
}

//Most specialised must be first
var PayloadObjectConstructors = []POConstructor{
	{"2.0.3.1", 32, LoadMetadataPayloadObjectPO},
	{"67.0.0.0", 8, LoadYAMLPayloadObjectPO},
	{"2.0.0.0", 8, LoadMsgPackPayloadObjectPO},
	{"64.0.0.0", 4, LoadTextPayloadObjectPO},
	{"0.0.0.0", 0, LoadBasePayloadObjectPO},
}

func LoadPayloadObject(ponum int, contents []byte) (PayloadObject, error) {
	for _, c := range PayloadObjectConstructors {
		cponum, _ := PONumFromDotForm(c.PONum)
		cponum = cponum >> uint(32-c.Mask)
		if (ponum >> uint(32-c.Mask)) == cponum {
			return c.Constructor(ponum, contents)
		}
	}
	panic("Could not load PO")
}

//PayloadObject implements 0.0.0.0/0 : base
type PayloadObject interface {
	GetPONum() int
	GetPODotNum() string
	TextRepresentation() string
	GetContent() []byte
	IsTypeDF(df string) bool
	IsType(ponum, mask int) bool
}
type PayloadObjectImpl struct {
	ponum    int
	contents []byte
}

func LoadBasePayloadObject(ponum int, contents []byte) (*PayloadObjectImpl, error) {
	return &PayloadObjectImpl{ponum: ponum, contents: contents}, nil
}
func LoadBasePayloadObjectPO(ponum int, contents []byte) (PayloadObject, error) {
	return LoadBasePayloadObject(ponum, contents)
}
func CreateBasePayloadObject(ponum int, contents []byte) *PayloadObjectImpl {
	rv, _ := LoadBasePayloadObject(ponum, contents)
	return rv
}
func (po *PayloadObjectImpl) GetPONum() int {
	return po.ponum
}
func (po *PayloadObjectImpl) SetPONum(ponum int) {
	po.ponum = ponum
}
func (po *PayloadObjectImpl) GetContent() []byte {
	return po.contents
}
func (po *PayloadObjectImpl) SetContent(v []byte) {
	po.contents = v
}
func (po *PayloadObjectImpl) GetPODotNum() string {
	return fmt.Sprintf("%d.%d.%d.%d", po.ponum>>24, (po.ponum>>16)&0xFF, (po.ponum>>8)&0xFF, po.ponum&0xFF)
}
func (po *PayloadObjectImpl) TextRepresentation() string {
	return fmt.Sprintf("PO %s len %d (generic) hexdump: %s\n", PONumDotForm(po.ponum), len(po.contents), hex.Dump(po.contents))
}
func (po *PayloadObjectImpl) IsType(ponum, mask int) bool {
	return (ponum >> uint(32-mask)) == (po.ponum >> uint(32-mask))
}
func (po *PayloadObjectImpl) IsTypeDF(df string) bool {
	parts := strings.SplitN(df, "/", 2)
	var mask int
	var err error
	if len(parts) != 2 {
		mask = 32
	} else {
		mask, err = strconv.Atoi(parts[1])
		if err != nil {
			panic("malformed masked dot form")
		}
	}
	ponum := FromDotForm(parts[0])
	return po.IsType(ponum, mask)
}

//TextPayloadObject implements 64.0.0.0/4 : Human readable
type TextPayloadObject interface {
	PayloadObject
	Value() string
}
type TextPayloadObjectImpl struct {
	PayloadObjectImpl
}

func LoadTextPayloadObject(ponum int, contents []byte) (*TextPayloadObjectImpl, error) {
	bpl, _ := LoadBasePayloadObject(ponum, contents)
	return &TextPayloadObjectImpl{*bpl}, nil
}
func LoadTextPayloadObjectPO(ponum int, contents []byte) (PayloadObject, error) {
	return LoadTextPayloadObject(ponum, contents)
}
func CreateTextPayloadObject(ponum int, contents string) *TextPayloadObjectImpl {
	rv, _ := LoadTextPayloadObject(ponum, []byte(contents))
	return rv
}
func (po *TextPayloadObjectImpl) TextRepresentation() string {
	return fmt.Sprintf("PO %s len %d (human readable) contents:\n%s", PONumDotForm(po.ponum), len(po.contents), string(po.contents))
}
func (po *TextPayloadObjectImpl) Value() string {
	return string(po.contents)
}

type YAMLPayloadObject interface {
	PayloadObject
	ValueInto(v interface{}) error
}
type YAMLPayloadObjectImpl struct {
	TextPayloadObjectImpl
}

func LoadYAMLPayloadObject(ponum int, contents []byte) (*YAMLPayloadObjectImpl, error) {
	tpl, _ := LoadTextPayloadObject(ponum, contents)
	rv := YAMLPayloadObjectImpl{*tpl}
	return &rv, nil
}
func LoadYAMLPayloadObjectPO(ponum int, contents []byte) (PayloadObject, error) {
	return LoadYAMLPayloadObject(ponum, contents)
}
func CreateYAMLPayloadObject(ponum int, value interface{}) (*YAMLPayloadObjectImpl, error) {
	contents, err := yaml.Marshal(value)
	if err != nil {
		return nil, err
	}
	tpl, _ := LoadTextPayloadObject(ponum, contents)
	rv := YAMLPayloadObjectImpl{*tpl}
	return &rv, nil
}
func (po *YAMLPayloadObjectImpl) ValueInto(v interface{}) error {
	err := yaml.Unmarshal(po.contents, v)
	return err
}

type MsgPackPayloadObject interface {
	PayloadObject
	ValueInto(v interface{}) error
}
type MsgPackPayloadObjectImpl struct {
	PayloadObjectImpl
}

func LoadMsgPackPayloadObject(ponum int, contents []byte) (*MsgPackPayloadObjectImpl, error) {
	bpl, _ := LoadBasePayloadObject(ponum, contents)
	rv := MsgPackPayloadObjectImpl{*bpl}
	return &rv, nil
}
func LoadMsgPackPayloadObjectPO(ponum int, contents []byte) (PayloadObject, error) {
	return LoadMsgPackPayloadObject(ponum, contents)
}
func CreateMsgPackPayloadObject(ponum int, value interface{}) (*MsgPackPayloadObjectImpl, error) {
	buf, err := msgpack.Marshal(value)
	if err != nil {
		return nil, err
	}
	return LoadMsgPackPayloadObject(ponum, buf)
}
func (po *MsgPackPayloadObjectImpl) ValueInto(v interface{}) error {
	err := msgpack.Unmarshal(po.contents, &v)
	return err
}

func (po *MsgPackPayloadObjectImpl) TextRepresentation() string {
	var x map[string]interface{}
	e := po.ValueInto(&x)
	if e == nil {
		b, err := json.MarshalIndent(x, "", "  ")
		if err == nil {
			return fmt.Sprintf("PO %s len %d (msgpack) contents:\n%+v", PONumDotForm(po.ponum), len(po.contents), string(b))
		}
	}
	return fmt.Sprintf("PO %s len %d (msgpack) contents undecodable, hexdump:\n%s", PONumDotForm(po.ponum), len(po.contents), hex.Dump(po.contents))
}
