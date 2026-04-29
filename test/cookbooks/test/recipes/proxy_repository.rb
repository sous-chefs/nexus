# frozen_string_literal: true

nexus_proxy_repository 'central' do
  url 'https://repo1.maven.org/maven2/'
  policy 'RELEASE'
  config skip_service_check: true
end
