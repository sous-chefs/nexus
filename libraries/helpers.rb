# frozen_string_literal: true

require 'base64'
require 'net/https'
require 'uri'

module NexusCookbook
  module Helpers
    def default_nexus_url(port: 8080, context_path: '/nexus', host: 'localhost')
      URI::HTTP.build(host: host, port: port, path: context_path).to_s
    end

    def nexus_config(config = {})
      Mash.new(
        url: default_nexus_url,
        username: 'admin',
        password: 'admin123',
        retries: 10,
        retry_delay: 10,
        ssl_verify: true
      ).merge(config)
    end

    def nexus_client(config = {})
      require 'nexus_cli'

      connection_config = {
        'url' => config['url'],
        'repository' => config['repository'],
        'username' => config['username'],
        'password' => config['password'],
      }.compact

      NexusCli::RemoteFactory.create(connection_config, config['ssl_verify'])
    end

    def nexus_anonymous_client(config = {})
      require 'nexus_cli'

      NexusCli::RemoteFactory.create({ 'url' => config['url'] }, config['ssl_verify'])
    end

    def nexus_service_available?(config = {})
      retries = config['retries']
      retry_delay = config['retry_delay']

      begin
        nexus_anonymous_client(config).status['state'] == 'STARTED'
      rescue Errno::ECONNREFUSED, NexusCli::CouldNotConnectToNexusException, NexusCli::UnexpectedStatusCodeException => e
        if retries.positive?
          retries -= 1
          Chef::Log.info "Could not connect to Nexus, #{retries} attempt(s) left"
          Chef::Log.info "Nexus error: #{e.inspect}"
          sleep retry_delay
          retry
        end

        false
      end
    end

    def ensure_nexus_service_available(config = {})
      return if config['skip_service_check']

      return if nexus_service_available?(config)

      raise 'Could not connect to Nexus. Please ensure Nexus is running.'
    end

    def nexus_identifier(value)
      value.tr(' ', '_').downcase
    end

    def decoded_value(value)
      Base64.decode64(value)
    end

    def nexus_artifact_url(args = {})
      args = Mash.new.merge(args)
      check_required_artifact_args!(args)

      nexus_url = '/nexus/service/local/artifact/maven/redirect?'
      nexus_url += "r=#{args['repository']}"
      nexus_url += "&g=#{args['group_id']}"
      nexus_url += "&a=#{args['artifact_id']}"
      nexus_url += "&v=#{args['version']}"
      nexus_url += "&c=#{args['package_type']}" if args['package_type']
      nexus_url += "&e=#{args['extension']}" if args['extension']

      url = URI.join(args['server'], nexus_url)
      url.userinfo = "#{args['username']}:#{args['password']}" if args['username']

      Chef::Log.info("Nexus artifact URL generated #{url}")
      full_url_after_redirect(url)
    end

    def full_url_after_redirect(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(*uri.userinfo.split(':')) if uri.userinfo

      result = http.request(request)
      redirected_uri = URI.parse(result.header['location'])
      redirected_uri.userinfo = uri.userinfo
      redirected_uri.to_s
    end

    def check_required_artifact_args!(args)
      %i(server repository group_id artifact_id version).each do |key|
        next if args[key]

        raise "Nexus URL Error: Required argument is missing or unset: #{key}"
      end

      return if args.include?(:extension) || args.include?(:package_type)

      raise 'Nexus URL Error: you must specify either an extension or package type'
    end
  end
end

Chef::DSL::Universal.include NexusCookbook::Helpers
