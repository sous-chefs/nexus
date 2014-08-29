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
      # @param  node [Chef::Node] the node
      #
      # @return [NexusCli::RemoteFactory] a connection to a Nexus server

      def nexus(config)
        require 'nexus_cli'
        connection_config = {
          'url' => config[:url],
          'repository' => config[:repository],
          'username' => config[:username],
          'password' => config[:password]
        }
        NexusCli::RemoteFactory.create(connection_config, config[:ssl_verify])
      end

      # def nexus(node)
      #   require 'nexus_cli'
      #   credentials_entry = get_credentials(node)
      #   default_credentials = credentials_entry['default_admin']
      #   updated_credentials = credentials_entry['updated_admin']

      #   url = generate_nexus_url(node)

      #   overrides = { 'url' => url, 'repository' => node[:nexus][:cli][:repository] }
      #   if Chef::Config[:solo]
      #     begin
      #       merged_credentials = overrides.merge(default_credentials)
      #       NexusCli::RemoteFactory.create(merged_credentials, node[:nexus][:cli][:ssl][:verify])
      #     rescue NexusCli::PermissionsException, NexusCli::CouldNotConnectToNexusException, NexusCli::UnexpectedStatusCodeException
      #       merged_credentials = overrides.merge(updated_credentials)
      #       NexusCli::RemoteFactory.create(merged_credentials, node[:nexus][:cli][:ssl][:verify])
      #     end
      #   else
      #     if node[:nexus][:cli][:default_admin_credentials_updated]
      #       credentials = credentials_entry['updated_admin']
      #     else
      #       credentials = credentials_entry['default_admin']
      #     end
      #     merged_credentials = overrides.merge(credentials)
      #     NexusCli::RemoteFactory.create(merged_credentials, node[:nexus][:cli][:ssl][:verify])
      #   end
      # end

      # Checks to ensure the Nexus server is available. When
      # it is unavailable, the Chef run is failed. Otherwise
      # the Chef run continues.
      #
      # @param  node [Chef::Node] the Chef node
      #
      # @return [NilClass]
      def ensure_nexus_available(config)
        Chef::Application.fatal!(
          'Could not connect to Nexus. Please ensure Nexus is running.'
        ) unless Chef::Nexus.nexus_available?(config)
      end

      # Attempts to connect to the Nexus and retries if a connection
      # cannot be made.
      #
      # @param  node [Chef::Node] the node
      #
      # @return [Boolean] true if a connection could be made, false otherwise
      def nexus_available?(config)
        retries = config[:retries] || 5
        retry_delay = config[:retry_delay] || 5
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
          return false
        end
      end

      # Checks the Nexus users credentials and returns false if they
      # have been changed.
      #
      # @param  username [String] the Nexus username
      # @param  password [String] the Nexus password
      # @param  node [Chef::Node] the Chef node
      #
      # @return [Boolean] true if a connection can be made, false otherwise
      def check_old_credentials(username, password, node)
        require 'nexus_cli'
        url = generate_nexus_url(node)
        overrides = {
          'url' => url,
          'repository' => node[:nexus][:cli][:repository],
          'username' => username,
          'password' => password
        }
        begin
          NexusCli::RemoteFactory.create(
            overrides, node[:nexus][:cli][:ssl][:verify]
          )
          true
        rescue NexusCli::PermissionsException, NexusCli::CouldNotConnectToNexusException, NexusCli::UnexpectedStatusCodeException
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
        nexus_identifier.gsub(' ', '_').downcase
      end

      def decode(value)
        require 'base64'
        Base64.decode64(value)
      end

      private

      # Creates a new instance of a Nexus connection using only
      # the URL to the local server. This connection is anonymous.
      #
      # @param  node [Chef::Node] the Chef node
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
