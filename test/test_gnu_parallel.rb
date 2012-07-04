#!/usr/bin/env ruby
$LOAD_PATH << "../lib/gnu_parallel"
require 'rubygems'
require 'gnu_parallel'

class TestGnuParallel
  include GnuParallel
  
  def initialize( opts= { :name => "test_gnu_parallel" } )
    @opts=opts
  end
  
  def run
    p_stream(source="test.txt", header = false) do
      $stdin.each do | line|
        $stdout << line.chomp.to_i*3 << "\n"
      end
    end
  end

end

