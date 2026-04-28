# frozen_string_literal: true

nexus_install 'default' do
  service_actions [:enable]
  wait_for_service false
end
