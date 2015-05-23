package core

import (
	"os"

	"code.google.com/p/gcfg"
	log "github.com/cihub/seelog"
)

// BWConfig is the configuration for a router
type BWConfig struct {
	Native struct {
		ListenOn string
	}
	Plaintext struct {
		ListenOn string
	}
}

// LoadConfig will load and return a configuration. If "" is specified for the filename,
// it will default to "bw2.ini" in the current directory
func LoadConfig(filename string) *BWConfig {
	rv := &BWConfig{}
	if filename != "" {
		err := gcfg.ReadFileInto(rv, filename)
		if err != nil {
			log.Criticalf("Could not load specified config file: %v", err)
			os.Exit(1)
		}
	} else {
		err := gcfg.ReadFileInto(rv, "bw2.ini")
		if err != nil {
			log.Criticalf("Could not load default config file: %v", err)
			os.Exit(1)
		}
	}
	return rv
}
