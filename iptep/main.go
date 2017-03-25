package iptep

import (
	"bytes"
	"context"
	"log"
	"net/http"
	"os/exec"
	"regexp"
	"strconv"
	"sync"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var allstats map[string]*Stat
var pmc map[string]prometheus.Gauge
var statmu sync.Mutex

func getit() []byte {
	cmd := exec.CommandContext(context.Background(), "iptables", "-L", "-vx")
	rv, err := cmd.CombinedOutput()
	if err != nil {
		panic(err)
	}
	return rv
}
func StartIPTEP() {
	allstats = make(map[string]*Stat)
	pmc = make(map[string]prometheus.Gauge)
	doround()
	statmu.Lock()
	for _, stat := range allstats {
		sc := prometheus.NewGauge(prometheus.GaugeOpts{
			Name: stat.Name + "_pkts",
			Help: "autogenerate iptables packets counter",
		})
		pmc[stat.Name+"_pkts"] = sc
		prometheus.MustRegister(sc)
		sc = prometheus.NewGauge(prometheus.GaugeOpts{
			Name: stat.Name + "_bytes",
			Help: "autogenerate iptables bytes counter",
		})
		pmc[stat.Name+"_bytes"] = sc
		prometheus.MustRegister(sc)
	}
	statmu.Unlock()
	go func() {
		for {
			doround()
			time.Sleep(3 * time.Second)
		}
	}()
	http.Handle("/metrics", promhttp.Handler())
	log.Fatal(http.ListenAndServe(":7777", nil))
}

func doround() {
	ins := getit()
	sr := bytes.NewBuffer(ins)
	ln, err := sr.ReadString('\n')
	tm := time.Now().UnixNano()
	for err == nil {
		s := procline(ln)
		if s != nil {
			s.Time = tm
			statmu.Lock()
			allstats[s.Name] = s
			pm, ok := pmc[s.Name+"_pkts"]
			if ok {
				pm.Set(float64(s.Packets))
			}
			pm, ok = pmc[s.Name+"_bytes"]
			if ok {
				pm.Set(float64(s.Bytes))
			}
			statmu.Unlock()
		}
		ln, err = sr.ReadString('\n')
	}
}

type Stat struct {
	Time    int64
	Name    string
	Bytes   int64
	Packets int64
}

//       0        0 ACCEPT     tcp  --  any    any     anywhere             anywhere             tcp dpt:30302 state ESTABLISHED /* disc_tcp_out */
// 0        0 ACCEPT     tcp  --  any    any     anywhere             anywhere             tcp dpt:30304 state ESTABLISHED /* discv5_tcp_out */
// 0        0 ACCEPT     tcp  --  any    any     anywhere             anywhere             tcp dpts:30300:30320 state ESTABLISHED /* bw:misc_tcp_out */
var Pat *regexp.Regexp = regexp.MustCompile(`\s*(\d+)\s*(\d+)\s*ACCEPT.*\/\* bw:(\S+) \*\/`)

func procline(ln string) *Stat {
	matchez := Pat.FindStringSubmatch(ln)
	if len(matchez) > 0 {
		Name := matchez[3]
		Bytes, err := strconv.ParseInt(matchez[2], 10, 64)
		if err != nil {
			panic(err)
		}
		Packets, err := strconv.ParseInt(matchez[1], 10, 64)
		if err != nil {
			panic(err)
		}
		return &Stat{Name: Name, Bytes: Bytes, Packets: Packets}
	}
	return nil
}
