# frozen_string_literal: true

require_relative '../spec_helper'

describe 'nexus_proxy_repository' do
  let(:client) { instance_double('NexusClient') }

  before do
    stub_nexus_cli(client)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:ensure_nexus_service_available)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_anonymous_client).and_return(instance_double('NexusAnonymousClient', status: { 'state' => 'STARTED' }))
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_client).and_return(client)
  end

  it 'creates a missing proxy repository' do
    allow(client).to receive(:get_repository_info).with('central').and_raise(NexusCli::RepositoryNotFoundException)
    allow(client).to receive(:create_repository)

    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nexus_proxy_repository'])
                        .converge('test::proxy_repository')

    expect(client).to have_received(:create_repository).with('central', true, 'https://repo1.maven.org/maven2/', nil, 'RELEASE', nil)
  end
end
