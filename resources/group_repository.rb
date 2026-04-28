# frozen_string_literal: true

provides :nexus_group_repository
unified_mode true
use '_partial/_api'

property :repository, String,
         description: 'Repository to add to or remove from the group.'

action :create do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next if group_repository_exists?(config, new_resource.name)

  converge_by "create Nexus group repository #{new_resource.name}" do
    nexus_client(config).create_group_repository(new_resource.name, nil, nil)
  end
end

action :delete do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless group_repository_exists?(config, new_resource.name)

  converge_by "delete Nexus group repository #{new_resource.name}" do
    nexus_client(config).delete_group_repository(nexus_identifier(new_resource.name))
  end
end

action :add_to do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)
  validate_repository_property!

  next if repository_in_group?(config)

  converge_by "add #{new_resource.repository} to Nexus group repository #{new_resource.name}" do
    nexus_client(config).add_to_group_repository(
      nexus_identifier(new_resource.name),
      nexus_identifier(new_resource.repository)
    )
  end
end

action :remove_from do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)
  validate_repository_property!

  next unless repository_in_group?(config)

  converge_by "remove #{new_resource.repository} from Nexus group repository #{new_resource.name}" do
    nexus_client(config).remove_from_group_repository(
      nexus_identifier(new_resource.name),
      nexus_identifier(new_resource.repository)
    )
  end
end

action_class do
  include NexusCookbook::Helpers

  def install_nexus_cli
    chef_gem 'nexus_cli' do
      version '4.1.0'
    end
  end

  def group_repository_exists?(config, name)
    nexus_client(config).get_group_repository(name)
    true
  rescue NexusCli::RepositoryNotFoundException
    false
  end

  def repository_in_group?(config)
    nexus_client(config).repository_in_group?(
      nexus_identifier(new_resource.name),
      nexus_identifier(new_resource.repository)
    )
  end

  def validate_repository_property!
    raise 'nexus_group_repository requires a repository for add_to and remove_from actions.' if new_resource.repository.nil?
  end
end
