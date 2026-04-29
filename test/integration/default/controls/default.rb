# frozen_string_literal: true

control 'nexus-install' do
  impact 1.0
  title 'Nexus is installed and configured'

  describe user('nexus') do
    it { should exist }
  end

  describe group('nexus') do
    it { should exist }
  end

  describe service('nexus') do
    it { should be_enabled }
  end

  describe file('/usr/local/nexus/conf/nexus.properties') do
    it { should exist }
    its('content') { should match /application-port=8080/ }
    its('content') { should match /application-host=0.0.0.0/ }
    its('content') { should match %r{nexus-work=/usr/local/nexus/work} }
    its('content') { should match %r{nexus-webapp-context-path=/nexus} }
  end

  describe systemd_service('nexus') do
    it { should be_installed }
  end
end
