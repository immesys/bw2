package objs

// NOTE: THIS FILE WAS PRODUCED BY THE
// MSGP CODE GENERATION TOOL (github.com/tinylib/msgp)
// DO NOT EDIT

import (
	"github.com/tinylib/msgp/msgp"
)

// DecodeMsg implements msgp.Decodable
func (z *DOTV3Content) DecodeMsg(dc *msgp.Reader) (err error) {
	var field []byte
	_ = field
	var zbzg uint32
	zbzg, err = dc.ReadMapHeader()
	if err != nil {
		return
	}
	for zbzg > 0 {
		zbzg--
		field, err = dc.ReadMapKeyPtr()
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "f":
			z.SRCVK, err = dc.ReadBytes(z.SRCVK)
			if err != nil {
				return
			}
		case "t":
			z.DSTVK, err = dc.ReadBytes(z.DSTVK)
			if err != nil {
				return
			}
		case "u":
			z.URI, err = dc.ReadBytes(z.URI)
			if err != nil {
				return
			}
		case "x":
			var zbai uint32
			zbai, err = dc.ReadArrayHeader()
			if err != nil {
				return
			}
			if cap(z.Permissions) >= int(zbai) {
				z.Permissions = (z.Permissions)[:zbai]
			} else {
				z.Permissions = make([]string, zbai)
			}
			for zxvk := range z.Permissions {
				z.Permissions[zxvk], err = dc.ReadString()
				if err != nil {
					return
				}
			}
		case "e":
			z.Expiry, err = dc.ReadInt64()
			if err != nil {
				return
			}
		case "w":
			z.Created, err = dc.ReadInt64()
			if err != nil {
				return
			}
		case "c":
			z.Contact, err = dc.ReadString()
			if err != nil {
				return
			}
		case "m":
			z.Comment, err = dc.ReadString()
			if err != nil {
				return
			}
		case "l":
			z.TTL, err = dc.ReadInt8()
			if err != nil {
				return
			}
		default:
			err = dc.Skip()
			if err != nil {
				return
			}
		}
	}
	return
}

// EncodeMsg implements msgp.Encodable
func (z *DOTV3Content) EncodeMsg(en *msgp.Writer) (err error) {
	// map header, size 9
	// write "f"
	err = en.Append(0x89, 0xa1, 0x66)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.SRCVK)
	if err != nil {
		return
	}
	// write "t"
	err = en.Append(0xa1, 0x74)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.DSTVK)
	if err != nil {
		return
	}
	// write "u"
	err = en.Append(0xa1, 0x75)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.URI)
	if err != nil {
		return
	}
	// write "x"
	err = en.Append(0xa1, 0x78)
	if err != nil {
		return err
	}
	err = en.WriteArrayHeader(uint32(len(z.Permissions)))
	if err != nil {
		return
	}
	for zxvk := range z.Permissions {
		err = en.WriteString(z.Permissions[zxvk])
		if err != nil {
			return
		}
	}
	// write "e"
	err = en.Append(0xa1, 0x65)
	if err != nil {
		return err
	}
	err = en.WriteInt64(z.Expiry)
	if err != nil {
		return
	}
	// write "w"
	err = en.Append(0xa1, 0x77)
	if err != nil {
		return err
	}
	err = en.WriteInt64(z.Created)
	if err != nil {
		return
	}
	// write "c"
	err = en.Append(0xa1, 0x63)
	if err != nil {
		return err
	}
	err = en.WriteString(z.Contact)
	if err != nil {
		return
	}
	// write "m"
	err = en.Append(0xa1, 0x6d)
	if err != nil {
		return err
	}
	err = en.WriteString(z.Comment)
	if err != nil {
		return
	}
	// write "l"
	err = en.Append(0xa1, 0x6c)
	if err != nil {
		return err
	}
	err = en.WriteInt8(z.TTL)
	if err != nil {
		return
	}
	return
}

// MarshalMsg implements msgp.Marshaler
func (z *DOTV3Content) MarshalMsg(b []byte) (o []byte, err error) {
	o = msgp.Require(b, z.Msgsize())
	// map header, size 9
	// string "f"
	o = append(o, 0x89, 0xa1, 0x66)
	o = msgp.AppendBytes(o, z.SRCVK)
	// string "t"
	o = append(o, 0xa1, 0x74)
	o = msgp.AppendBytes(o, z.DSTVK)
	// string "u"
	o = append(o, 0xa1, 0x75)
	o = msgp.AppendBytes(o, z.URI)
	// string "x"
	o = append(o, 0xa1, 0x78)
	o = msgp.AppendArrayHeader(o, uint32(len(z.Permissions)))
	for zxvk := range z.Permissions {
		o = msgp.AppendString(o, z.Permissions[zxvk])
	}
	// string "e"
	o = append(o, 0xa1, 0x65)
	o = msgp.AppendInt64(o, z.Expiry)
	// string "w"
	o = append(o, 0xa1, 0x77)
	o = msgp.AppendInt64(o, z.Created)
	// string "c"
	o = append(o, 0xa1, 0x63)
	o = msgp.AppendString(o, z.Contact)
	// string "m"
	o = append(o, 0xa1, 0x6d)
	o = msgp.AppendString(o, z.Comment)
	// string "l"
	o = append(o, 0xa1, 0x6c)
	o = msgp.AppendInt8(o, z.TTL)
	return
}

// UnmarshalMsg implements msgp.Unmarshaler
func (z *DOTV3Content) UnmarshalMsg(bts []byte) (o []byte, err error) {
	var field []byte
	_ = field
	var zcmr uint32
	zcmr, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zcmr > 0 {
		zcmr--
		field, bts, err = msgp.ReadMapKeyZC(bts)
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "f":
			z.SRCVK, bts, err = msgp.ReadBytesBytes(bts, z.SRCVK)
			if err != nil {
				return
			}
		case "t":
			z.DSTVK, bts, err = msgp.ReadBytesBytes(bts, z.DSTVK)
			if err != nil {
				return
			}
		case "u":
			z.URI, bts, err = msgp.ReadBytesBytes(bts, z.URI)
			if err != nil {
				return
			}
		case "x":
			var zajw uint32
			zajw, bts, err = msgp.ReadArrayHeaderBytes(bts)
			if err != nil {
				return
			}
			if cap(z.Permissions) >= int(zajw) {
				z.Permissions = (z.Permissions)[:zajw]
			} else {
				z.Permissions = make([]string, zajw)
			}
			for zxvk := range z.Permissions {
				z.Permissions[zxvk], bts, err = msgp.ReadStringBytes(bts)
				if err != nil {
					return
				}
			}
		case "e":
			z.Expiry, bts, err = msgp.ReadInt64Bytes(bts)
			if err != nil {
				return
			}
		case "w":
			z.Created, bts, err = msgp.ReadInt64Bytes(bts)
			if err != nil {
				return
			}
		case "c":
			z.Contact, bts, err = msgp.ReadStringBytes(bts)
			if err != nil {
				return
			}
		case "m":
			z.Comment, bts, err = msgp.ReadStringBytes(bts)
			if err != nil {
				return
			}
		case "l":
			z.TTL, bts, err = msgp.ReadInt8Bytes(bts)
			if err != nil {
				return
			}
		default:
			bts, err = msgp.Skip(bts)
			if err != nil {
				return
			}
		}
	}
	o = bts
	return
}

// Msgsize returns an upper bound estimate of the number of bytes occupied by the serialized message
func (z *DOTV3Content) Msgsize() (s int) {
	s = 1 + 2 + msgp.BytesPrefixSize + len(z.SRCVK) + 2 + msgp.BytesPrefixSize + len(z.DSTVK) + 2 + msgp.BytesPrefixSize + len(z.URI) + 2 + msgp.ArrayHeaderSize
	for zxvk := range z.Permissions {
		s += msgp.StringPrefixSize + len(z.Permissions[zxvk])
	}
	s += 2 + msgp.Int64Size + 2 + msgp.Int64Size + 2 + msgp.StringPrefixSize + len(z.Contact) + 2 + msgp.StringPrefixSize + len(z.Comment) + 2 + msgp.Int8Size
	return
}

// DecodeMsg implements msgp.Decodable
func (z *DOTV3Label) DecodeMsg(dc *msgp.Reader) (err error) {
	var field []byte
	_ = field
	var zwht uint32
	zwht, err = dc.ReadMapHeader()
	if err != nil {
		return
	}
	for zwht > 0 {
		zwht--
		field, err = dc.ReadMapKeyPtr()
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "n":
			z.Namespace, err = dc.ReadBytes(z.Namespace)
			if err != nil {
				return
			}
		case "p":
			z.Partition, err = dc.ReadBytes(z.Partition)
			if err != nil {
				return
			}
		case "s":
			z.Signature, err = dc.ReadBytes(z.Signature)
			if err != nil {
				return
			}
		default:
			err = dc.Skip()
			if err != nil {
				return
			}
		}
	}
	return
}

// EncodeMsg implements msgp.Encodable
func (z *DOTV3Label) EncodeMsg(en *msgp.Writer) (err error) {
	// map header, size 3
	// write "n"
	err = en.Append(0x83, 0xa1, 0x6e)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.Namespace)
	if err != nil {
		return
	}
	// write "p"
	err = en.Append(0xa1, 0x70)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.Partition)
	if err != nil {
		return
	}
	// write "s"
	err = en.Append(0xa1, 0x73)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.Signature)
	if err != nil {
		return
	}
	return
}

// MarshalMsg implements msgp.Marshaler
func (z *DOTV3Label) MarshalMsg(b []byte) (o []byte, err error) {
	o = msgp.Require(b, z.Msgsize())
	// map header, size 3
	// string "n"
	o = append(o, 0x83, 0xa1, 0x6e)
	o = msgp.AppendBytes(o, z.Namespace)
	// string "p"
	o = append(o, 0xa1, 0x70)
	o = msgp.AppendBytes(o, z.Partition)
	// string "s"
	o = append(o, 0xa1, 0x73)
	o = msgp.AppendBytes(o, z.Signature)
	return
}

// UnmarshalMsg implements msgp.Unmarshaler
func (z *DOTV3Label) UnmarshalMsg(bts []byte) (o []byte, err error) {
	var field []byte
	_ = field
	var zhct uint32
	zhct, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zhct > 0 {
		zhct--
		field, bts, err = msgp.ReadMapKeyZC(bts)
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "n":
			z.Namespace, bts, err = msgp.ReadBytesBytes(bts, z.Namespace)
			if err != nil {
				return
			}
		case "p":
			z.Partition, bts, err = msgp.ReadBytesBytes(bts, z.Partition)
			if err != nil {
				return
			}
		case "s":
			z.Signature, bts, err = msgp.ReadBytesBytes(bts, z.Signature)
			if err != nil {
				return
			}
		default:
			bts, err = msgp.Skip(bts)
			if err != nil {
				return
			}
		}
	}
	o = bts
	return
}

// Msgsize returns an upper bound estimate of the number of bytes occupied by the serialized message
func (z *DOTV3Label) Msgsize() (s int) {
	s = 1 + 2 + msgp.BytesPrefixSize + len(z.Namespace) + 2 + msgp.BytesPrefixSize + len(z.Partition) + 2 + msgp.BytesPrefixSize + len(z.Signature)
	return
}
