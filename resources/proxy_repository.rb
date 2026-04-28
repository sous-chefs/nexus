# frozen_string_literal: true

provides :nexus_proxy_repository
unified_mode true
use '_partial/_api'
use '_partial/_repository'

property :url, String,
         required: true,
         description: 'Remote repository URL.'

property :subscriber, [true, false, nil],
         default: nil,
         description: 'Whether artifact subscription is enabled for the repository.'

property :preemptive_fetch, [true, false],
         default: false,
         description: 'Whether preemptive fetching is enabled for artifact subscription.'

action :create do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  unless repository_exists?(config, new_resource.name)
    converge_by "create Nexus proxy repository #{new_resource.name}" do
      nexus_client(config).create_repository(new_resource.name, true, new_resource.url, nil, new_resource.policy, nil)
    end
  end

  update_publisher(config) unless new_resource.publisher.nil?
  update_subscriber(config) unless new_resource.subscriber.nil?
end

action :update do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless repository_exists?(config, new_resource.name)

  update_publisher(config) unless new_resource.publisher.nil?
  update_subscriber(config) unless new_resource.subscriber.nil?
end

action :delete do
  install_nexus_cli
  config = nexus_config(new_resource.config)
  ensure_nexus_service_available(config)

  next unless repository_exists?(config, new_resource.name)

  converge_by "delete Nexus proxy repository #{new_resource.name}" do
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

  def update_subscriber(config)
    parsed_id = nexus_identifier(new_resource.name)

    converge_by "#{new_resource.subscriber ? 'enable' : 'disable'} artifact subscription for #{new_resource.name}" do
      if new_resource.subscriber
        nexus_client(config).enable_artifact_subscribe(parsed_id, new_resource.preemptive_fetch)
      else
        nexus_client(config).disable_artifact_subscribe(parsed_id, new_resource.preemptive_fetch)
      end
    end
  end
end
