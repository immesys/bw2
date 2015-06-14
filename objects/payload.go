// This file is part of BOSSWAVE.
//
// BOSSWAVE is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// BOSSWAVE is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with BOSSWAVE.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright © 2015 Michael Andersen <m.andersen@cs.berkeley.edu>

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
