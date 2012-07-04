#!/usr/bin/env ruby
#?
#?
$LOAD_PATH << "../lib/gnu_parallel"
require 'gnu_parallel'

# ARGS.first = filename 
obj = GnuParallel.deserialize_obj(ARGV.first).p_call

