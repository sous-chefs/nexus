#
# Cookbook:: nexus_test
# Recipe:: default
#

include_recipe 'nexus'

nexus_user 'testuser' do
  email 'user@example.com'
  password 'secret'
  enabled true
  roles ['wonderland']
  action :create
end

nexus_user 'testuser' do
  email 'bob@example.com'
  action :update
end

nexus_hosted_repository 'free_software' do
  publisher false
  policy 'RELEASE'
end

nexus_proxy_repository 'java-dot-net' do
  url 'https://maven.java.net/content/repositories/snapshots/'
  subscriber true
  publisher false
  policy 'SNAPSHOT'
end

nexus_group_repository 'chef-managed' do
  action :create
end

%w( free_software java-dot-net ).each do |r|
  nexus_group_repository 'chef-managed' do
    repository r
    action :add_to
  end
end
