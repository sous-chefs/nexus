# frozen_string_literal: true

require_relative '../spec_helper'

describe 'nexus_group_repository' do
  let(:client) { instance_double('NexusClient') }

  before do
    stub_nexus_cli(client)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:ensure_nexus_service_available)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_anonymous_client).and_return(instance_double('NexusAnonymousClient', status: { 'state' => 'STARTED' }))
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_client).and_return(client)
  end

  it 'adds a repository to a group' do
    allow(client).to receive(:repository_in_group?).with('public', 'central').and_return(false)
    allow(client).to receive(:add_to_group_repository)

    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nexus_group_repository'])
                        .converge('test::group_repository_add')

    expect(client).to have_received(:add_to_group_repository).with('public', 'central')
  end
end
