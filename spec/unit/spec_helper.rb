# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../support', __dir__))

require 'chefspec'
require 'chefspec/berkshelf'
require 'nexus_cli'

def stub_nexus_cli(client)
  allow(NexusCli::RemoteFactory).to receive(:create).and_return(client)
end
