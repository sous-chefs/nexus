require 'net/https'
require 'uri'

class Chef
  module Nexus
    module Artifact
      class << self
        def get_url(args = {})
          args = nexus_default_args.merge(args)
          nexus_check_required_args!(args)
          nexus_url = '/nexus/service/local/artifact/maven/redirect?'
          nexus_url += "r=#{args['repository']}"
          nexus_url += "&g=#{args['group_id']}"
          nexus_url += "&a=#{args['artifact_id']}"
          nexus_url += "&v=#{args['version']}"
          nexus_url += "&c=#{args['package_type']}" if args['package_type']
          nexus_url += "&e=#{args['extension']}" if args['extension']
          url = URI.join(args['server'], nexus_url)
          url.userinfo = "#{args['username']}:#{args['password']}" if args['username']
          Chef::Log.info("Chef::Nexus::Artifact.get_url generated #{url}")
          full_url_after_redirect(url)
        end

        def full_url_after_redirect(uri)
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true if uri.scheme == 'https'

          req = Net::HTTP::Get.new(uri.request_uri)
          req.basic_auth(*uri.userinfo.split(':'))

          result = http.request(req)

          Chef::Log.debug("get_url result: #{result.inspect}")
          Chef::Log.debug("result headers: #{result.header.inspect}")
          Chef::Log.debug("result body: #{result.body.inspect}")
          n_uri = URI.parse(result.header['location'])
          n_uri.userinfo = uri.userinfo
          n_uri.to_s
        end

        def nexus_check_required_args!(args)
          %i(server repository group_id artifact_id version).each do |key|
            next if args[key]
            Chef::Application.fatal!(
              "Nexus URL Error: Required argument is missing or unset: #{key}"
            )
          end

          unless args.include?(:extension) || args.include?(:package_type)
            Chef::Application.fatal!(
              'Nexus URL Error: you must specify either an extension or package type'
            )
          end
        end

        def nexus_default_args
          Mash.new
        end
      end
    end
  end
end

Chef::Recipe.send(:include, Chef::Nexus::Artifact)
