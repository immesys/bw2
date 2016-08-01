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
	"path/filepath"

	log "github.com/cihub/seelog"
	"github.com/scalingdata/gcfg"
)

// BWConfig is the configuration for a router
type BWConfig struct {
	Router struct {
		Entity  string
		DB      string
		LogPath string
	}
	Native struct {
		ListenOn string
	}
	OOB struct {
		ListenOn string
	}
}

// LoadConfig will load and return a configuration. If "" is specified for the filename,
// it will default to "bw2.ini" in the current directory
func LoadConfig(filename string) *BWConfig {
	rv := &BWConfig{}
	if filename == "" {
		filename = "bw2.ini"
	}
	err := gcfg.ReadFileInto(rv, filename)
	if err != nil {
		log.Criticalf("Could not load specified config file: %v", err)
		os.Exit(1)
	}
	rv.Router.Entity = filepath.FromSlash(rv.Router.Entity)
	rv.Router.DB = filepath.FromSlash(rv.Router.DB)
	rv.Router.LogPath = filepath.FromSlash(rv.Router.LogPath)
	return rv
}
