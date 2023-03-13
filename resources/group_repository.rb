unified_mode true

property :repository, String
property :config, Hash, default: {}

def load_current_resource
  @current_resource = Chef::Resource::NexusGroupRepository.new(new_resource.name)
  @config = Chef::Nexus.merge_config(node, new_resource.config)

  run_context.include_recipe 'nexus::cli'
  Chef::Nexus.ensure_service_available(@config)

  @parsed_id = Chef::Nexus.parse_identifier(new_resource.name)

  unless new_resource.repository.nil?
    @parsed_repository = Chef::Nexus.parse_identifier(new_resource.repository)
  end

  @current_resource.repository @parsed_repository

  @current_resource
end

action :create do
  unless group_repository_exists?(@current_resource.name)
    r = Chef::Nexus.nexus(@config).create_group_repository(
      new_resource.name, nil, nil
    )
    new_resource.updated_by_last_action(r)
  end
end

action :delete do
  if group_repository_exists?(@current_resource.name)
    r = Chef::Nexus.nexus(node).delete_group_repository(@parsed_id)
    new_resource.updated_by_last_action(r)
  end
end

action :add_to do
  unless repository_in_group?(@current_resource.name, @current_resource.repository)
    r = Chef::Nexus.nexus(@config).add_to_group_repository(@parsed_id, @parsed_repository)
    new_resource.updated_by_last_action(r)
  end
end

action :remove_from do
  if repository_in_group?(@current_resource.name, @current_resource.repository)
    r = Chef::Nexus.nexus(@config).remove_from_group_repository(
      @parsed_id, @parsed_repository
    )
    new_resource.updated_by_last_action(r)
  end
end

action_class do
  def group_repository_exists?(name)
    Chef::Nexus.nexus(@config).get_group_repository(name)
    true
  rescue NexusCli::RepositoryNotFoundException
    false
  end

  def repository_in_group?(repository_name, repository_to_check)
    Chef::Nexus.nexus(@config).repository_in_group?(repository_name, repository_to_check)
  end
end
