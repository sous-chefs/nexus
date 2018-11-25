class Chef
  module Nexus
    module Helpers
      # def group_repository_exists?(name, config)
      #   Chef::Nexus.nexus(config).get_group_repository(name)
      #   true
      # rescue NexusCli::RepositoryNotFoundException
      #   false
      # end

      def repository_in_group?(repository_name, repository_to_check)
        Chef::Nexus.nexus(@config).repository_in_group?(repository_name, repository_to_check)
      end
    end
  end
end
