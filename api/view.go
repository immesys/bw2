package api

import (
	"fmt"
	"regexp"
	"sort"
	"strings"
	"sync"

	"gopkg.in/vmihailenco/msgpack.v2"

	"github.com/immesys/bw2/crypto"
	"github.com/immesys/bw2/internal/core"
	"github.com/immesys/bw2/objects"
	"github.com/immesys/bw2/objects/advpo"
	"github.com/immesys/bw2/util"
	"github.com/immesys/bw2/util/bwe"
)

type View struct {
	c         *BosswaveClient
	ex        Expression
	metastore map[string]map[string]*advpo.MetadataTuple
	ns        []string
	msmu      sync.RWMutex
	mscond    *sync.Cond
	msloaded  bool
	changecb  []func()
	matchset  []*InterfaceDescription

	subs  []*vsub
	submu sync.Mutex
}

const (
	stateNew = iota
	stateSubd
	stateEnded
	stateToRemove
)

type vsub struct {
	iface    string
	sigslot  string
	isSignal bool
	reply    func(error)
	result   func(m *core.Message)
	actual   []*vsubsub
}

// The expression tree can be used to construct a view using a simple syntax.
// some examples:
/*

If the top object is a list, all the clauses are ANDED together
or {uri:"matchpattern"}
or {uri:{$re:"regexpattern"}}
or {meta:{"key":"value"}}
or {svc:"servicename"}
or {iface:"ifacename"}
or {uri:{$or:{$re:..}}}

{rematch:<uri regex>, match:<uri pattern>, attr:{"key": <exactval>, "key":{re:"regex"}}}

*/
func _parseURI(t interface{}) (Expression, error) {
	fmt.Println("doing parseURI")
	switch t := t.(type) {
	case string:
		return MatchURI(t), nil
	case map[interface{}]interface{}:
		ipat, ok := t["$re"]
		if len(t) > 1 || !ok {
			return nil, fmt.Errorf("unexpected keys in uri filter")
		}
		pat, ok := ipat.(string)
		if !ok {
			return nil, fmt.Errorf("expected string $re pattern")
		}
		return RegexURI(pat), nil
	}
	return nil, fmt.Errorf("unexpected URI structure: %T : %#v", t, t)
}
func _parseMeta(t interface{}) (Expression, error) {
	m, ok := t.(map[string]interface{})
	if !ok {
		return nil, fmt.Errorf("unexpected meta structure")
	}
	rv := []Expression{}
	for key, value := range m {
		valueS, ok := value.(string)
		if !ok {
			return nil, fmt.Errorf("expected string")
		}
		rv = append(rv, EqMeta(key, valueS))
	}
	return And(rv...), nil
}
func _parseSvc(t interface{}) (Expression, error) {
	panic("oops")
}
func _parseIface(t interface{}) (Expression, error) {
	panic("oops")
}
func _parseGlobal(t interface{}) (Expression, error) {
	var rt map[string]interface{}
	switch t := t.(type) {
	case []interface{}:
		subex := make([]Expression, len(t))
		var err error
		for i, e := range t {
			subex[i], err = _parseGlobal(e)
			if err != nil {
				return nil, err
			}
		}
		return And(subex...), nil
	case map[interface{}]interface{}:
		rt = make(map[string]interface{})
		for ikey, el := range t {
			key, ok := ikey.(string)
			if !ok {
				return nil, fmt.Errorf("map keys must be strings")
			}
			rt[key] = el
		}
		//do not return
	case map[string]interface{}:
		rt = t
		//do not return
	default:
		return nil, fmt.Errorf("invalid expression structure: %T : %#v", t, t)
	}
	rv := []Expression{}
	for key, el := range rt {
		fmt.Println("XTAGSUBEX: ", key, el)
		switch key {
		case "ns":
			slc, ok := el.([]interface{})
			if !ok {
				return nil, fmt.Errorf("operand to 'ns' must be array of strings")
			}
			sslc := []string{}
			for _, se := range slc {
				s, ok := se.(string)
				if !ok {
					return nil, fmt.Errorf("operand to 'ns' must be array of strings")
				}
				sslc = append(sslc, s)
			}
			rv = append(rv, Namespace(sslc...))
		case "uri":
			subex, err := _parseURI(el)
			if err != nil {
				return nil, err
			}
			rv = append(rv, subex)
		case "meta":
			subex, err := _parseMeta(el)
			if err != nil {
				return nil, err
			}
			rv = append(rv, subex)
		case "svc":
			subex, err := _parseSvc(el)
			if err != nil {
				return nil, err
			}
			rv = append(rv, subex)
		case "iface":
			subex, err := _parseIface(el)
			if err != nil {
				return nil, err
			}
			rv = append(rv, subex)
		case "$and":
			sl, ok := el.([]interface{})
			if !ok {
				return nil, fmt.Errorf("operand to $and must be array")
			}
			subex := make([]Expression, len(sl))
			var err error
			for i, e := range sl {
				subex[i], err = _parseGlobal(e)
				if err != nil {
					return nil, err
				}
			}
			rv = append(rv, And(subex...))
		case "$or":
			sl, ok := el.([]interface{})
			if !ok {
				return nil, fmt.Errorf("operand to $or must be array")
			}
			subex := make([]Expression, len(sl))
			var err error
			for i, e := range sl {
				subex[i], err = _parseGlobal(e)
				if err != nil {
					return nil, err
				}
			}
			rv = append(rv, Or(subex...))
		default:
			return nil, fmt.Errorf("unexpected key at this scope: '%s'", key)
		}
	}
	return And(rv...), nil

}
func ExpressionFromTree(t interface{}) (Expression, error) {
	return _parseGlobal(t)
}

type nsExpression struct {
	nsz     []string
	realnsz []string
}

func Namespace(nsz ...string) Expression {
	return &nsExpression{nsz: nsz, realnsz: nil}
}
func (n *nsExpression) checkReal(v *View) error {
	if n.realnsz != nil {
		return nil
	}
	for _, e := range n.nsz {
		rebin, err := v.c.BW().ResolveKey(e)
		if err != nil {
			return err
		}
		n.realnsz = append(n.realnsz, crypto.FmtKey(rebin))
	}
	return nil
}
func (n *nsExpression) Namespaces() []string {
	return n.nsz
}
func (n *nsExpression) Matches(uri string, v *View) bool {
	err := n.checkReal(v)
	if err != nil {
		v.fatal(err)
	}
	ns := strings.Split(uri, "/")[0]
	for _, e := range n.realnsz {
		if e == ns {
			return true
		}
	}
	return false
}
func (n *nsExpression) CanonicalSuffixes() []string {
	return []string{"*"}
}
func (n *nsExpression) MightMatch(uri string, v *View) bool {
	return true //TODO
}

// Get the given key for the given fully qualified URI (including ns)
func (v *View) Meta(ruri, key string) (*advpo.MetadataTuple, bool) {
	//TODO going forward, when metadata sub is driven by canonical
	//uri's, it makes sense to check if our canonical uris
	//are sufficient to answer this query

	//This will check uri, and parents (meta is inherited)
	uri, err := v.c.BW().ResolveURI(ruri)
	if err != nil {
		v.fatal(err)
		return nil, false
	}
	parts := strings.Split(uri, "/")
	var val *advpo.MetadataTuple = nil
	set := false
	v.msmu.RLock()
	for i := 1; i <= len(parts); i++ {
		uri := strings.Join(parts[:i], "/")
		m1, ok := v.metastore[uri]
		if ok {
			v, subok := m1[key]
			if subok {
				val = v
				set = true
			}
		}
	}
	v.msmu.RUnlock()
	return val, set
}

// Get all the metadata for the given fully qualified URI (including ns)
func (v *View) AllMeta(ruri string) map[string]*advpo.MetadataTuple {
	uri, err := v.c.BW().ResolveURI(ruri)
	if err != nil {
		v.fatal(err)
		return nil
	}
	parts := strings.Split(uri, "/")
	rv := make(map[string]*advpo.MetadataTuple)
	v.msmu.RLock()
	for i := 1; i <= len(parts); i++ {
		uri := strings.Join(parts[:i], "/")
		m1, ok := v.metastore[uri]
		if ok {
			for kk, vv := range m1 {
				rv[kk] = vv
			}
		}
	}
	v.msmu.RUnlock()
	return rv
}

/*
  (a or b) and (c or d)
*/
func foldAndCanonicalSuffixes(lhs []string, rhsz ...[]string) []string {
	if len(rhsz) == 0 {
		return lhs
	}

	rhs := rhsz[0]
	retv := []string{}
	for _, lv := range lhs {
		for _, rv := range rhs {
			res, ok := util.RestrictBy(lv, rv)
			if ok {
				retv = append(retv, res)
			}
		}
	}
	//Now we need to dedup RV
	// if A restrictBy B == A, then A is redundant and B is superior
	//                   == B, then B is redundant and A is superior
	//  is not equal to either, then both are relevant
	dedup := []string{}
	for out := 0; out < len(retv); out++ {
		for in := 0; in < len(retv); in++ {
			if in == out {
				continue
			}
			res, ok := util.RestrictBy(retv[out], retv[in])
			if ok {
				if res == retv[out] && retv[out] != retv[in] {
					//out is redundant to in, and they are not identical
					//do not add out, as we will add in later
					goto nextOut
				}
				if retv[out] == retv[in] {
					//they are identical (and reduandant) so only add
					//out if it is less than in
					if out > in {
						goto nextOut
					}
				}
			}
		}
		dedup = append(dedup, retv[out])
	nextOut:
	}
	return foldAndCanonicalSuffixes(dedup, rhsz[1:]...)
}

func (e *andExpression) CanonicalSuffixes() []string {
	retv := [][]string{}
	for _, s := range e.subex {
		retv = append(retv, s.CanonicalSuffixes())
	}
	return foldAndCanonicalSuffixes(retv[0], retv[1:]...)
}

type orExpression struct {
	subex []Expression
}

func (e *orExpression) Matches(uri string, v *View) bool {
	for _, s := range e.subex {
		if s.Matches(uri, v) {
			fmt.Printf("orex(%s) -> true\n", uri)
			return true
		}
	}
	fmt.Printf("orex(%s) -> false\n", uri)
	return false
}
func (e *orExpression) MightMatch(uri string, v *View) bool {
	for _, s := range e.subex {
		if s.MightMatch(uri, v) {
			return true
		}
	}
	return false
}
func (e *orExpression) CanonicalSuffixes() []string {
	retv := []string{}
	for _, s := range e.subex {
		retv = append(retv, s.CanonicalSuffixes()...)
	}
	return retv
}
func (e *orExpression) Namespaces() []string {
	sslcs := []string{}
	for _, s := range e.subex {
		sslcs = append(sslcs, s.Namespaces()...)
	}
	return sslcs
}

type metaEqExpression struct {
	key   string
	val   string
	regex bool
}

func (e *metaEqExpression) Matches(uri string, v *View) bool {
	val, ok := v.Meta(uri, e.key)
	if !ok {
		return false
	}
	if e.regex {
		panic("have not done regex yet")
	} else {
		fmt.Println("returning meta match: ", val.Value == e.val)
		return val.Value == e.val
	}
}
func (e *metaEqExpression) MightMatch(uri string, v *View) bool {
	//You don't know until the final resource
	return true
}
func (e *metaEqExpression) CanonicalSuffixes() []string {
	return []string{"*"}
}
func (e *metaEqExpression) Namespaces() []string {
	return []string{}
}

type uriEqExpression struct {
	pattern string
	regex   bool
	ns      *string
}

func (e *uriEqExpression) Namespaces() []string {
	if e.ns == nil {
		return []string{}
	} else {
		return []string{*e.ns}
	}
}
func (e *uriEqExpression) Matches(uri string, v *View) bool {
	if e.regex {
		rv := regexp.MustCompile(e.pattern).MatchString(uri)
		fmt.Printf("urieq(%s/%s) -> %v\n", uri, e.pattern, rv)
		return rv
	} else {
		panic("have not done thing yet")
	}
}
func (e *uriEqExpression) MightMatch(uri string, v *View) bool {
	if e.regex {
		//I'm sure we can change this in future, but it is hard
		return true
	} else {
		rhs := strings.Split(uri, "/")
		lhs := strings.Split(e.pattern, "/")
		//First check if NS matches (if present)
		if lhs[0] != "" {
			if rhs[0] != lhs[0] {
				return false
			}
		}
		li := 1
		ri := 1
		for li < len(lhs) && ri < len(rhs) {
			if lhs[li] == "*" {
				//Can arbitrarily expand
				return true
			}
			if lhs[li] == "+" ||
				lhs[li] == rhs[li] {
				li++
				ri++
				continue
			}
			return false
		}
		//either lhs or rhs is finished
		if li == len(lhs) {
			//Won't match, no more room in lhs pattern
			return false
		}
		//but if rhs finished we don't know
		return true
	}
}
func (e *uriEqExpression) CanonicalSuffixes() []string {
	if e.regex {
		return []string{"*"}
	}
	return []string{e.pattern}
}

func And(terms ...Expression) Expression {
	return &andExpression{subex: terms}
}
func Or(terms ...Expression) Expression {
	return &orExpression{subex: terms}
}
func EqMeta(key, value string) Expression {
	return &metaEqExpression{key: key, val: value, regex: false}
}
func RegexURI(pattern string) Expression {
	return &uriEqExpression{pattern: pattern, regex: true}
}

//If the URI does not begin with a slash it is considered a full
//uri. If it begins with a slash it has an implicit namespace filled
//in with the namespaces from NewView
func MatchURI(pattern string) Expression {
	var ns *string
	if pattern[0] != '/' {
		s := strings.Split(pattern, "/")[0]
		ns = &s
	} else {
		ns = nil
	}
	return &uriEqExpression{pattern: pattern, ns: ns, regex: false}
}
func Prefix(pattern string) Expression {
	if pattern[len(pattern)-1] != '/' {
		pattern = pattern + "/"
	}
	return MatchURI(pattern + "*")
}

// func Service(name string) Expression {
// 	//uri is .../service/selector/interface/sigslot/endpoint
// 	return MatchURI(fmt.Sprintf("/*/%s/+/+/+/+", name))
// }
// func Interface(name string) Expression {
// 	return RegexURI("^.*/" + name + "$")
// }
func (c *BosswaveClient) NewViewFromBlob(onready func(error, int), blob []byte) {
	var v map[string]interface{}
	err := msgpack.Unmarshal(blob, &v)
	if err != nil {
		onready(err, -1)
		return
	}
	ex, err := ExpressionFromTree(v)
	if err != nil {
		onready(err, -1)
		return
	}
	c.NewView(onready, ex)
}

func (c *BosswaveClient) NewView(onready func(error, int), exz ...Expression) {
	ex := And(exz...)
	nsmap := make(map[string]struct{})
	for _, i := range ex.Namespaces() {
		parts := strings.Split(i, "/")
		nsmap[parts[0]] = struct{}{}
	}
	ns := make([]string, 0, len(nsmap))
	for k, _ := range nsmap {
		ns = append(ns, k)
	}
	rv := &View{
		c:         c,
		ex:        ex,
		metastore: make(map[string]map[string]*advpo.MetadataTuple),
		ns:        ns,
	}
	rv.initMetaView()
	seq := c.registerView(rv)
	go func() {
		rv.waitForMetaView()
		onready(nil, seq)
	}()
}

func (c *BosswaveClient) LookupView(handle int) *View {
	c.viewmu.Lock()
	defer c.viewmu.Unlock()
	v, ok := c.views[handle]
	if ok {
		return v
	}
	return nil
}

func (v *View) waitForMetaView() {
	v.msmu.Lock()
	for !v.msloaded {
		v.mscond.Wait()
	}
	v.msmu.Unlock()
}
/*
func (v *View) checkChange() {
	newIfaceList := v.interfacesImpl()

	changed := false
	if len(newIfaceList) != len(v.matchset) {
		changed = true
	}
	if !changed {
		//serious test
		for idx := range newIfaceList {
			if !v.matchset[idx].Equals(newIfaceList[idx]) {
				changed = true
				break
			}
		}
	}

	if changed {
		//TODO update subs
		v.matchset = newIfaceList
		v.msmu.RLock()
		for _, cb := range v.changecb {
			go cb()
		}
		v.msmu.RUnlock()
	}
}
*/
func (v *View) TearDown() {
	//Release all the assets here
}
func (v *View) fatal(err error) {
	//Sometimes an error can happen deep inside a goroutine, this aborts the view
	//and notifies the client
	panic(err)
}

func (v *View) initMetaView() {
	v.mscond = sync.NewCond(&v.msmu)
	procChange := func(m *core.Message) {
		fmt.Println("doing procchange")
		if m == nil {
			return //we use this for queries too, so we don't know it means
			//end of subscription.
			//v.fatal(fmt.Errorf("subscription ended in view"))
		}
		groups := regexp.MustCompile("^(.*)/!meta/([^/]*)$").FindStringSubmatch(m.Topic)
		if groups == nil {
			fmt.Println("mt is: ", *m.MergedTopic)
			panic("bad re match")
		}
		uri := groups[1]
		key := groups[2]
		v.msmu.Lock()
		map1, ok := v.metastore[uri]
		if !ok {
			map1 = make(map[string]*advpo.MetadataTuple)
			v.metastore[uri] = map1
		}
		var poi advpo.MetadataPayloadObject //sm.GetOnePODF(bw2bind.PODFSMetadata)
		for _, po := range m.PayloadObjects {
			if po.GetPONum() == objects.PONumSMetadata {
				var err error
				poi, err = advpo.LoadMetadataPayloadObject(po.GetPONum(), po.GetContent())
				if err != nil {
					continue
				}
			}
		}
		if poi != nil {
			map1[key] = poi.Value()
		} else {
			delete(map1, key)
		}
		v.msmu.Unlock()
		//v.checkChange()
	}
	go func() {
		//First subscribe and wait for that to finish
		wg := sync.WaitGroup{}
		wg.Add(len(v.ns))
		for _, n := range v.ns {
			fmt.Println("sub is on", n+"/*/!meta/+")
			mvk, err := v.c.bw.ResolveKey(n)
			if err != nil {
				v.fatal(err)
				return
			}
			v.c.Subscribe(&SubscribeParams{
				MVK:          mvk,
				URISuffix:    "*/!meta/+",
				ElaboratePAC: PartialElaboration,
				DoVerify:     true,
				AutoChain:    true,
			}, func(err error, id core.UniqueMessageID) {
				wg.Done()
				if err != nil {
					v.fatal(err)
				}
			}, procChange)
		}
		wg.Wait()
		wg = sync.WaitGroup{}
		wg.Add(len(v.ns))
		//Then we query
		for _, n := range v.ns {
			mvk, err := v.c.bw.ResolveKey(n)
			if err != nil {
				v.fatal(err)
				return
			}
			v.c.Query(&QueryParams{
				MVK:          mvk,
				URISuffix:    "*/!meta/+",
				ElaboratePAC: PartialElaboration,
				DoVerify:     true,
				AutoChain:    true,
			}, func(err error) {
				if err != nil {
					v.fatal(err)
				}
			}, func(m *core.Message) {
				if m != nil {
					procChange(m)
				} else {
					wg.Done()
				}
			})
		}
		wg.Wait()

		//Then we mark store as populated
		v.msmu.Lock()
		v.msloaded = true
		v.msmu.Unlock()
		v.mscond.Broadcast()
	}()
}

func (v *View) SubscribeInterface(iface, sigslot string, isSignal bool, reply func(error), result func(m *core.Message)) {
	s := &vsub{iface: iface, sigslot: sigslot, isSignal: isSignal, reply: reply, result: result}
	v.submu.Lock()
	v.subs = append(v.subs, s)
	v.submu.Unlock()
}

func (v *View) checkSubs() {
	// wrapres := func(s *vsub) func(m *core.Message) {
	// 	return func(m *core.Message) {
	// 		s.result(m)
	// 		if m == nil {
	// 			s.state = stateEnded
	// 			go v.checkSubs()
	// 		}
	// 	}
	// }
	v.submu.Lock()
	for _, s := range v.subs {
		newVss := v.expandSub(s)
		intersection := make(map[*InterfaceDescription]bool)
		tosub := []*InterfaceDescription{}
		toremove := []*vsubsub{}
		//check for new
		for _, id := range newVss {
			//Checking new iterface 'id'
			foundInExisting := false
			for _, oid := range s.actual {
				if oid.id.URI == id.URI {
					foundInExisting = true
					intersection[oid.id] = true
					break
				}
			}
			if !foundInExisting {
				//this is a new iface
				tosub = append(tosub, id)
			}
		}
		//Check for missing
		for _, oid := range s.actual {
			//Skip over entries that we know are in the intersection
			_, donealready := intersection[oid.id]
			if donealready {
				continue
			}
			//Ok this is a sub that needs to be removed
			toremove = append(toremove, oid)
		}

		//for _, vss := range v.newIn(s, newVss) {
			// Handle additional subsubs (sub)
		//}
		//for _, vss := range v.missingIn(s, newVss) {
			// handle removed subsubs (unsub)
		//}
		// switch s.state {
		// case stateNew:
		// 	v.subscribeInterfaceImpl(s.iface, s.sigslot, s.isSignal, s.reply, wrapres(s))
		// case stateEnded:
		// 	//do nothing for now?
		// case stateSubd:
		// case stateToRemove:
		// 	v.unsub(s)
		// }
	}
	v.submu.Unlock()
}

//In the sub 's', we have seen a change, and there are now
//nvss matching interfaces. For every new interface in nvss
//that is not in s.actual, initiate a subscription, and
//populate actual with the new result. submu is held while
//this is called
func (v *View) newIn(s *vsub, nvss []*InterfaceDescription) {

}

//In the sub 's', we have seen a change, and there are now
//nvss matching interfaces. For every MISSING interface in nvss
//that is in s.actual, unsubscribe. The entry in actual will be
//changed automatically when the unsub nil msg comes through
//populate actual with the new result. submu is held while
//this is called
func (v *View) missingIn(s *vsub, nvss []*InterfaceDescription) {

}
func (v *View) unsub(s *vsub) {

}

type vsubsub struct {
	id    *InterfaceDescription
	state int
}

func (v *View) expandSub(s *vsub) []*InterfaceDescription {
	todo := []*InterfaceDescription{}
	for _, viewiface := range v.matchset {
		if viewiface.Interface == s.iface {
			todo = append(todo, viewiface)
		}
	}
	return todo
}
func (v *View) subscribeInterfaceImpl(iface, sigslot string, isSignal bool, reply func(error), result func(m *core.Message)) {
	idz := v.Interfaces()
	fmt.Println("we found ", len(idz), "interfaces")
	fmt.Println(idz)
	pfx := "/slot/"
	if isSignal {
		pfx = "/signal/"
	}
	wg := sync.WaitGroup{}
	todo := []*InterfaceDescription{}
	for _, viewiface := range idz {
		if viewiface.Interface == iface {
			todo = append(todo, viewiface)
			wg.Add(1)
		}
	}
	errc := make(chan error, len(todo)+1)
	msgc := make(chan *core.Message, 50)
	for _, viewiface := range todo {
		fmt.Println("doing the actual subscribe")
		parts := strings.SplitN(viewiface.URI, "/", 2)
		mvk, err := v.c.BW().ResolveKey(parts[0])
		if err != nil {
			reply(err)
			return
		}
		suffix := parts[1] + pfx + sigslot
		fmt.Println("suffix is; ", suffix)
		v.c.Subscribe(&SubscribeParams{
			MVK:          mvk,
			URISuffix:    suffix,
			ElaboratePAC: PartialElaboration,
			AutoChain:    true,
		}, func(e error, id core.UniqueMessageID) {
			if e != nil {
				errc <- e
				panic(fmt.Sprintf("%#v %#v %#v", e, crypto.FmtKey(mvk), suffix))
			}
			wg.Done()
		}, func(m *core.Message) {
			if m != nil {
				msgc <- m
			}
		})
	}
	go func() {
		fmt.Println("============ BEGINNING WG WAIT ==============")
		wg.Wait()
		fmt.Println("============ END WG WAIT ==============")
		var e error
		select {
		case e = <-errc:
		default:
		}
		if e != nil {
			reply(bwe.WrapM(bwe.ViewError, "Could not subscribe", e))
		} else {
			reply(nil)
		}
		//Serialize so that reply occurs before results
		fmt.Println("============ BEGINNING MSG READ ==============")
		for m := range msgc {
			fmt.Println("=====GOT RES")
			result(m)
		}
	}()
}
func (v *View) PublishInterface(iface, sigslot string, isSignal bool, poz []objects.PayloadObject, cb func(error)) {
	idz := v.Interfaces()
	fmt.Println("we found ", len(idz), "interfaces")
	fmt.Println(idz)
	pfx := "/slot/"
	if isSignal {
		pfx = "/signal/"
	}
	wg := sync.WaitGroup{}
	todo := []*InterfaceDescription{}
	for _, viewiface := range idz {
		if viewiface.Interface == iface {
			todo = append(todo, viewiface)
			wg.Add(1)
		}
	}
	errc := make(chan error, len(todo)+1)
	for _, viewiface := range todo {
		fmt.Println("doing the actual publish")
		parts := strings.SplitN(viewiface.URI, "/", 2)
		mvk, err := v.c.BW().ResolveKey(parts[0])
		if err != nil {
			cb(err)
			return
		}
		suffix := parts[1] + pfx + sigslot
		fmt.Println("suffix is; ", suffix)
		v.c.Publish(&PublishParams{
			MVK:            mvk,
			URISuffix:      suffix,
			AutoChain:      true,
			ElaboratePAC:   PartialElaboration,
			PayloadObjects: poz,
		}, func(e error) {
			if e != nil {
				errc <- e
			}
			wg.Done()
		})
	}
	go func() {
		wg.Wait()
		e := <-errc
		if e != nil {
			cb(bwe.WrapM(bwe.ViewError, "Could not publish", e))
		} else {
			cb(nil)
		}
	}()
}

func (v *View) Interfaces() []*InterfaceDescription {
	return v.matchset
}

func (v *View) interfacesImpl() []*InterfaceDescription {
	fmt.Printf("the view ex is: %#v\n", v.ex)
	v.msmu.RLock()
	found := make(map[string]InterfaceDescription)
	for uri, _ := range v.metastore {
		fmt.Println("checking ", uri)
		if v.ex.Matches(uri, v) {
			fmt.Println("passed first check")
			pat := `^(([^/]+)(/.*)?/(s\.[^/]+)/([^/]+)/(i\.[^/]+)).*$`
			//"^((([^/]+)/(.*)/(s\\.[^/]+)/+)/(i\\.[^/]+)).*$"
			groups := regexp.MustCompile(pat).FindStringSubmatch(uri)
			if groups != nil {
				id := InterfaceDescription{
					URI:       groups[1],
					Interface: groups[6],
					Service:   groups[4],
					Namespace: groups[2],
					Prefix:    groups[5],
					v:         v,
				}
				id.Suffix = strings.TrimPrefix(id.URI, id.Namespace+"/")
				fmt.Println("id was", id)
				found[id.URI] = id
			}
		}
	}
	v.msmu.RUnlock()
	rv := []*InterfaceDescription{}
	for _, vv := range found {
		if vv.Meta("lastalive") != "" {
			lv := vv
			rv = append(rv, &lv)
		} else {
			fmt.Println("interface is not alive")
		}
	}
	sort.Sort(interfaceSorter(rv))
	return rv
}

type interfaceSorter []*InterfaceDescription

func (is interfaceSorter) Swap(i, j int) {
	is[i], is[j] = is[j], is[i]
}
func (is interfaceSorter) Less(i, j int) bool {
	return strings.Compare(is[i].URI, is[j].URI) < 0
}
func (is interfaceSorter) Len() int {
	return len(is)
}
func (v *View) OnChange(f func()) {
	v.msmu.Lock()
	v.changecb = append(v.changecb, f)
	v.msmu.Unlock()
}

type InterfaceDescription struct {
	URI       string            `msgpack:"uri"`
	Interface string            `msgpack:"iface"`
	Service   string            `msgpack:"svc"`
	Namespace string            `msgpack:"namespace"`
	Prefix    string            `msgpack:"prefix"`
	Suffix    string            `msgpack:"suffix"`
	Metadata  map[string]string `msgpack:"metadata"`
	v         *View
}

func (id *InterfaceDescription) ToPO() objects.PayloadObject {
	po, err := advpo.CreateMsgPackPayloadObject(objects.PONumInterfaceDescriptor, id)
	if err != nil {
		panic(err)
	}
	return po
}

func (id *InterfaceDescription) Meta(key string) string {
	mdat, ok := id.v.Meta(id.URI, key)
	if !ok {
		return "<unset>"
	}
	return mdat.Value
}

/*
Example use
v := cl.NewView()
q := view.MatchURI(mypattern)
q = q.And(view.MetaEq(key, value))
q = q.And(view.MetaHasKey(key))
q = q.And(view.IsInterface("i.wavelet"))
q = q.And(view.IsService("s.thingy"))
v = v.And(view.MatchURI(myurl, mypattern))

can assume all interfaces are persisted up to .../i.foo/
when you subscribe,
*/

type Expression interface {
	//Given a complete resource name, does this expression
	//permit it to be included in the view
	Matches(uri string, v *View) bool
	//Given a partial resource name (prefix) does this expression
	//possibly permit it to be included in the view. Yes means maybe
	//no means no.
	MightMatch(uri string, v *View) bool

	//Return a list of all URIs(sans namespaces) that are sufficient
	//to evaluate this expression (minimum subscription set). Does not
	//include metadata
	CanonicalSuffixes() []string

	//Return a list of all namespaces that this expression would make
	//you want to operate on
	Namespaces() []string
}

type andExpression struct {
	subex []Expression
}

func (e *andExpression) Namespaces() []string {
	sslcs := []string{}
	for _, s := range e.subex {
		sslcs = append(sslcs, s.Namespaces()...)
	}
	return sslcs
}

func (e *andExpression) Matches(uri string, v *View) bool {
	for _, s := range e.subex {
		if !s.Matches(uri, v) {
			fmt.Printf("andex(%s) -> false\n", uri)
			return false
		}
	}
	return true
}
func (e *andExpression) MightMatch(uri string, v *View) bool {
	for _, s := range e.subex {
		if !s.MightMatch(uri, v) {
			return false
		}
	}
	return true
}
