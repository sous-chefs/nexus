#
# Cookbook Name:: nexus
# Library:: chef_nexus
#
# Author:: Kyle Allan (<kallan@riotgames.com>)
# Author:: Heavy Water Operations LLC (<support@hw-ops.com>)
# Copyright 2013, Riot Games
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
class Chef
  module Nexus
    class << self
      # Creates and returns an instance of a NexusCli::RemoteFactory that
      # will be authenticated with the info inside the credentials data bag
      # item.
      #
      # @param config [Hash] a configuration hash for the connection
      #
      # @return [NexusCli::RemoteFactory] a connection to a Nexus server

      def nexus(config)
        require 'nexus_cli'
        connection_config = {
          'url' => config['url'],
          'repository' => config['repository'],
          'username' => config['username'],
          'password' => config['password'],
        }
        NexusCli::RemoteFactory.create(connection_config, config[:ssl_verify])
      end

      # Generates the URL for a nexus instance
      # @param override_config [Hash]
      # @param node [Chef::Node]
      #
      # @return [String]

      def default_url(node, override_config = {})
        require 'uri'
        url = {
          scheme: 'http',
          host: 'localhost',
          port: node['nexus']['port'],
          path: node['nexus']['context_path'],
        }
        url.merge!(override_config)
        URI::Generic.build(url).to_s
      end

      # Merges provided configuration with defaults, returning the config
      # as a Mash.
      # @param override_config a hash of default configuration overrides
      #
      # @return [Mash] hash of configuration values for the nexus connection
      def merge_config(node, override_config = {})
        default_config = Mash.new(
          url: default_url(node, override_config),
          username: 'admin',
          password: 'admin123',
          retries: 10,
          retry_delay: 10
        )

        default_config.merge(override_config)
      end

      # Checks to ensure the Nexus server is available. When
      # it is unavailable, the Chef run is failed. Otherwise
      # the Chef run continues.
      #
      # @param  config [Hash] a configuration hash for the connection
      #
      # @return [NilClass]
      def ensure_service_available(config)
        Chef::Application.fatal!(
          'Could not connect to Nexus. Please ensure Nexus is running.'
        ) unless Chef::Nexus.service_available?(config)
      end

      # Attempts to connect to the Nexus and retries if a connection
      # cannot be made.
      #
      # @param  config [Hash] a configuration hash for the connection
      #
      # @return [Boolean] true if a connection could be made, false otherwise
      def service_available?(config)
        retries = config[:retries]
        retry_delay = config[:retry_delay]
        begin
          remote = anonymous_nexus_remote(config)
          return remote.status['state'] == 'STARTED'
        rescue Errno::ECONNREFUSED, NexusCli::CouldNotConnectToNexusException, \
               NexusCli::UnexpectedStatusCodeException => e
          if retries > 0
            retries -= 1
            Chef::Log.info "Could not connect to Nexus, #{retries} attempt(s) left"
            Chef::Log.info "Nexus error: #{e.inspect}"
            sleep retry_delay
            retry
          end
          false
        end
      end

      # Returns a 'safe-for-Nexus' identifier by replacing
      # spaces with underscores and downcasing the entire
      # String.
      #
      # @param  nexus_identifier [String] a Nexus identifier
      #
      # @example
      #   Chef::Nexus.parse_identifier("Artifacts Repository") => "artifacts_repository"
      #
      # @return [String] a safe-for-Nexus version of the identifier
      def parse_identifier(nexus_identifier)
        nexus_identifier.tr(' ', '_').downcase
      end

      def decode(value)
        require 'base64'
        Base64.decode64(value)
      end

      private

      # Creates a new instance of a Nexus connection using only
      # the URL to the local server. This connection is anonymous.
      #
      # @param  config [Hash] a configuration hash for the connection
      #
      # @return [NexusCli::BaseRemote] a NexusCli remote class
      def anonymous_nexus_remote(config)
        require 'nexus_cli'

        NexusCli::RemoteFactory.create(
          { 'url' => config[:url] },
          config[:ssl_verify]
        )
      end
    end
  end
end
