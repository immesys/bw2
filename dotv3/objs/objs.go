package objs

//go:generate msgp

type DOTV3Content struct {
	SRCVK       []byte   `msg:"f"`
	DSTVK       []byte   `msg:"t"`
	URI         []byte   `msg:"u"`
	Permissions []string `msg:"x"`
	Expiry      int64    `msg:"e"`
	Created     int64    `msg:"w"`
	Contact     string   `msg:"c"`
	Comment     string   `msg:"m"`
	TTL         int8     `msg:"l"`
}
type DOTV3Label struct {
	Namespace []byte `msg:"n"`
	//For future use. Is appended onto namespace
	Partition []byte `msg:"p"`
	Signature []byte `msg:"s"`
}
