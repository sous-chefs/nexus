# frozen_string_literal: true

provides :nexus_user
unified_mode true
use '_partial/_api'

property :username, String,
         name_property: true,
         description: 'Nexus user name.'

property :first_name, String,
         description: 'Nexus user first name.'

property :last_name, String,
         description: 'Nexus user last name.'

property :email, String,
         description: 'Nexus user email address.'

property :enabled, [true, false, nil],
         default: nil,
         description: 'Whether the Nexus user is enabled.'

property :password, String,
         sensitive: true,
         description: 'Nexus user password.'

property :old_password, String,
         sensitive: true,
         description: 'Existing password when changing password.'

property :roles, Array,
         default: [],
         description: 'Nexus roles assigned to the user.'

action :create do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next if user_exists?(config, new_resource.username)

  validate_create_user!

  converge_by "create Nexus user #{new_resource.username}" do
    nexus_client(config).create_user(user_params)
  end
end

action :update do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless user_exists?(config, new_resource.username)

  converge_by "update Nexus user #{new_resource.username}" do
    nexus_client(config).update_user(user_params(true))
  end
end

action :delete do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless user_exists?(config, new_resource.username)

  converge_by "delete Nexus user #{new_resource.username}" do
    nexus_client(config).delete_user(new_resource.username)
  end
end

action_class do
  include NexusCookbook::Helpers

  def install_nexus_cli
    chef_gem 'nexus_cli' do
      version '4.1.0'
    end
  end

  def user_exists?(config, username)
    nexus_client(config).get_user(username)
    true
  rescue NexusCli::UserNotFoundException
    false
  end

  def validate_create_user!
    raise 'nexus_user create requires an email address.' if new_resource.email.nil?
    raise 'nexus_user create requires an enabled value.' if new_resource.enabled.nil?
    raise 'nexus_user create requires at least one role.' if new_resource.roles.empty?
  end

  def user_params(update = false)
    {
      userId: new_resource.username,
      firstName: new_resource.first_name,
      lastName: new_resource.last_name,
      email: new_resource.email,
      status: user_status(update),
      password: new_resource.password,
      roles: new_resource.roles,
    }
  end

  def user_status(update)
    return if new_resource.enabled.nil? && update

    new_resource.enabled ? 'active' : 'disabled'
  end
end
