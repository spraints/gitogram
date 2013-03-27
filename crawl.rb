$: << File.expand_path('rugged/lib', File.dirname(__FILE__))

def main
  require 'rugged'

  path = ARGV.first || '.'
  repo = Rugged::Repository.new(path)
  repo.each_id do |oid|
    puts repo.read(oid).len
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
