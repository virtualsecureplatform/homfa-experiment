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
DAMON_004='G(((!p5 & !p4 & !p3) & ((p2 & !p1 & p0) | (p2 & !p1 & !p0) | (!p2 & p1 & p0) | (!p2 & p1 & !p0) | (!p2 & !p1 & p0) | (!p2 & !p1 & !p0))) -> F[0, 25] ((p2 & p1 & !p0) | (p2 & p1 & p0) | p3 | p4 | p5))'
DAMON_005='G(p5 | (p4 & p2) | (p4 & p3) -> F[0, 25]((!p5 & p4 & !p3 & !p2) | (!p5 & !p4)))'
gen_spec "$DAMON_001" damon-001.spec 6
gen_spec "$DAMON_002" damon-002.spec 6
gen_spec "$DAMON_004" damon-004.spec 6
gen_spec "$DAMON_005" damon-005.spec 6
gen_reversed_spec "$DAMON_001" damon-001-rev.spec 6
gen_reversed_spec "$DAMON_002" damon-002-rev.spec 6
gen_reversed_spec "$DAMON_004" damon-004-rev.spec 6
gen_reversed_spec "$DAMON_005" damon-005-rev.spec 6
