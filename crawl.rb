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
    max = 0
    repo.each_id do |oid|
      size = repo.read(oid).len
      max = size if size > max
      f << sep
      f << size
      sep = comma
    end
    f.puts '];'
    f.puts "var MAX = #{max};"
  end
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
