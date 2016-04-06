package bc

import (
	"fmt"
	"math/big"

	"github.com/immesys/bw2bc/common"
)

/*

This is the API for a 32 byte Universal Function Identifier.
The first 20 bytes are a contract address. The next 4 bytes are the
function selector. The remaining 8 bytes are broken into 16 nibbles
that contain type information for up to 15 arguments or return values
depending on how complex their types are.

//0 - break between args and return value or padding at end
//1 - uint
//2 - int
//3 - string
//4 - dynamic bytes
//5 - static bytes (pad right whereas uint pads left)
//6 - fixed, next nibble is shift
//7 - ufixed, next nibble is shift
//8 - array, next nibble is length, nibble after is type
//9-15 reserved
*/

const (
	TBreak  = 0
	TUInt   = 1
	TInt    = 2
	TString = 3
	TBytes  = 4
	TDBytes = 5
	TFixed  = 6
	TUFixed = 7
	TArray  = 8
)

/*
completely incorrect usage of the digest btw
func MakeUFI(contract common.Address, fsig string, tokens ...int) UFI {
	ufi := UFI{}
	copy(ufi[:20], contract[:])
	d := sha3.NewKeccak256()
	copy(ufi[20:24], d.Sum([]byte(fsig))[:8])
	for i, t := range tokens {
		ufi[24+i] = byte(t)
	}
	return ufi
}
*/

func StringToUFI(ufi string) UFI {
	return UFI(common.HexToHash(ufi))
}

//Bytes are in hex, strings are just strings, ints are in decimal, fixed are
//in decimal with a point. Anything past tbytes is unsupported
func EncodeABICall(ufi UFI, argvaluesi ...interface{}) (contract common.Address, data []byte, err error) {
	var fsig []byte
	var args []int
	argvalues := make([]string, len(argvaluesi))
	for idx, ifc := range argvaluesi {
		switch ifc := ifc.(type) {
		case string:
			argvalues[idx] = ifc
		case []byte:
			argvalues[idx] = common.Bytes2Hex(ifc)
		case Bytes32:
			argvalues[idx] = common.Bytes2Hex(ifc[:])
		case int64:
			argvalues[idx] = big.NewInt(ifc).Text(10)
		case *big.Int:
			argvalues[idx] = ifc.Text(10)
		default:
			panic(ifc)
		}
	}
	contract, fsig, args, _, err = DecodeUFI(ufi)
	if err != nil {
		return
	}
	data = make([]byte, 4)
	copy(data, fsig)
	num_args := len(args)
	extra := make([]byte, 0)
	endloc := num_args * 32
	for idx, arg := range args {
		switch arg {
		case TUInt:
			v := common.Big(argvalues[idx])
			v = common.U256(v)
			data = append(data, common.BigToBytes(v, 256)...)
		case TInt:
			v := common.Big(argvalues[idx])
			v = common.S256(v)
			data = append(data, common.BigToBytes(v, 256)...)
		case TString:
			offset := common.BigToBytes(big.NewInt(int64(endloc+len(extra))), 256)
			data = append(data, offset...)
			extra = append(extra, common.BigToBytes(big.NewInt(int64(len(argvalues[idx]))), 256)...)
			strPadLen := len(argvalues[idx])
			if strPadLen%32 != 0 {
				strPadLen += 32 - (strPadLen % 32)
			}
			extra = append(extra, common.RightPadBytes([]byte(argvalues[idx]), strPadLen)...)
		case TDBytes:
			offset := common.BigToBytes(big.NewInt(int64(endloc+len(extra))), 256)
			argv := common.FromHex(argvalues[idx])
			origlen := len(argv)
			if len(argv)%32 != 0 {
				argv = common.RightPadBytes(argv, len(argv)+(32-len(argv)%32))
			}
			data = append(data, offset...)
			extra = append(extra, common.BigToBytes(big.NewInt(int64(origlen)), 256)...)
			extra = append(extra, argv...)
		case TBytes:
			argv := common.FromHex(argvalues[idx])
			if len(argv) > 32 {
				argv = argv[:32]
			}
			data = append(data, common.RightPadBytes(argv, 32)...)
		default:
			panic(arg)
		}
	}
	data = append(data, extra...)
	return
}

func DecodeABIReturn(ufi UFI, data []byte) (retvalues []interface{}, err error) {
	fmt.Printf("\nABI RETURN: len=%d content=%x\n", len(data), data)
	var rets []int
	_, _, _, rets, err = DecodeUFI(ufi)
	if err != nil {
		return
	}
	if len(data) < 32*len(rets) {
		err = fmt.Errorf("Data is too short for UFI")
		return
	}
	retvalues = make([]interface{}, len(rets))
	for idx, arg := range rets {
		datv := data[idx*32 : (idx+1)*32]
		switch arg {
		case TUInt:
			i := common.BytesToBig(datv)
			i = common.U256(i)
			retvalues[idx] = i
		case TInt:
			i := common.BytesToBig(datv)
			i = common.S256(i)
			retvalues[idx] = i
		case TBytes:
			cp := make([]byte, len(datv))
			copy(cp, datv)
			retvalues[idx] = cp
		case TDBytes:
			offset := common.BytesToBig(datv).Int64()
			length := common.BytesToBig(data[offset : offset+32]).Int64()
			cp := make([]byte, length)
			copy(cp, data[offset+32:offset+32+length])
			retvalues[idx] = cp
		default:
			panic(arg)
		}
	}
	return
}

func DecodeUFI(ufi UFI) (contract common.Address, fsig []byte, args []int, rets []int, err error) {
	contract = common.BytesToAddress(ufi[:20])
	fsig = ufi[20:24]
	args = make([]int, 0, 16)
	rets = make([]int, 0, 16)
	i := 0
	//Args
	for ; i < 16; i++ {
		token := int(ufi[24+(i/2)])
		if i%2 == 0 {
			token >>= 4
		} else {
			token &= 0xF
		}
		if token == TBreak {
			break
		}
		if token > TDBytes {
			err = fmt.Errorf("Unsupported UFI token")
			return
		}
		//In future more support for arrays
		args = append(args, token)
	}
	i++
	//Rets
	for ; i < 16; i++ {
		token := int(ufi[24+(i/2)])

		if i%2 == 0 {
			token >>= 4
		} else {
			token &= 0xF
		}
		if token == TBreak {
			break
		}
		if token > TDBytes {
			err = fmt.Errorf("Unsupported UFI token %d", token)
			return
		}
		//In future more support for arrays
		rets = append(rets, token)
	}
	return
}
