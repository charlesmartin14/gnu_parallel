#!/usr/bin/env ruby
p __FILE__
$LOAD_PATH << "." << "../lib/gnu_parallel"
require 'rubygems'
require 'test_gnu_parallel'

File.open("test.txt","w") do |f|
  f << (0..100_000).to_a.join("\n") 
end


test = TestGnuParallel.new
test.run


