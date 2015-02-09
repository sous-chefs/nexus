#!/usr/bin/env ruby
# ^syntax detection

require 'finstyle'

guard :rubocop, :keep_failed => false, :cli => '-r finstyle' do
  watch(%r{.+\.rb$}) { |m| m[0] }
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard 'foodcritic', :cookbook_paths => '.', :cli => '-C -t ~FC001' do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
end

guard 'rspec', :cmd => 'bundle exec rspec', :spec_paths => ['test/unit'], :all_on_start => true do
  watch(%r{^test/unit/.+_spec\.rb$})
  watch('test/unit/spec_helper.rb')  { 'test/unit' }
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) { |m| "test/unit/#{m[2]}_spec.rb"  }
end
