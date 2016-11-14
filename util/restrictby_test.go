package util

import (
	"fmt"
	"testing"
)

func TRS(t *testing.T, from string, by string, result string) {
	fmt.Printf("Testing from=%s by=%s\n", from, by)
	rv, b := RestrictBy(from, by)
	if !b {
		t.Fatalf("Restricting from='%s' by='%s' got FALSE expected TRUE", from, by)
	} else if rv != result {
		t.Fatalf("Restricting from='%s' by='%s' got '%s' expected '%s'", from, by, rv, result)
	}
}
func TRF(t *testing.T, from string, by string) {
	rv, b := RestrictBy(from, by)
	if b {
		t.Fatalf("Restricting from='%s' by='%s' got TRUE expected FALSE", from, by)
	}
	if rv != "" {
		t.Fatalf("Restricting from='%s' by='%s' got '%s' expected empty", from, by, rv)
	}
}

func TestRestrictBy(t *testing.T) {
	TRS(t, "a/b/c", "a/b/c", "a/b/c")
	TRS(t, "a/*/c", "a/b/c", "a/b/c")
	TRS(t, "a/*/c", "*/c", "a/*/c")
	TRS(t, "a/*/b/c", "a/*/c", "a/*/b/c")
	TRS(t, "eecs/*/!meta/giles", "*/!meta/giles", "eecs/*/!meta/giles")
}

func TestRestrictOrig(t *testing.T) {
	TV := []struct {
		T  string
		P  string
		Rs string
		Rb bool
	}{
		//case 0: no stars
		{"a/b/c", "a/b/c", "a/b/c", true},
		{"a/b", "a/b/c", "", false},
		{"a/b/c", "a/b", "", false},
		{"a/+/c", "a/b/c", "a/b/c", true},
		{"a/b/c", "a/+/c", "a/b/c", true},
		{"a/+/c", "a/+/c", "a/+/c", true},
		//
		//case 1: left star
		{"a/*", "a/b/c", "a/b/c", true},
		{"a/*", "a/*", "a/*", true},
		{"*/a", "a/b/c", "", false},
		{"*/a", "a/b/c/a", "a/b/c/a", true},
		{"*/a", "a", "a", true},
		{"*/b/c", "a/b/c", "a/b/c", true},
		{"a/*/c", "a/c", "a/c", true},
		{"a/*/c", "a/b/d/e/c", "a/b/d/e/c", true},
		{"a/*/c", "a/+/c", "a/+/c", true},
		{"a/+/c", "a/*/c", "a/+/c", true},
		{"+/*/+", "a/b/c/d", "a/b/c/d", true},
		//case 2: right star
		{"a/b/c", "a/*", "a/b/c", true},
		{"a/b/c", "*", "a/b/c", true},
		{"+/b/c", "*", "+/b/c", true},
		{"a/b/+", "*/+", "a/b/+", true},
		{"a/b/c", "*/c", "a/b/c", true},
		//case 3: both stars
		{"a/b/*/c/d", "a/b/x/*/y/c/d", "a/b/x/*/y/c/d", true},
		{"a/b/c/d/*/x/y", "a/*/y", "a/b/c/d/*/x/y", true},
		{"a/b/c/d/*/x/y", "a/*/x/y", "a/b/c/d/*/x/y", true},
		{"a/b/c/d/*/x/y", "a/*/w/x/y", "a/b/c/d/*/w/x/y", true},
		{"a/b/*/x/y", "a/b/c/d/*/y", "a/b/c/d/*/x/y", true},
		{"a/b/c", "a/b/c", "a/b/c", true},
		{"a/*", "a/b/c", "a/b/c", true},
		{"a/b/c", "a/*", "a/b/c", true},
		{"a/b/c", "*/c", "a/b/c", true},
		{"*/c", "a/b/c", "a/b/c", true},
		{"a/b/c/*/x/y/z", "a/b/1/*/2/y/z", "", false},
	}
	for _, v := range TV {
		res, ok := RestrictBy(v.T, v.P)
		if res != v.Rs || ok != v.Rb {
			fmt.Printf("Fail %+v, got %v\n", v, res)
			t.Fail()
		}
	}
}
