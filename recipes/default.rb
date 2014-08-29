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

chef_gem 'nexus_cli' do
  version '4.1.0'
end

group node[:nexus][:group] do
  system true
end

user node[:nexus][:user] do
  gid node[:nexus][:group]
  shell '/bin/bash'
  home node[:nexus][:home]
  system true
end

ark 'nexus' do
  url 'http://www.sonatype.org/downloads/nexus-2.9.0-bundle.tar.gz'
  version '2.9.0-04'
  path node[:nexus][:home]
  strip_components 1
  checksum '0025c478a9ad4b3e0c8a31ebebe0001873a41a7716113a3802eef55ce516e19a'
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
    :nexus_port => '8080',
    :nexus_host => '0.0.0.0',
    :nexus_context_path => '/nexus',
    :work_dir => ::File.join(node[:nexus][:home], 'work')
  )
end

template ::File.join(node[:nexus][:home], 'conf', 'jetty.xml') do
  source 'jetty.xml.erb'
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode 0775
  variables(:loopback => true)
end

runit_service 'nexus' do
  default_logger true
  options(
    :nexus_user => node[:nexus][:user]
  )
  action [:enable, :start]
end
