#!/usr/bin/bash -eux

BUILD_BIN=${BUILD_BIN:-"build/bin"}
TEST0=$BUILD_BIN/test0
TEST_PLAIN_RANDOM=$BUILD_BIN/test_plain_random
HOMFA=$BUILD_BIN/homfa

failwith(){
    echo -ne "\e[1;31m[ERROR]\e[0m "
    echo "$1"
    exit 1
}

enc_run_dec(){
    case "$1" in
        "offline-dfa" )
            $HOMFA enc --ap "$2" --key _test_sk --in "$4" --out _test_in
            $HOMFA run-offline-dfa --bkey _test_bk --spec "$3" --in _test_in --out _test_out
            $HOMFA dec --key _test_sk --in _test_out
            ;;
        "online-dfa-reversed" )
            $HOMFA enc --ap "$2" --key _test_sk --in "$4" --out _test_in
            $HOMFA run-online-dfa --method reversed --bkey _test_bk --spec "$3" --in _test_in --out _test_out
            $HOMFA dec --key _test_sk --in _test_out
            ;;
        "online-dfa-qtrlwe2" )
            $HOMFA enc --ap "$2" --key _test_sk --in "$4" --out _test_in
            $HOMFA run-online-dfa --method qtrlwe2 --bkey _test_bk --spec "$3" --in _test_in --out _test_out
            $HOMFA dec --key _test_sk --in _test_out
            ;;
        "dfa-plain" )
            $HOMFA run-dfa-plain --ap "$2" --spec "$3" --in "$4"
            ;;
        * )
            failwith "Invalid run $1"
            ;;
    esac
}

check_true(){
    res=$(enc_run_dec "$1" "$2" "$3" "$4")
    echo "$res" | grep "Result (bool): true" > /dev/null
    [ $? -eq 0 ] || failwith "Expected true, got false >>> enc_run_dec \"$1\" \"$2\" \"$3\" \"$4\"\\$res"
}

check_false(){
    res=$(enc_run_dec "$1" "$2" "$3" "$4")
    echo "$res" | grep "Result (bool): false" > /dev/null
    [ $? -eq 0 ] || failwith "Expected false, got true >>> enc_run_dec \"$1\" \"$2\" \"$3\" \"$4\"\\$res"
}

### Prepare secret key and bootstrapping key
[ -f _test_sk ] || $HOMFA genkey --out _test_sk
[ -f _test_bk ] || $HOMFA genbkey --key _test_sk --out _test_bk

### Now start testing
#### Plain DFA
check_false  dfa-plain 5 damon-001.spec adult-001-bg.in
check_true   dfa-plain 5 damon-001.spec adult-001-bg-true.in
check_false  dfa-plain 5 damon-002.spec adult-001-dbg.in
check_true  dfa-plain 5 damon-002.spec adult-001-dbg-true.in

#### Offline DFA
check_false  offline-dfa 5 damon-001.spec adult-001-bg.in
check_true   offline-dfa-plain 5 damon-001.spec adult-001-bg-true.in
check_false  offline-dfa-plain 5 damon-002.spec adult-001-dbg.in
check_true  offline-dfa-plain 5 damon-002.spec adult-001-dbg-true.in

#### Online DFA (reversed)
check_false online-dfa-reversed 5 damon-001.spec adult-001-bg.in
check_true  online-dfa-reversed 5 damon-001.spec adult-001-bg-true.in
check_false online-dfa-reversed 5 damon-002.spec adult-001-dbg.in
check_true online-dfa-reversed 5 damon-002.spec adult-001-dbg-true.in

### Clean up temporary files
rm _test_sk _test_bk _test_in _test_out #_test_random.log
