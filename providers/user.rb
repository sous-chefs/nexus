def load_current_resource
  @current_resource = Chef::Resource::NexusUser.new(new_resource.username)
  @config = Chef::Nexus.merge_config(node, new_resource.config)

  run_context.include_recipe 'nexus::cli'
  Chef::Nexus.ensure_service_available(@config)
  @current_resource
end

action :create do
  unless user_exists?(@current_resource.username)
    u = create_user
    new_resource.updated_by_last_action(u)
  end
end

action :update do
  if user_exists?(@current_resource.username)
    u = update_user
    new_resource.updated_by_last_action(u)
  end
end

action :delete do
  if user_exists?(@current_resource.username)
    u = delete_user
    new_resource.updated_by_last_action(u)
  end
end

private

def user_exists?(username)
  Chef::Nexus.nexus(@config).get_user(username)
  true
rescue NexusCli::UserNotFoundException
  return false
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
  Chef::Application.fatal!(
    'nexus_user create requires an email address.'
  ) if new_resource.email.nil?

  Chef::Application.fatal!(
    'nexus_user create requires a enabled.'
  ) if new_resource.enabled.nil?

  Chef::Application.fatal!(
    'nexus_user create requires at least one role.'
  ) if new_resource.roles.nil? || new_resource.roles.empty?
end

def params(update = false)
  params = { userId: new_resource.username }
  params[:firstName] = new_resource.first_name
  params[:lastName] = new_resource.last_name
  params[:email] = new_resource.email
  params[:status] = if new_resource.enabled.nil? && update
                      nil
                    else
                      new_resource.enabled == true ? 'active' : 'disabled'
                    end
  params[:password] = new_resource.password
  params[:roles] = new_resource.roles
  params
end

def password_params
  params = { userId: new_resource.username }
  params['oldPassword'] = new_resource.old_password
  params['newPassword'] = new_resource.password
  params
end
