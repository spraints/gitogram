$: << File.expand_path('rugged/lib', File.dirname(__FILE__))

def main
  require 'rugged'

  path = ARGV.first || '.'
  repo = Rugged::Repository.new(path)
  File.open 'values.js', 'w' do |f|
    f.puts "var PATH = #{path.inspect};"
    f << 'var VALUES = ['
    comma = ','
    sep = ''
    biggest = Bigness.new
    repo.each_id do |oid|
      size = repo.read(oid).len
      biggest.add(oid, size)
      f << sep
      f << size
      sep = comma
    end
    f.puts '];'
    f.puts "var MAX = #{biggest.max_size};"
    f.puts "var BIGS = [ #{biggest.map { |x| "{ oid: \"#{x.oid}\", size: #{x.size} }" }.join(', ')} ];"
  end
end

class Bigness
  include Enumerable

  Count = 50

  def add(oid, size)
    if values.size < Count
      values << Info.new(oid, size)
    elsif values.first.size < size
      values.shift
      values << Info.new(oid, size)
    else
      return
    end
    values.sort_by! { |x| x.size }
  end

  def max_size
    values.map { |x| x.size }.inject { |a, b| a > b ? a : b }
  end

  def each(&block)
    values.reverse.each(&block)
  end

  def values
    @values ||= []
  end
end

class Info
  def initialize(oid, size)
    @oid  = oid
    @size = size
  end
  attr_reader :oid, :size
end


begin
  main
rescue LoadError
  cmd = 'git submodule update --init --recursive'
  puts "$ #{cmd}" ; system cmd

  Dir.chdir 'rugged' do
    cmd = 'bundle install --path .bundle/gems'
    puts "$ #{cmd}" ; system cmd

    cmd = 'bundle exec rake compile'
    puts "$ #{cmd}" ; system cmd
  end

  main
end
