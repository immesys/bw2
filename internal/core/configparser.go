package core

import (
	"os"
	"strings"

	"code.google.com/p/gcfg"
	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/internal/crypto"
)

// BWConfig is the configuration for a router
type BWConfig struct {
	Router struct {
		VK string
		SK string
		DB string
	}
	Affinity struct {
		MVK []string
	}
	Native struct {
		ListenOn string
	}
	OOB struct {
		ListenOn string
	}
	DNSOverride struct {
		Set []string
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

//DNS override should allow
// name : mvk
// mvk : dr
// dr : host
func (c *BWConfig) GetNamecache() map[string][]byte {
	rv := make(map[string][]byte)
	for _, e := range c.DNSOverride.Set {
		parts := strings.Split(e, " ")
		if parts[0] == "mvk" {
			v, err := crypto.UnFmtKey(parts[2])
			if err != nil {
				log.Critical("Could not parse DNS override line: ", e)
				continue
			}
			rv[parts[1]] = v
		}
	}
	return rv
}

func (c *BWConfig) GetDRVKcache() map[string][]byte {
	rv := make(map[string][]byte)
	for _, e := range c.DNSOverride.Set {
		parts := strings.Split(e, " ")
		if parts[0] == "dr" {
			v, err := crypto.UnFmtKey(parts[2])
			if err != nil {
				log.Critical("Could not parse DNS override line: ", e)
				continue
			}
			rv[parts[1]] = v
		}
	}
	return rv
}

func (c *BWConfig) GetTargetcache() map[string]string {
	rv := make(map[string]string)
	for _, e := range c.DNSOverride.Set {
		parts := strings.Split(e, " ")
		if parts[0] == "srv" {
			rv[parts[1]] = parts[2]
		}
	}
	return rv
}
