# frozen_string_literal: true

nexus_user 'testuser' do
  config skip_service_check: true
  action :delete
end
