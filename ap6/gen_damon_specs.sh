#!/usr/bin/bash 

BUILD_BIN=${BUILD_BIN:-"build/bin"}
HOMFA=$BUILD_BIN/homfa

# $1 LTL formula
# $2 spec filename
# $3 num of ap
gen_spec(){
	$HOMFA ltl2spec "$1" $3 | $HOMFA spec2spec --minimized > $2
}

# $1 LTL formula
# $2 spec filename
# $3 num of ap
gen_reversed_spec(){
	$HOMFA ltl2spec "$1" $3 | $HOMFA spec2spec --reversed |$HOMFA spec2spec --minimized > $2
}

DAMON_001='G((p0 & p1 & p2 & !p3 & !p4 & !p5) | (p3 & !p4 & !p5) | (!p1 & !p2 & !p3 & p4 & !p5))'
DAMON_002='G ((!p5 &  p4 &  p3 & !p2 &  p1 &  p0) | (!p5 &  p4 &  p3 &  p2 & !p1 & !p0) | (!p5 &  p4 &  p3 &  p2 & !p1 &  p0) | (!p5 &  p4 &  p3 &  p2 &  p1 & !p0) | (!p5 &  p4 &  p3 &  p2 &  p1 &  p0) | (!p5 & !p4 & !p3 & !p2 & !p1 & !p0) | (!p5 & !p4 & !p3 & !p2 & !p1 &  p0) | (!p5 & !p4 & !p3 & !p2 &  p1 & !p0))'
DAMON_004='!p5 & !p4 & !p3 & (p2 & !p1 & p0 | p2 & !p1 & !p0 | !p2 & p1 & p0 | !p2 & p1 & !p0 | !p2 & !p1 & p0 | !p2 & !p1 & !p0) -> p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5 | X(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5) | XXXXXXXXXXXXXXXXXXXXXXXXX(p2 & p1 & !p0 | p2 & p1 & p0 | p3 | p4 | p5)'
DAMON_005='p5 | p4 & p2 | p4 & p3 -> !p5 & p4 & !p3 & !p2 | !p5 & !p4 | X(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4) | XXXXXXXXXXXXXXXXXXXXXXXXX(!p5 & p4 & !p3 & !p2 | !p5 & !p4)'
gen_spec "$DAMON_001" damon-001.spec 6
gen_spec "$DAMON_002" damon-002.spec 6
gen_spec "$DAMON_004" damon-004.spec 6
gen_spec "$DAMON_005" damon-005.spec 6
gen_reversed_spec "$DAMON_001" damon-001-rev.spec 6
gen_reversed_spec "$DAMON_002" damon-002-rev.spec 6
gen_reversed_spec "$DAMON_004" damon-004-rev.spec 6
gen_reversed_spec "$DAMON_005" damon-005-rev.spec 6
