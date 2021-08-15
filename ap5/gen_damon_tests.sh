#!/bin/bash

ruby gen_test_damon-001.rb true 10080  | ruby 01tobin.rb 5 > test-damon-001-true.in
ruby gen_test_damon-001.rb false 10080 | ruby 01tobin.rb 5 > test-damon-001-false.in
ruby gen_test_damon-002.rb true 10080  | ruby 01tobin.rb 5 > test-damon-002-true.in
ruby gen_test_damon-002.rb false 10080 | ruby 01tobin.rb 5 > test-damon-002-false.in
ruby gen_test_damon-004.rb true 10080  | ruby 01tobin.rb 5 > test-damon-004-true.in
ruby gen_test_damon-004.rb false 10080 | ruby 01tobin.rb 5 > test-damon-004-false.in
ruby gen_test_damon-005.rb true 10080  | ruby 01tobin.rb 5 > test-damon-005-true.in
ruby gen_test_damon-005.rb false 10080 | ruby 01tobin.rb 5 > test-damon-005-false.in
