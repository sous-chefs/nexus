require_relative 'spec_helper'

describe 'nexus::default' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.node.set[:runit][:sv_bin] = '/usr/bin/sv'
    runner.converge(described_recipe)
  end

  nexus_home = '/usr/local/nexus'

  it 'installs the nexus_cli gem' do
    expect(chef_run).to install_chef_gem('nexus_cli')
  end

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

  it 'creates jetty.xml' do
    expect(chef_run).to create_template(::File.join(nexus_home, 'conf', 'jetty.xml')).with(
      :user => 'nexus',
      :group => 'nexus',
      :mode => 0775
    )
  end

  it 'should include the runit cookbook' do
    expect(chef_run).to include_recipe('runit')
  end

  it 'enables and start nexus service' do
    expect(chef_run).to enable_runit_service('nexus')
    expect(chef_run).to start_runit_service('nexus')
  end

end
