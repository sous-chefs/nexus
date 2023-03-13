unified_mode true

property :url, String, required: true
property :policy, String
property :publisher, [true, false]
property :subscriber, [true, false]
property :preemptive_fetch, [true, false], default: false
property :config, Hash, default: {}

def load_current_resource
  @current_resource = Chef::Resource::NexusProxyRepository.new(new_resource.name)
  @config = Chef::Nexus.merge_config(node, new_resource.config)

  run_context.include_recipe 'nexus::cli'
  Chef::Nexus.ensure_service_available(@config)

  @parsed_id = Chef::Nexus.parse_identifier(new_resource.name)

  @current_resource
end

action :create do
  unless repository_exists?(@current_resource.name)
    proxy = true
    url = new_resource.url
    id = nil
    policy = new_resource.policy
    provider = nil
    Chef::Nexus.nexus(@config).create_repository(
      new_resource.name, proxy, url, id, policy, provider
    )
    set_publisher if new_resource.publisher
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  if repository_exists?(@current_resource.name)
    Chef::Nexus.nexus(@config).delete_repository(@parsed_id)
    new_resource.updated_by_last_action(true)
  end
end

action :update do
  if repository_exists?(@current_resource.name)
    if new_resource.publisher
      set_publisher
    elsif new_resource.publisher == false
      unset_publisher
    end
    new_resource.updated_by_last_action(true)
  end
end

action_class do
  def repository_exists?(name)
    Chef::Nexus.nexus(@config).get_repository_info(name)
    true
  rescue NexusCli::RepositoryNotFoundException
    false
  end

  def set_publisher
    Chef::Nexus.nexus(@config).enable_artifact_publish(@parsed_id)
  end

  def unset_publisher
    Chef::Nexus.nexus(@config).disable_artifact_publish(@parsed_id)
  end

  def set_subscriber
    Chef::Nexus.nexus(@config).enable_artifact_subscribe(@parsed_id, new_resource.preemptive_fetch)
  end

  def unset_subscriber
    Chef::Nexus.nexus(@config).disable_artifact_subscribe(@parsed_id, new_resource.preemptive_fetch)
  end
end
