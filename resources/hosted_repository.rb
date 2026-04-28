# frozen_string_literal: true

provides :nexus_hosted_repository
unified_mode true
use '_partial/_api'
use '_partial/_repository'

action :create do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  unless repository_exists?(config, new_resource.name)
    converge_by "create Nexus hosted repository #{new_resource.name}" do
      nexus_client(config).create_repository(new_resource.name, false, nil, nil, new_resource.policy, nil)
    end
  end

  update_publisher(config) unless new_resource.publisher.nil?
end

action :update do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless repository_exists?(config, new_resource.name)

  update_publisher(config) unless new_resource.publisher.nil?
end

action :delete do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless repository_exists?(config, new_resource.name)

  converge_by "delete Nexus hosted repository #{new_resource.name}" do
    nexus_client(config).delete_repository(nexus_identifier(new_resource.name))
  end
end

action_class do
  include NexusCookbook::Helpers

  def install_nexus_cli
    chef_gem 'nexus_cli' do
      version '4.1.0'
    end
  end

  def repository_exists?(config, name)
    nexus_client(config).get_repository_info(name)
    true
  rescue NexusCli::RepositoryNotFoundException
    false
  end

  def update_publisher(config)
    parsed_id = nexus_identifier(new_resource.name)

    converge_by "#{new_resource.publisher ? 'enable' : 'disable'} artifact publishing for #{new_resource.name}" do
      if new_resource.publisher
        nexus_client(config).enable_artifact_publish(parsed_id)
      else
        nexus_client(config).disable_artifact_publish(parsed_id)
      end
    end
  end
end
