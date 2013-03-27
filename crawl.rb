$: << File.expand_path('rugged/lib', File.dirname(__FILE__))

def main
  require 'rugged'

  path = ARGV.first || '.'
  repo = Rugged::Repository.new(path)
  File.open 'values.js', 'w' do |f|
    f.puts 'window.gitData = {'
    f.puts "  path: #{path.inspect},"
    f << ' sizes: ['
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
    f.puts '],'
    f.puts "  max: #{biggest.max_size},"
    biggest.find_in(repo)
    f.puts "  top: [ #{biggest.map { |x| "{ oid: \"#{x.oid}\", size: #{x.size}, path: \"#{x.path}\" }" }.join(', ')} ]"
    f.puts '};'
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

  def find_in(repo)
    objs = values.each_with_object({}) { |obj, res| res[obj.oid] = obj }
    walker = Rugged::Walker.new(repo)
    walker.push(repo.head.target)
    n = 0
    start = Time.now
    walker.each do |commit|
      n += 1
      commit.tree.walk(:preorder) do |root, entry|
        if obj = objs.delete(entry[:oid])
          obj.path = root + entry[:name]
        end
      end
      break if objs.empty? || (n > 100 && (Time.now - start) > 30)
    end
  end
end

class Info
  def initialize(oid, size)
    @oid  = oid
    @size = size
  end
  attr_reader :oid, :size
  attr_accessor :path
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
