def load_current_resource
  @config = {
    :url => 'http://localhost:8080/nexus',
    :ssl_verify => true,
    :retries => 5,
    :retry_delay => 5,
    :repository => 'releases',
    :username => 'admin',
    :password => 'admin123'
  }

  @current_resource = Chef::Resource::NexusUser.new(new_resource.username)
  Chef::Nexus.ensure_nexus_available(@config)

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
  Chef::Nexus.nexus(@config).create_user(get_params)
end

def delete_user
  Chef::Nexus.nexus(@config).delete_user(new_resource.username)
end

def update_user
  Chef::Nexus.nexus(@config).update_user(get_params(true))
end

def validate_create_user
  Chef::Application.fatal!('nexus_user create requires an email address.', 1) if new_resource.email.nil?
  Chef::Application.fatal!('nexus_user create requires a enabled.', 1) if new_resource.enabled.nil?
  Chef::Application.fatal!('nexus_user create requires at least one role.', 1) if new_resource.roles.nil? || new_resource.roles.empty?
end

def get_params(update = false)
  params = { :userId => new_resource.username }
  params[:firstName] = new_resource.first_name
  params[:lastName] = new_resource.last_name
  params[:email] = new_resource.email
  if new_resource.enabled.nil? && update
    params[:status] = nil
  else
    params[:status] = new_resource.enabled == true ? 'active' : 'disabled'
  end
  params[:password] = new_resource.password
  params[:roles] = new_resource.roles
  params
end
