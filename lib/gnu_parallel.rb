#!/usr/bin/env ruby

require 'rubygems'
require 'json'
require 'sourcify'
require 'fileutils'
require 'active_support/inflector'
require 'active_support/core_ext'



module GnuParallel
  
  VERSION = "0.0.1"

  # to be called directly
  def deserialize_obj(filename)
    raise "can not deserialize #{filename} " unless File.exists?(filename)
    klass, opts, block = nil, nil, nil

    File.open(filename) do  |f|
      klass = f.readline.chomp
      opts = JSON.parse(f.readline.chomp)
      opts.symbolize_keys!
      block = f.readlines.join("\n")
    end

    require "#{klass.underscore}"

    obj = Object.const_get(klass).new(opts)
    obj.gnu_parallel_block = block
    return obj
  end
  module_function :deserialize_obj

  def self.included(base)
    base.class_eval do

    # TODO
    # p_stream is a map function, but requires you explcitly open the stream
    #  if gnu_parallel exists then do below
    #  otherwise use normal streaming
      def p_stream(source=nil, header = true, &block)
        
        # expects GNU parallel to be in your path
        #gnu_parallel = "#{ENV['GNU_PARALLEL']}"
        gnu_parallel ||= `which parallel`
        gnu_parallel.chomp!

       # if valid(gnu_parallel) then
          src_dir  = File.expand_path File.dirname __FILE__
          bin_dir = src_dir.gsub(/lib$/,"bin")
       
          
          klass = self.class
          filename = serialize_obj(klass,@opts,block)

        
          cmd =  " #{gnu_parallel} --pipe "
          cmd += " --header " if header
          
          # parallel scripts need to be on the ruby load path
          # or specify some path variable or the Ruby Load Path itself
          
          #TODO problem if path contains whitespace
          #  how fix?
          #   CRAP
          cmd += "ruby  #{bin_dir}/gnu_parallel_runner.rb #{filename} "
            
          # souce = :stdin   or   :file=""   or   :files=[]
          # if source==:stdin then
          #   ...
          cmd = "cat #{source} | #{cmd}" if source.class == String
       
          
          system(cmd)

          # cleanup
          FileUtils.rm(filename)


        # else
        # # run in exactly the same way to be safe
          # cmd = "cat #{source} |"
          # cmd += ruby #{src_dir}/gnu_parallel_runner.rb -f #{filename} "
          # system(cmd)
        # end
      end

      def p_call
         instance_eval(@gnu_parallel_block).call 
      end

      # See GnuParallelRunner for deserialoze_obj
      def serialize_obj(klass,opts,block)
        # get unique name
        timestamp = Time.now.to_i

        # later this can push directly to redis
        filename = "gnu_parallel_obj.#{self.class}.#{timestamp}.json"

        File.open(filename, "w") do |f|
          f << klass << "\n"
          f << opts.to_json << "\n"
          f << block.to_source << "\n"
        end
        return filename
      end

    end
  end

  # Instance Methods
  def gnu_parallel_block
    @gnu_parallel_block ||= nil
  end

  def gnu_parallel_block=(v)
    @gnu_parallel_block=v
  end

end

