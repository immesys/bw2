package api

import (
	"regexp"
	"strings"

	"github.com/immesys/bw2/crypto"
)

func Namespace(nsz ...string) Expression {
	return &nsExpression{nsz: nsz, realnsz: nil}
}

type nsExpression struct {
	nsz     []string
	realnsz []string
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

func And(terms ...Expression) Expression {
	return &andExpression{subex: terms}
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
			return false
		}
	}
	return true
}

func (e *andExpression) CanonicalSuffixes() []string {
	retv := [][]string{}
	for _, s := range e.subex {
		retv = append(retv, s.CanonicalSuffixes())
	}
	return foldAndCanonicalSuffixes(retv[0], retv[1:]...)
}

func (e *andExpression) MightMatch(uri string, v *View) bool {
	for _, s := range e.subex {
		if !s.MightMatch(uri, v) {
			return false
		}
	}
	return true
}

func Or(terms ...Expression) Expression {
	return &orExpression{subex: terms}
}

type orExpression struct {
	subex []Expression
}

func (e *orExpression) Namespaces() []string {
	sslcs := []string{}
	for _, s := range e.subex {
		sslcs = append(sslcs, s.Namespaces()...)
	}
	return sslcs
}

func (e *orExpression) Matches(uri string, v *View) bool {
	for _, s := range e.subex {
		if s.Matches(uri, v) {
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
func (e *orExpression) MightMatch(uri string, v *View) bool {
	for _, s := range e.subex {
		if s.MightMatch(uri, v) {
			return true
		}
	}
	return false
}

func EqMeta(key, value string) Expression {
	return &metaEqExpression{key: key, val: value, regex: false}
}

type metaEqExpression struct {
	key   string
	val   string
	regex bool
}

func (e *metaEqExpression) Namespaces() []string {
	return []string{}
}
func (e *metaEqExpression) Matches(uri string, v *View) bool {
	val, ok := v.Meta(uri, e.key)
	if !ok {
		return false
	}
	if e.regex {
		panic("have not done regex yet")
	} else {
		return val.Value == e.val
	}
}
func (e *metaEqExpression) CanonicalSuffixes() []string {
	return []string{"*"}
}
func (e *metaEqExpression) MightMatch(uri string, v *View) bool {
	//You don't know until the final resource
	return true
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
		return rv
	} else {
		panic("have not done thing yet")
	}
}
func (e *uriEqExpression) CanonicalSuffixes() []string {
	if e.regex {
		return []string{"*"}
	}
	return []string{e.pattern}
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

func HasMeta(key string) Expression {
	return &metaHasExpression{key: key}
}

type metaHasExpression struct {
	key string
}

func (e *metaHasExpression) Namespaces() []string {
	return []string{}
}
func (e *metaHasExpression) Matches(uri string, v *View) bool {
	_, ok := v.Meta(uri, e.key)
	return ok
}
func (e *metaHasExpression) CanonicalSuffixes() []string {
	return []string{"*"}
}
func (e *metaHasExpression) MightMatch(uri string, v *View) bool {
	//You don't know until the final resource
	return true
}
