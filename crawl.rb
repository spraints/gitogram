$: << File.expand_path('rugged/lib', File.dirname(__FILE__))

require 'rugged'

path = ARGV.first || '.'
repo = Rugged::Repository.new(path)
repo.each_id do |oid|
  puts repo.read(oid).len
end
