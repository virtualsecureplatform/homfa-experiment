#!/bin/bash

ruby gen_test_damon-001.rb true 10080  | ruby ../01tobin.rb 9 > test-damon-001-true.in
ruby gen_test_damon-001.rb false 10080 | ruby ../01tobin.rb 9 > test-damon-001-false.in
ruby gen_test_damon-004.rb true 10080  | ruby ../01tobin.rb 9 > test-damon-004-true.in
ruby gen_test_damon-004.rb false 10080 | ruby ../01tobin.rb 9 > test-damon-004-false.in
ruby gen_test_damon-005.rb true 10080  | ruby ../01tobin.rb 9 > test-damon-005-true.in
ruby gen_test_damon-005.rb false 10080 | ruby ../01tobin.rb 9 > test-damon-005-false.in
ruby gen_test_towards-001.rb true 10080 | ruby ../01tobin.rb 9 > test-towards-001-true.in
ruby gen_test_towards-001.rb false 10080 | ruby ../01tobin.rb 9 > test-towards-001-false.in
ruby gen_test_towards-002.rb true 10080 | ruby ../01tobin.rb 9 > test-towards-002-true.in
ruby gen_test_towards-002.rb false 10080 | ruby ../01tobin.rb 9 > test-towards-002-false.in
ruby gen_test_towards-004.rb true 10080 | ruby ../01tobin.rb 9 > test-towards-004-true.in
ruby gen_test_towards-004.rb false 10080 | ruby ../01tobin.rb 9 > test-towards-004-false.in
ruby symglucose_csv_to_01.rb bg adult#001_1st_7days.csv | ruby ../01tobin.rb 9 > adult-001-7days-bg.in