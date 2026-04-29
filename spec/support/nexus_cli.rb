# frozen_string_literal: true

module NexusCli
  class CouldNotConnectToNexusException < StandardError; end
  class UnexpectedStatusCodeException < StandardError; end
  class RepositoryNotFoundException < StandardError; end
  class UserNotFoundException < StandardError; end

  class RemoteFactory
    def self.create(*)
      raise CouldNotConnectToNexusException
    end
  end
end
