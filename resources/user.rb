unified_mode true

property :username, String, name_property: true
property :first_name, String
property :last_name, String
property :email, String
property :enabled, [true, false]
property :password, String
property :old_password, String
property :roles, Array, default: []
property :config, Hash, default: {}

def load_current_resource
#   puts new_resource.username
#   puts new_resource
#   @current_resource = Chef::Resource::NexusUser.new(new_resource.username)
#   puts @current_resource
  @config = new_resource.config
#   puts @config

#   run_context.include_recipe 'nexus::cli'
#   Chef::Nexus.ensure_service_available(@config)
#   @current_resource
end

action :create do
  unless user_exists?(new_resource.username)
    u = create_user
    new_resource.updated_by_last_action(u)
  end
end

action :update do
  # if user_exists?(@current_resource.username)
  #   u = update_user
  #   new_resource.updated_by_last_action(u)
  # end
end

action :delete do
  # if user_exists?(@current_resource.username)
  #   u = delete_user
  #   new_resource.updated_by_last_action(u)
  # end
end

action_class do
  def user_exists?(username)
    Chef::Nexus.nexus(@config).get_user(username)
    true
  rescue NexusCli::UserNotFoundException
    false
  end

  def create_user
    validate_create_user
    Chef::Nexus.nexus(@config).create_user(params)
  end

  def delete_user
    Chef::Nexus.nexus(@config).delete_user(new_resource.username)
  end

  def update_user
    Chef::Nexus.nexus(@config).update_user(params(true))
  end

  def validate_create_user
    raise('nexus_user create requires an email address.') if new_resource.email.nil?

    raise('nexus_user create requires a enabled.') if new_resource.enabled.nil?

    raise('nexus_user create requires at least one role.') if new_resource.roles.nil? || new_resource.roles.empty?
  end

  def params(update = false)
    params = { userId: new_resource.username }
    params['firstName'] = new_resource.first_name
    params['lastName'] = new_resource.last_name
    params['email'] = new_resource.email
    params['status'] = if new_resource.enabled.nil? && update
                         nil
                       else
                         new_resource.enabled == true ? 'active' : 'disabled'
                       end
    params['password'] = new_resource.password
    params['roles'] = new_resource.roles
    params
  end

  def password_params
    params = { userId: new_resource.username }
    params['oldPassword'] = new_resource.old_password
    params['newPassword'] = new_resource.password
    params
  end
end
