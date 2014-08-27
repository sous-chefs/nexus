require 'spec_helper'

describe 'nexus::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  nexus_home = '/opt/nexus'

  it 'creates nexus group' do
    expect(chef_run).to create_group('nexus').with(:system => true)
  end

  it 'creates nexus user' do
    expect(chef_run).to create_user('nexus').with(
      :system => true,
      :gid => 'nexus',
      :shell => '/bin/bash',
      :home => nexus_home
    )
  end

  it 'creates nexus home directory' do
    expect(chef_run).to create_directory(nexus_home).with(
      :user => 'nexus',
      :group => 'nexus',
      :mode => 0775
    )
  end

  %w( bin conf logs pid tmp work ).each do |dir|
    it "creates nexus #{dir} directory" do
      expect(chef_run).to create_directory(::File.join(nexus_home, dir))
    end
  end

  it 'creates nexus.properties' do
    expect(chef_run).to create_template(::File.join(nexus_home, 'conf', 'nexus.properties')).with(
      :user => 'nexus',
      :group => 'nexus',
      :mode => 0775
    )
  end

  it 'creates nexus init script' do
    expect(chef_run).to create_template(::File.join(nexus_home, 'bin', 'nexus')).with(
      :user => 'nexus',
      :group => 'nexus',
      :mode => 0775
    )
  end

  it 'links /etc/init.d/nexus to nexus init script' do
    link = chef_run.link('/etc/init.d/nexus')
    expect(link).to link_to(::File.join(nexus_home, 'bin', 'nexus'))
  end

  it 'creates jetty.xml' do
    expect(chef_run).to create_template(::File.join(nexus_home, 'conf', 'jetty.xml')).with(
      :user => 'nexus',
      :group => 'nexus',
      :mode => 0775
    )
  end

  it 'enables and start nexus service' do
    expect(chef_run).to enable_service('nexus')
    expect(chef_run).to start_service('nexus')
  end

end
