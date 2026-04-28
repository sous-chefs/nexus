# frozen_string_literal: true

nexus_hosted_repository 'internal' do
  policy 'RELEASE'
  config skip_service_check: true
end
