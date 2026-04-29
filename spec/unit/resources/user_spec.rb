# frozen_string_literal: true

require_relative '../spec_helper'

describe 'nexus_user' do
  let(:client) { instance_double('NexusClient') }

  before do
    stub_nexus_cli(client)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:ensure_nexus_service_available)
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_anonymous_client).and_return(instance_double('NexusAnonymousClient', status: { 'state' => 'STARTED' }))
    allow_any_instance_of(NexusCookbook::Helpers).to receive(:nexus_client).and_return(client)
  end

  it 'creates a missing user' do
    allow(client).to receive(:get_user).with('testuser').and_raise(NexusCli::UserNotFoundException)
    allow(client).to receive(:create_user)

    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nexus_user'])
                        .converge('test::user_create')

    expect(client).to have_received(:create_user).with(hash_including(userId: 'testuser'))
  end

  it 'deletes an existing user' do
    allow(client).to receive(:get_user).with('testuser').and_return(true)
    allow(client).to receive(:delete_user)

    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nexus_user'])
                        .converge('test::user_delete')

    expect(client).to have_received(:delete_user).with('testuser')
  end
end
