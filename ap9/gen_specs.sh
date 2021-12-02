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

DAMON_001='G((!p5&!p6&p7&!p8)|(!p4&!p6&p7&!p8)|(!p2&!p3&!p6&p7&!p8)|(p3&p6&!p7&!p8)|(p4&p6&!p7&!p8)|(p5&p6&!p7&!p8)|(p0&p1&p2&p6&!p7&!p8))'
DAMON_004='G((!p6&!p7&!p8) -> F[0, 25]((p6)|(p7)|(p8)))'
DAMON_005='G((p8)|(p2&p6&p7)|(p3&p6&p7)|(p4&p6&p7)|(p5&p6&p7) -> F[0, 25]((!p7&!p8)|(!p6&!p8)|(!p2&!p3&!p4&!p5&!p8)))'
TOWARDS_001='G[100, 700]((p7)|(p8)|(p3&p6)|(p4&p6)|(p5&p6)|(p1&p2&p6))'
TOWARDS_002='G[100, 700]((!p8)|(!p6&!p7)|(!p4&!p5&!p7)|(!p3&!p5&!p7)|(!p2&!p5&!p7)|(!p1&!p5&!p7)|(!p0&!p5&!p7))'
TOWARDS_004='G[600, 700]((!p7&!p8)|(!p6&!p8)|(!p3&!p4&!p5&!p8)|(!p0&!p1&!p2&!p4&!p5&!p8))'
gen_spec "$DAMON_001" damon-001.spec 9
gen_spec "$DAMON_004" damon-004.spec 9
gen_spec "$DAMON_005" damon-005.spec 9
gen_spec "$TOWARDS_001" towards-001.spec 9
gen_spec "$TOWARDS_002" towards-002.spec 9
gen_spec "$TOWARDS_004" towards-004.spec 9
gen_reversed_spec "$DAMON_001" damon-001-rev.spec 9
gen_reversed_spec "$DAMON_004" damon-004-rev.spec 9
gen_reversed_spec "$DAMON_005" damon-005-rev.spec 9
#gen_reversed_spec "$TOWARDS_001" towards-001-rev.spec 9
#gen_reversed_spec "$TOWARDS_002" towards-002-rev.spec 9
#gen_reversed_spec "$TOWARDS_004" towards-004-rev.spec 9
