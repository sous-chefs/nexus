#
# Cookbook Name:: nexus_test
# Recipe:: default
#

include_recipe 'nexus'

nexus_user 'testuser' do
  action :create
end
