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

group node[:nexus][:group] do
  system true
end

user node[:nexus][:user] do
  gid node[:nexus][:group]
  shell '/bin/bash'
  home node[:nexus][:home]
  system true
end

directory node[:nexus][:home] do
  owner node[:nexus][:user]
  group node[:nexus][:group]
  recursive true
  mode 0775
end

%w(bin conf logs pid tmp work).each do |dir|
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
end

template ::File.join(node[:nexus][:home], 'conf', 'jetty.xml') do
  source 'jetty.xml.erb'
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode 0775
end

template ::File.join(node[:nexus][:home], 'bin', 'nexus') do
  source 'nexus.erb'
  owner node[:nexus][:user]
  group node[:nexus][:group]
  mode 0775
end

link '/etc/init.d/nexus' do
  to ::File.join(node[:nexus][:home], 'bin', 'nexus')
end

service 'nexus' do
  action [:enable, :start]
end
