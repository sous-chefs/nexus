# frozen_string_literal: true

nexus_group_repository 'public' do
  repository 'central'
  config skip_service_check: true
  action :add_to
end
