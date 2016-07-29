// +build profiling

package main

import (
	"net/http"
	_ "net/http/pprof"
)

func startProfile() {
	go http.ListenAndServe(":8080", http.DefaultServeMux)
}

func stopProfile() {

}
