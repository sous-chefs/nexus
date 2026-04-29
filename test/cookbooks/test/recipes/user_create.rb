# frozen_string_literal: true

nexus_user 'testuser' do
  email 'user@example.com'
  enabled true
  password 'secret'
  roles ['nx-admin']
  config skip_service_check: true
end
