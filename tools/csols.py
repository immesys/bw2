

with open("contract.sol") as f:
    datl = f.readlines()
    dat = ""
    for dl in datl:
        dl = dl.replace("\"","\\\"")
        dat += "%-78s\\\n" % dl[:-1]
    with open("contract.com","w") as o:
        o.write("var csrc = \"\\\n" + dat +"\"\n")
