package bw2

import (
	"strings"

	"github.com/immesys/bw2/internal/core"
)

// This is the main function interface for BW2. All Out Of Band providers will
// use this interface, and it is the main interface for creating GO based BW2
// applications

// BW is the primary handle for bosswave consumers
type BW struct {
	Config *core.BWConfig
	tm     *core.Terminus
}

// OpenBWContext will create a new Bosswave context and initialise the
// daemons specified in the configuration file
func OpenBWContext(config *core.BWConfig) *BW {
	if config == nil {
		config = core.LoadConfig("")
	}
	rv := &BW{Config: config, tm: core.CreateTerminus()}
	return rv
}

type BosswaveClient struct {
	bw    *BW
	cl    *core.Client
	irq   func()
	disch chan *core.MsgSubPair
}

func MatchTopic(t []string, pattern []string) bool {
	if len(t) == 0 && len(pattern) == 0 {
		return true
	}
	if len(t) == 0 || len(pattern) == 0 {
		return false
	}
	if t[0] == pattern[0] || pattern[0] == "+" {
		return MatchTopic(t[1:], pattern[1:])
	}
	if pattern[0] == "*" {
		for i := 0; i < len(t); i++ {
			if MatchTopic(t[i:], pattern[1:]) {
				return true
			}
		}
	}
	return false
}

/*
func RestrictBy(from string, by string) (string, bool) {
	fp := strings.Split(from, "/")
	bp := strings.Split(by, "/")
	var fsx, bsx int
	for fsx = 0; fsx < len(fp) && fp[fsx] != "*"; fsx++ {
	}
	for bsx = 0; bsx < len(bp) && bp[bsx] != "*"; bsx++ {
	}

	rightstar := fsx
	if bsx+1 > rightstar {
		rightstar = bsx
	}

		// //case 1
		// if fsx == len(fp) && bsx == len(bp) && len(fp) == len(bp) {
		// 	//strip +
		// 	for i := 0; i < len(fp); i++ {
		// 		if fp[i] == "+" {
		// 			fp[i] = bp[i]
		// 		} else if fp [i] != bp [i] {
		// 			fmt.Println("FAIL 79")
		// 			return "", false
		// 		}
		// 	}
		// 	return strings.join(fp, "/"), true
		// }
	//case 2
	out := make([]string, 0, len(fp)+len(bp))
	for i := 0; i < rightstar; i++ {
		if i < fsx { //there are still parts in from
			if i >= bsx {
				//No matching to grant
				out = append(out, fp[i])
			} else if fp[i] == bp[i] || fp[i] == "+" {
				out = append(out, bp[i])
			} else if bp[i] == "+" {
				out = append(out, fp[i])
			} else {
				return "", false
			}
		} else if i == len(fp) {
			//Still chars in bp, but fp is finished, and fp has no star
			return "", false
		} else { //we are transferring from bp, fp need not match
			out = append(out, bp[i])
		}
	}
	if len(bp) > bsx && len(fp) > fsx {

		out = append(out, "*")

		//now we want to transfer the longest suffix match
		if len(bp)-bsx > len(fp)-fsx {
			for i := bsx + 1; i < len(bp); i++ {
				negi := len(fp) - (len(bp) - i)
				if negi < fsx+1 && negi < len(fp) {
					out = append(out, bp[i])
				} else {
					if bp[i] == fp[negi] || fp[negi] == "+" {
						out = append(out, bp[i])
					} else if bp[i] == "+" {
						out = append(out, fp[negi])
					} else {
						return "", false
					}
				}
			}
		} else {
			for i := fsx + 1; i < len(fp); i++ {
				negi := len(bp) - (len(fp) - i)
				if negi < bsx+1 {
					out = append(out, fp[i])
				} else {
					if fp[i] == bp[negi] || fp[i] == "+" {
						out = append(out, bp[negi])
					} else if bp[i] == "+" {
						out = append(out, fp[i])
					} else {
						return "", false
					}
				}
			}
		}
	}
	return strings.Join(out, "/"), true
}
*/

func RestrictBy(from string, by string) (string, bool) {
	fp := strings.Split(from, "/")
	bp := strings.Split(by, "/")
	fout := make([]string, 0, len(fp)+len(bp))
	bout := make([]string, 0, len(fp)+len(bp))
	var fsx, bsx int
	for fsx = 0; fsx < len(fp) && fp[fsx] != "*"; fsx++ {
	}
	for bsx = 0; bsx < len(bp) && bp[bsx] != "*"; bsx++ {
	}
	fi, bi := 0, 0
	fni, bni := len(fp)-1, len(bp)-1
	emit := func() (string, bool) {
		for i := 0; i < len(bout); i++ {
			fout = append(fout, bout[len(bout)-i-1])
		}
		return strings.Join(fout, "/"), true
	}
	//phase 1
	//emit matching prefix
	for ; fi < len(fp) && bi < len(bp); fi, bi = fi+1, bi+1 {
		if fp[fi] == bp[bi] || (bp[bi] == "+" && fp[fi] != "*") {
			fout = append(fout, fp[fi])
		} else if fp[fi] == "+" && bp[bi] != "*" {
			fout = append(fout, bp[bi])
		} else {
			break
		}
	}
	//phase 2
	//emit matching suffix
	for fni >= fi && bni >= bi {
		if fp[fni] == bp[bni] || (bp[bni] == "+" && fp[fni] != "*") {
			bout = append(bout, fp[fni])
		} else if fp[fni] == "+" && bp[bni] != "*" {
			bout = append(bout, bp[bni])
		} else {
			break
		}
		fni--
		bni--
	}
	if fi == len(fp) && bi == len(bp) {
		//valid A
		return emit()
	}
	//phase 3
	//emit front
	if fi < len(fp) && fp[fi] == "*" {
		for ; bi < len(bp) && bp[bi] != "*" && bi <= bni; bi++ {
			fout = append(fout, bp[bi])
		}
	} else if bi < len(bp) && bp[bi] == "*" {
		for ; fi < len(fp) && fp[fi] != "*" && fi <= fni; fi++ {
			fout = append(fout, fp[fi])
		}
	}
	//phase 4
	//emit back
	if fni >= 0 && fp[fni] == "*" {
		for ; bni >= 0 && bp[bni] != "*" && bni >= bi; bni-- {
			bout = append(bout, bp[bni])
		}
	} else if bni >= 0 && bp[bni] == "*" {
		for ; fni >= 0 && fp[fni] != "*" && fni >= fi; fni-- {
			bout = append(bout, fp[fni])
		}
	}
	//phase 5
	//emit star if they both have it
	if fi == fni && fp[fi] == "*" && bi == bni && bp[bi] == "*" {
		fout = append(fout, "*")
		return emit()
	}
	//Remove any stars
	if fi < len(fp) && fp[fi] == "*" {
		fi++
	}
	if bi < len(bp) && bp[bi] == "*" {
		bi++
	}
	if (fi == fni+1 || fi == len(fp)) && (bi == bni+1 || bi == len(bp)) {
		return emit()
	}
	return "", false
}

/*
func RestrictBy(from string, by string) (string, bool) {
	fp := strings.Split(from, "/")
	bp := strings.Split(by, "/")
	fmt.Printf("ivk %v %v\n", fp, bp)
	var fsx, bsx int
	for fsx = 0; fsx < len(fp) && fp[fsx] != "*"; fsx++ {
	}
	for bsx = 0; bsx < len(bp) && bp[bsx] != "*"; bsx++ {
	}
	out := make([]string, 0, len(fp)+len(bp))
	fi := 0
	bi := 0
	flp := fsx > bsx
	fls := len(fp)-fsx > len(bp)-bsx
	rightstar := fsx
	if bsx > rightstar && bsx != len(bp) {
		rightstar = bsx
	}
	leftstar := fsx
	if bsx < leftstar {
		leftstar = bsx
	}
	//phase 1 before leftstar
	//check f matches b, replace +
	for i := 0; i < leftstar; i++ {
		if fp[fi] == bp[bi] || bp[bi] == "+" {
			out = append(out, fp[fi])
		} else if fp[fi] == "+" {
			out = append(out, bp[bi])
		} else {
			return "", false
		}
		fi++
		bi++
	}
	if fi == len(fp) && bi == len(bp) {
		return strings.Join(out, "/"), true
	}
	fmt.Printf("p2 %v", out)
	//phase 2 after leftstar, before rightstar
	//emit either f or b unchanged
	//this can only happen if the SP ends in star
	if flp && bsx != len(bp) {
		for ; fi < fsx; fi++ {
			out = append(out, fp[fi])
		}
	} else if fsx != len(fp) {
		for ; bi < bsx; bi++ {
			out = append(out, bp[bi])
		}
	} else {
		println("fail1")
		return "", false
	}

	if fi == len(fp) && bi == len(bp) {
		return strings.Join(out, "/"), true
	}
	if fi == len(fp) && bsx == len(bp)-1 ||
		bi == len(bp) && fsx == len(fp)-1 {
		//Trailing star on F or B, ok to emit
		return strings.Join(out, "/"), true
	}
	fmt.Printf("mid out is %v %v %v", out, fi, bi)
	//phase 3 star
	//emit a star
	if fsx != len(fp) && bsx != len(bp) {
		out = append(out, "*")
		fi++
		bi++
	}

	//phase 4 after star, before rightstar
	//emit either f or b unchanged
	if fls {
		for i := 0; i < bsx-bi; i++ {
			out = append(out, fp[fi])
			fi++
		}
	} else {
		for i := 0; i < fsx-fi; i++ {
			out = append(out, bp[bi])
			bi++
		}
	}
	//phase 5 after star, after rightstar
	//check f matches b, replace +
	for ; fi < len(fp) && bi < len(bp); fi++ {
		if fp[fi] == bp[bi] || bp[bi] == "+" {
			out = append(out, fp[fi])
		} else if fp[fi] == "+" {
			out = append(out, bp[bi])
		} else {
			println("fail2")
			return "", false
		}
		bi++
	}
	if fi == len(fp) && bi == len(bp) {
		return strings.Join(out, "/"), true
	} else {
		fmt.Printf("error %v", out, fi, bi)
		return "", false
	}
}
*/

/*
func RestrictBy(from string, by string) (string, bool) {
	fp := strings.Split(from, "/")
	bp := strings.Split(by, "/")
	fstar := false
	bstar := false
	for _, p := range fp {
		if p == "*" {
			fstar = true
		}
	}
	for _, p := range bp {
		if p == "*" {
			bstar = true
		}
	}

	if !fstar { //Simple case
		if MatchTopic(fp, bp) {
			return from, true
		} else {
			return "", false
		}
	}
	if fstar && !bstar {
		if MatchTopic(bp, fp) {
			//Strip +'s
			for i := 0; i < len(fp); i++ {
				if fp[i] == "*" {
					break
				}
				if bp[i] == "+" && fp[i] != "*" {
					bp[i] = fp[i]
				}
			}
			return strings.join(gp, "/"), true
		} else {
			return "", false
		}
	} else {
		//Complex case
		var fstarix int
		var bstarix int
		for fstarix = 0; fstarix < len(fp); fstarix++ {
			if fp[fstarix] == "*" {
				break
			}
		}
		for bstarix = 0; bstarix < len(fp); bstarix++ {
			if bp[bstarix] == "*" {
				break
			}
		}
		lbr := fstarix
		if bstarix < lbr {
			lbr = bstarix
		}
		rbr := fstarix + 1
		if bstarix+1 > rbr {
			rbr = bstarix + 1
		}

	}
}
*/
//InternalQueueChanged is a placeholder that can be passed to CreateClient

func (c *BosswaveClient) dispatch() {
	if c.irq == nil {
		//Do dispatch to the subreq's Dispatch field
		ms := c.cl.GetFront()
		for ms != nil {
			c.disch <- ms
			ms = c.cl.GetFront()
		}
	} else {
		//Delegate to client
		c.irq()
	}
}
func (bw *BW) CreateClient(queueChanged func()) *BosswaveClient {
	rv := &BosswaveClient{bw: bw, irq: queueChanged}
	rv.cl = bw.tm.CreateClient(rv.dispatch)
	if queueChanged == nil {
		rv.disch = make(chan *core.MsgSubPair, 5)
		go func() {
			for {
				ms := <-rv.disch
				ms.S.Dispatch(ms.M)
			}
		}()
	}
	return rv
}

func (c *BosswaveClient) Publish(m *core.Message) error {
	//Typically we would now send this to a security check, also message would be different
	c.cl.Publish(m)
	return nil
}

func (c *BosswaveClient) Subscribe(s *core.SubReq) bool {
	new := c.cl.Subscribe(s)
	return new == s
}
