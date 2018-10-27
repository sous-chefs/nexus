require 'spec_helper'

describe 'Default recipe on Ubuntu 12.04' do
  let(:runner) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '12.04') }

  it 'converges successfully' do
    expect { :chef_run }.to_not raise_error
  end
end
