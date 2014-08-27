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

rspec_opts = '--color --format progress'

guard 'rspec', :cmd => "bundle exec rspec #{rspec_opts}", :all_on_start => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { 'spec' }
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) { |m| "spec/#{m[2]}_spec.rb"  }
end
