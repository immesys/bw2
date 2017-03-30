package bn256

import (
	"bytes"
	"crypto/rand"
	"math/big"
	"testing"

	"golang.org/x/crypto/bn256"
)

func TestZeroPowerG1(t *testing.T) {
	power := big.NewInt(0)
	a := new(G1).ScalarBaseMult(power).Marshal()
	b := new(bn256.G1).ScalarBaseMult(power).Marshal()
	if !bytes.Equal(a, b) {
		t.Errorf("failed at power %s: %x vs %x", power, a, b)
	}
}

func TestZeroPowerG2(t *testing.T) {
	power := big.NewInt(0)
	a := new(G2).ScalarBaseMult(power).Marshal()
	b := new(bn256.G2).ScalarBaseMult(power).Marshal()
	if !bytes.Equal(a, b) {
		t.Errorf("failed at power %s: %x vs %x", power, a, b)
	}
}

func TestPowersG1(t *testing.T) {
	power := big.NewInt(1)
	bigOne := big.NewInt(1)

	for i := 0; i < 150; i++ {
		a := new(G1).ScalarBaseMult(power).Marshal()
		b := new(bn256.G1).ScalarBaseMult(power).Marshal()
		if !bytes.Equal(a, b) {
			t.Errorf("failed at power %s: %x vs %x", power, a, b)
		}
		power.Lsh(power, 1)
		if i&1 == 1 {
			power.Add(power, bigOne)
		}
	}
}

func TestMarshalUnmarshalG1(t *testing.T) {
	a := new(G1).ScalarBaseMult(big.NewInt(66))
	serialise1 := a.Marshal()
	b, ok := new(G1).Unmarshal(serialise1)
	if !ok {
		t.Fatalf("Unmarshal failed")
	}
	serialise2 := b.Marshal()
	if !bytes.Equal(serialise1, serialise2) {
		t.Errorf("Marshal/Unmarshal round trip failed, got: %x want: %x", serialise2, serialise1)
	}
}

func TestPowersG2(t *testing.T) {
	power := big.NewInt(1)
	bigOne := big.NewInt(1)

	for i := 0; i < 150; i++ {
		a := new(G2).ScalarBaseMult(power).Marshal()
		b := new(bn256.G2).ScalarBaseMult(power).Marshal()
		if !bytes.Equal(a, b) {
			t.Errorf("failed at power %s: %x vs %x", power, a, b)
		}
		power.Lsh(power, 1)
		if i&1 == 1 {
			power.Add(power, bigOne)
		}
	}
}

func TestMarshalUnmarshalG2(t *testing.T) {
	a := new(G2).ScalarBaseMult(big.NewInt(66))
	serialise1 := a.Marshal()
	b, ok := new(G2).Unmarshal(serialise1)
	if !ok {
		t.Fatalf("Unmarshal failed")
	}
	serialise2 := b.Marshal()
	if !bytes.Equal(serialise1, serialise2) {
		t.Errorf("Marshal/Unmarshal round trip failed, got: %x want: %x", serialise2, serialise1)
	}
}

func TestMarshalUnmarshalGT(t *testing.T) {
	a := Pair(new(G1).ScalarBaseMult(big.NewInt(44)), new(G2).ScalarBaseMult(big.NewInt(22)))
	serialise1 := a.Marshal()
	b, ok := new(GT).Unmarshal(serialise1)
	if !ok {
		t.Fatalf("Unmarshal failed")
	}
	serialise2 := b.Marshal()
	if !bytes.Equal(serialise1, serialise2) {
		t.Errorf("Marshal/Unmarshal round trip failed, got:\n%x\nwant:\n%x", serialise2, serialise1)
	}
}

func TestPairing(t *testing.T) {
	a := bn256.Pair(new(bn256.G1).ScalarBaseMult(big.NewInt(2)), new(bn256.G2).ScalarBaseMult(big.NewInt(1))).Marshal()
	b := Pair(new(G1).ScalarBaseMult(big.NewInt(2)), new(G2).ScalarBaseMult(big.NewInt(1))).Marshal()
	base := Pair(new(G1).ScalarBaseMult(big.NewInt(1)), new(G2).ScalarBaseMult(big.NewInt(1)))
	b2 := new(GT).Add(base, base).Marshal()

	if !bytes.Equal(a, b) {
		t.Errorf("Pairings differ\ngot:  %x\nwant: %x", a, b)
	}
	if !bytes.Equal(b, b2) {
		t.Errorf("Pair(2,1) != 2*Pair(1,1)\ngot:  %x\nwant: %x", b, b2)
	}
}

func TestMarshalSame(t *testing.T) {
	a := new(G2).ScalarBaseMult(big.NewInt(66))
	aa := new(bn256.G2).ScalarBaseMult(big.NewInt(66))
	if bytes.Compare(a.Marshal(), aa.Marshal()) != 0 {
		t.Fatalf("marshalling differs")
	}
}

func BenchmarkUnmarshalG2(b *testing.B) {
	a := new(G2).ScalarBaseMult(big.NewInt(66))
	serialise1 := a.Marshal()
	b.ResetTimer()

	for i := 0; i < b.N; i++ {
		new(G2).Unmarshal(serialise1)
	}
}

func BenchmarkScalarMultG2(b *testing.B) {
	r, _ := rand.Int(rand.Reader, Order)
	_, x, _ := RandomG2(rand.Reader)
	g2 := new(G2)
	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		g2.ScalarMult(x, r)
	}
}

func TestAddG1(t *testing.T) {
	for i := 0; i < 500; i++ {
		_, x, _ := RandomG1(rand.Reader)
		_, y, _ := RandomG1(rand.Reader)
		sum := new(G1).Add(x, y)

		xref, _ := new(bn256.G1).Unmarshal(x.Marshal())
		yref, _ := new(bn256.G1).Unmarshal(y.Marshal())
		sumref := new(bn256.G1).Add(xref, yref)

		if !bytes.Equal(sum.Marshal(), sumref.Marshal()) {
			t.Fatalf("sums don't match: x=%s y=%s", x, y)
		}
	}
}

func TestAddG2(t *testing.T) {
	for i := 0; i < 500; i++ {
		_, x, _ := RandomG2(rand.Reader)
		_, y, _ := RandomG2(rand.Reader)
		sum := new(G2).Add(x, y)

		xref, _ := new(bn256.G2).Unmarshal(x.Marshal())
		yref, _ := new(bn256.G2).Unmarshal(y.Marshal())
		sumref := new(bn256.G2).Add(xref, yref)

		if !bytes.Equal(sum.Marshal(), sumref.Marshal()) {
			t.Fatalf("sums don't match: x=%s y=%s", x, y)
		}
	}
}

// Confirm that elements of G2 are in the n-torsion subgroup.
func TestRandomG2(t *testing.T) {
	for i := 0; i < 1000; i++ {
		_, g2, _ := RandomG2(rand.Reader)
		po := new(twistPoint).Mul(g2.p, Order)
		if !po.IsInfinity() {
			t.Errorf("pt * Order is not infinity: %s", g2.p)
		}
	}
}

func testPrintCgoConstants(t *testing.T) {
	// x = (p-3)/4
	x := new(big.Int).Sub(p, big.NewInt(3))
	x.Div(x, big.NewInt(4))
	xws := bigToWords(x, p)
	t.Logf("(p-3)/4 = %#v", xws)

	// y = (p-1)/2
	y := new(big.Int).Sub(p, big.NewInt(1))
	y.Div(y, big.NewInt(2))
	yws := bigToWords(y, p)
	t.Logf("(p-1)/2 = %#v", yws)

	// z = p-2
	z := new(big.Int).Sub(p, big.NewInt(2))
	zws := bigToWords(z, p)
	t.Logf("p-2 = %#v", zws)

	o := new(big.Int).Set(Order)
	ows := bigToWords(o, new(big.Int).Exp(Order, big.NewInt(2), nil))
	t.Logf("Order = %#v", ows)
}
