# frozen_string_literal: true

require_relative '../spec_helper'

describe 'nexus_install' do
  subject(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '22.04', step_into: ['nexus_install'])
                        .converge('test::default')
  end

  it 'creates the nexus group' do
    expect(chef_run).to create_group('nexus').with(system: true)
  end

  it 'creates the nexus user' do
    expect(chef_run).to create_user('nexus').with(
      gid: 'nexus',
      shell: '/bin/bash',
      home: '/usr/local/nexus',
      system: true
    )
  end

  it 'installs nexus with ark' do
    expect(chef_run).to install_ark('nexus')
  end

  it 'renders nexus.properties' do
    expect(chef_run).to create_template('/usr/local/nexus/conf/nexus.properties').with(
      owner: 'nexus',
      group: 'nexus',
      mode: '0775'
    )
  end

  it 'creates the systemd unit' do
    expect(chef_run).to create_systemd_unit('nexus.service')
  end

  it 'enables the service' do
    expect(chef_run).to enable_service('nexus')
  end
end
