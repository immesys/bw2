package api

import "encoding/base64"

func SplitURI(uri string) (mvk []byte, urisuffix string, ok bool) {
	rv, err := base64.URLEncoding.DecodeString(uri[:44])
	if err != nil {
		return nil, "", false
	}
	return rv, uri[45:], true
}

// MatchTopic will check if t matches the pattern.
// TODO this is not nearly as optimal as it can be, copy
// logic from RestrictBy. In the meantime it may be faster
// to call RestrictBy.
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
