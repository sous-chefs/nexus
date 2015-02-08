#
# Author:: Heavy Water Operations LLC <support@hw-ops.com>
#
# Copyright 2014, Heavy Water Operations LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'ark'
include_recipe 'java'
include_recipe 'runit'
include_recipe 'nexus::cli'
include_recipe 'nexus::manage_user'

ark 'nexus' do
  url node[:nexus][:download_url] % { :version => node[:nexus][:version] }
  version node[:nexus][:version]
  path node[:nexus][:home]
  strip_components 1
  checksum node[:nexus][:download_sha256_checksum]
  owner node[:nexus][:user]
  action :install
end

%w(
  bin
  conf
  logs
  pid
  tmp
  work
).each do |dir|
  directory ::File.join(node[:nexus][:home], dir) do
    owner node[:nexus][:user]
    group node[:nexus][:group]
  end
end

template ::File.join(node[:nexus][:home], 'conf', 'nexus.properties') do
  source 'nexus.properties.erb'
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode 0775
  variables(
    :nexus_port => node[:nexus][:port],
    :nexus_host => '0.0.0.0',
    :nexus_context_path => node[:nexus][:context_path],
    :work_dir => node[:nexus][:work_dir]
  )
end

template ::File.join(node[:nexus][:home], 'conf', 'jetty.xml') do
  source 'jetty.xml.erb'
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode 0775
  variables(:loopback => node[:nexus][:loopback_only])
end

runit_service 'nexus' do
  default_logger true
  options(
    :nexus_user => node[:nexus][:user]
  )
  action [:enable, :start]
end

ruby_block 'wait until nexus ready' do
  block do
    config = Chef::Nexus.merge_config({}, node)
    Chef::Nexus.ensure_service_available(config)
  end
end
