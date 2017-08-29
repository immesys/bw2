package dotv3

// NOTE: THIS FILE WAS PRODUCED BY THE
// MSGP CODE GENERATION TOOL (github.com/tinylib/msgp)
// DO NOT EDIT

import (
	"github.com/tinylib/msgp/msgp"
)

// DecodeMsg implements msgp.Decodable
func (z *DOTV3) DecodeMsg(dc *msgp.Reader) (err error) {
	var field []byte
	_ = field
	var zxvk uint32
	zxvk, err = dc.ReadMapHeader()
	if err != nil {
		return
	}
	for zxvk > 0 {
		zxvk--
		field, err = dc.ReadMapKeyPtr()
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "Content":
			if dc.IsNil() {
				err = dc.ReadNil()
				if err != nil {
					return
				}
				z.Content = nil
			} else {
				if z.Content == nil {
					z.Content = new(DOTV3Content)
				}
				err = z.Content.DecodeMsg(dc)
				if err != nil {
					return
				}
			}
		case "EncodedContent":
			z.EncodedContent, err = dc.ReadBytes(z.EncodedContent)
			if err != nil {
				return
			}
		case "Label":
			if dc.IsNil() {
				err = dc.ReadNil()
				if err != nil {
					return
				}
				z.Label = nil
			} else {
				if z.Label == nil {
					z.Label = new(DOTV3Label)
				}
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
					case "n":
						z.Label.Namespace, err = dc.ReadBytes(z.Label.Namespace)
						if err != nil {
							return
						}
					case "p":
						z.Label.Partition, err = dc.ReadBytes(z.Label.Partition)
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
			}
		case "EncodedLabel":
			z.EncodedLabel, err = dc.ReadBytes(z.EncodedLabel)
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
func (z *DOTV3) EncodeMsg(en *msgp.Writer) (err error) {
	// map header, size 4
	// write "Content"
	err = en.Append(0x84, 0xa7, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x6e, 0x74)
	if err != nil {
		return err
	}
	if z.Content == nil {
		err = en.WriteNil()
		if err != nil {
			return
		}
	} else {
		err = z.Content.EncodeMsg(en)
		if err != nil {
			return
		}
	}
	// write "EncodedContent"
	err = en.Append(0xae, 0x45, 0x6e, 0x63, 0x6f, 0x64, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x6e, 0x74)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.EncodedContent)
	if err != nil {
		return
	}
	// write "Label"
	err = en.Append(0xa5, 0x4c, 0x61, 0x62, 0x65, 0x6c)
	if err != nil {
		return err
	}
	if z.Label == nil {
		err = en.WriteNil()
		if err != nil {
			return
		}
	} else {
		// map header, size 2
		// write "n"
		err = en.Append(0x82, 0xa1, 0x6e)
		if err != nil {
			return err
		}
		err = en.WriteBytes(z.Label.Namespace)
		if err != nil {
			return
		}
		// write "p"
		err = en.Append(0xa1, 0x70)
		if err != nil {
			return err
		}
		err = en.WriteBytes(z.Label.Partition)
		if err != nil {
			return
		}
	}
	// write "EncodedLabel"
	err = en.Append(0xac, 0x45, 0x6e, 0x63, 0x6f, 0x64, 0x65, 0x64, 0x4c, 0x61, 0x62, 0x65, 0x6c)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.EncodedLabel)
	if err != nil {
		return
	}
	return
}

// MarshalMsg implements msgp.Marshaler
func (z *DOTV3) MarshalMsg(b []byte) (o []byte, err error) {
	o = msgp.Require(b, z.Msgsize())
	// map header, size 4
	// string "Content"
	o = append(o, 0x84, 0xa7, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x6e, 0x74)
	if z.Content == nil {
		o = msgp.AppendNil(o)
	} else {
		o, err = z.Content.MarshalMsg(o)
		if err != nil {
			return
		}
	}
	// string "EncodedContent"
	o = append(o, 0xae, 0x45, 0x6e, 0x63, 0x6f, 0x64, 0x65, 0x64, 0x43, 0x6f, 0x6e, 0x74, 0x65, 0x6e, 0x74)
	o = msgp.AppendBytes(o, z.EncodedContent)
	// string "Label"
	o = append(o, 0xa5, 0x4c, 0x61, 0x62, 0x65, 0x6c)
	if z.Label == nil {
		o = msgp.AppendNil(o)
	} else {
		// map header, size 2
		// string "n"
		o = append(o, 0x82, 0xa1, 0x6e)
		o = msgp.AppendBytes(o, z.Label.Namespace)
		// string "p"
		o = append(o, 0xa1, 0x70)
		o = msgp.AppendBytes(o, z.Label.Partition)
	}
	// string "EncodedLabel"
	o = append(o, 0xac, 0x45, 0x6e, 0x63, 0x6f, 0x64, 0x65, 0x64, 0x4c, 0x61, 0x62, 0x65, 0x6c)
	o = msgp.AppendBytes(o, z.EncodedLabel)
	return
}

// UnmarshalMsg implements msgp.Unmarshaler
func (z *DOTV3) UnmarshalMsg(bts []byte) (o []byte, err error) {
	var field []byte
	_ = field
	var zbai uint32
	zbai, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zbai > 0 {
		zbai--
		field, bts, err = msgp.ReadMapKeyZC(bts)
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "Content":
			if msgp.IsNil(bts) {
				bts, err = msgp.ReadNilBytes(bts)
				if err != nil {
					return
				}
				z.Content = nil
			} else {
				if z.Content == nil {
					z.Content = new(DOTV3Content)
				}
				bts, err = z.Content.UnmarshalMsg(bts)
				if err != nil {
					return
				}
			}
		case "EncodedContent":
			z.EncodedContent, bts, err = msgp.ReadBytesBytes(bts, z.EncodedContent)
			if err != nil {
				return
			}
		case "Label":
			if msgp.IsNil(bts) {
				bts, err = msgp.ReadNilBytes(bts)
				if err != nil {
					return
				}
				z.Label = nil
			} else {
				if z.Label == nil {
					z.Label = new(DOTV3Label)
				}
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
					case "n":
						z.Label.Namespace, bts, err = msgp.ReadBytesBytes(bts, z.Label.Namespace)
						if err != nil {
							return
						}
					case "p":
						z.Label.Partition, bts, err = msgp.ReadBytesBytes(bts, z.Label.Partition)
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
			}
		case "EncodedLabel":
			z.EncodedLabel, bts, err = msgp.ReadBytesBytes(bts, z.EncodedLabel)
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
func (z *DOTV3) Msgsize() (s int) {
	s = 1 + 8
	if z.Content == nil {
		s += msgp.NilSize
	} else {
		s += z.Content.Msgsize()
	}
	s += 15 + msgp.BytesPrefixSize + len(z.EncodedContent) + 6
	if z.Label == nil {
		s += msgp.NilSize
	} else {
		s += 1 + 2 + msgp.BytesPrefixSize + len(z.Label.Namespace) + 2 + msgp.BytesPrefixSize + len(z.Label.Partition)
	}
	s += 13 + msgp.BytesPrefixSize + len(z.EncodedLabel)
	return
}

// DecodeMsg implements msgp.Decodable
func (z *DOTV3Content) DecodeMsg(dc *msgp.Reader) (err error) {
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
			var zhct uint32
			zhct, err = dc.ReadArrayHeader()
			if err != nil {
				return
			}
			if cap(z.Permissions) >= int(zhct) {
				z.Permissions = (z.Permissions)[:zhct]
			} else {
				z.Permissions = make([]string, zhct)
			}
			for zajw := range z.Permissions {
				z.Permissions[zajw], err = dc.ReadString()
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
	for zajw := range z.Permissions {
		err = en.WriteString(z.Permissions[zajw])
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
	for zajw := range z.Permissions {
		o = msgp.AppendString(o, z.Permissions[zajw])
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
	var zcua uint32
	zcua, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zcua > 0 {
		zcua--
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
			var zxhx uint32
			zxhx, bts, err = msgp.ReadArrayHeaderBytes(bts)
			if err != nil {
				return
			}
			if cap(z.Permissions) >= int(zxhx) {
				z.Permissions = (z.Permissions)[:zxhx]
			} else {
				z.Permissions = make([]string, zxhx)
			}
			for zajw := range z.Permissions {
				z.Permissions[zajw], bts, err = msgp.ReadStringBytes(bts)
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
	for zajw := range z.Permissions {
		s += msgp.StringPrefixSize + len(z.Permissions[zajw])
	}
	s += 2 + msgp.Int64Size + 2 + msgp.Int64Size + 2 + msgp.StringPrefixSize + len(z.Contact) + 2 + msgp.StringPrefixSize + len(z.Comment) + 2 + msgp.Int8Size
	return
}

// DecodeMsg implements msgp.Decodable
func (z *DOTV3Label) DecodeMsg(dc *msgp.Reader) (err error) {
	var field []byte
	_ = field
	var zlqf uint32
	zlqf, err = dc.ReadMapHeader()
	if err != nil {
		return
	}
	for zlqf > 0 {
		zlqf--
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
	// map header, size 2
	// write "n"
	err = en.Append(0x82, 0xa1, 0x6e)
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
	return
}

// MarshalMsg implements msgp.Marshaler
func (z *DOTV3Label) MarshalMsg(b []byte) (o []byte, err error) {
	o = msgp.Require(b, z.Msgsize())
	// map header, size 2
	// string "n"
	o = append(o, 0x82, 0xa1, 0x6e)
	o = msgp.AppendBytes(o, z.Namespace)
	// string "p"
	o = append(o, 0xa1, 0x70)
	o = msgp.AppendBytes(o, z.Partition)
	return
}

// UnmarshalMsg implements msgp.Unmarshaler
func (z *DOTV3Label) UnmarshalMsg(bts []byte) (o []byte, err error) {
	var field []byte
	_ = field
	var zdaf uint32
	zdaf, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zdaf > 0 {
		zdaf--
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
	s = 1 + 2 + msgp.BytesPrefixSize + len(z.Namespace) + 2 + msgp.BytesPrefixSize + len(z.Partition)
	return
}

// DecodeMsg implements msgp.Decodable
func (z *WireFormat) DecodeMsg(dc *msgp.Reader) (err error) {
	var field []byte
	_ = field
	var zpks uint32
	zpks, err = dc.ReadMapHeader()
	if err != nil {
		return
	}
	for zpks > 0 {
		zpks--
		field, err = dc.ReadMapKeyPtr()
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "DOTV3Label":
			var zjfb uint32
			zjfb, err = dc.ReadMapHeader()
			if err != nil {
				return
			}
			for zjfb > 0 {
				zjfb--
				field, err = dc.ReadMapKeyPtr()
				if err != nil {
					return
				}
				switch msgp.UnsafeString(field) {
				case "n":
					z.DOTV3Label.Namespace, err = dc.ReadBytes(z.DOTV3Label.Namespace)
					if err != nil {
						return
					}
				case "p":
					z.DOTV3Label.Partition, err = dc.ReadBytes(z.DOTV3Label.Partition)
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
		case "b":
			z.Body, err = dc.ReadBytes(z.Body)
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
func (z *WireFormat) EncodeMsg(en *msgp.Writer) (err error) {
	// map header, size 2
	// write "DOTV3Label"
	// map header, size 2
	// write "n"
	err = en.Append(0x82, 0xaa, 0x44, 0x4f, 0x54, 0x56, 0x33, 0x4c, 0x61, 0x62, 0x65, 0x6c, 0x82, 0xa1, 0x6e)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.DOTV3Label.Namespace)
	if err != nil {
		return
	}
	// write "p"
	err = en.Append(0xa1, 0x70)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.DOTV3Label.Partition)
	if err != nil {
		return
	}
	// write "b"
	err = en.Append(0xa1, 0x62)
	if err != nil {
		return err
	}
	err = en.WriteBytes(z.Body)
	if err != nil {
		return
	}
	return
}

// MarshalMsg implements msgp.Marshaler
func (z *WireFormat) MarshalMsg(b []byte) (o []byte, err error) {
	o = msgp.Require(b, z.Msgsize())
	// map header, size 2
	// string "DOTV3Label"
	// map header, size 2
	// string "n"
	o = append(o, 0x82, 0xaa, 0x44, 0x4f, 0x54, 0x56, 0x33, 0x4c, 0x61, 0x62, 0x65, 0x6c, 0x82, 0xa1, 0x6e)
	o = msgp.AppendBytes(o, z.DOTV3Label.Namespace)
	// string "p"
	o = append(o, 0xa1, 0x70)
	o = msgp.AppendBytes(o, z.DOTV3Label.Partition)
	// string "b"
	o = append(o, 0xa1, 0x62)
	o = msgp.AppendBytes(o, z.Body)
	return
}

// UnmarshalMsg implements msgp.Unmarshaler
func (z *WireFormat) UnmarshalMsg(bts []byte) (o []byte, err error) {
	var field []byte
	_ = field
	var zcxo uint32
	zcxo, bts, err = msgp.ReadMapHeaderBytes(bts)
	if err != nil {
		return
	}
	for zcxo > 0 {
		zcxo--
		field, bts, err = msgp.ReadMapKeyZC(bts)
		if err != nil {
			return
		}
		switch msgp.UnsafeString(field) {
		case "DOTV3Label":
			var zeff uint32
			zeff, bts, err = msgp.ReadMapHeaderBytes(bts)
			if err != nil {
				return
			}
			for zeff > 0 {
				zeff--
				field, bts, err = msgp.ReadMapKeyZC(bts)
				if err != nil {
					return
				}
				switch msgp.UnsafeString(field) {
				case "n":
					z.DOTV3Label.Namespace, bts, err = msgp.ReadBytesBytes(bts, z.DOTV3Label.Namespace)
					if err != nil {
						return
					}
				case "p":
					z.DOTV3Label.Partition, bts, err = msgp.ReadBytesBytes(bts, z.DOTV3Label.Partition)
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
		case "b":
			z.Body, bts, err = msgp.ReadBytesBytes(bts, z.Body)
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
func (z *WireFormat) Msgsize() (s int) {
	s = 1 + 11 + 1 + 2 + msgp.BytesPrefixSize + len(z.DOTV3Label.Namespace) + 2 + msgp.BytesPrefixSize + len(z.DOTV3Label.Partition) + 2 + msgp.BytesPrefixSize + len(z.Body)
	return
}
