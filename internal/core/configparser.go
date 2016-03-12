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

package core

import (
	"os"
	"strings"

	"code.google.com/p/gcfg"
	log "github.com/cihub/seelog"
	"github.com/immesys/bw2/crypto"
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
