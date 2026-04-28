# frozen_string_literal: true

provides :nexus_install
unified_mode true

property :user, String,
         default: 'nexus',
         description: 'System user that runs Nexus.'

property :group, String,
         default: 'nexus',
         description: 'System group for the Nexus user.'

property :home, String,
         default: '/usr/local/nexus',
         description: 'Nexus installation path.'

property :port, Integer,
         default: 8080,
         description: 'Nexus HTTP port.'

property :context_path, String,
         default: '/nexus',
         description: 'Nexus web application context path.'

property :loopback_only, [true, false],
         default: false,
         description: 'Bind Jetty to loopback only.'

property :work_dir, String,
         default: '/usr/local/nexus/work',
         description: 'Nexus work directory.'

property :version, String,
         default: '3.91.1-04',
         description: 'Nexus version to install.'

property :download_url, String,
         default: 'https://download.sonatype.com/nexus/3/nexus-%{version}-linux-x86_64.tar.gz',
         description: 'Nexus archive URL. The string is interpolated with the version property.'

property :download_sha256_checksum, String,
         default: 'c4ea71e31d1a93a991a5aa87882943ce912041f8ea576259be05e5a62ec5e73d',
         description: 'SHA256 checksum for the Nexus archive.'

property :service_name, String,
         default: 'nexus',
         description: 'Systemd service name.'

property :service_command, String,
         default: lazy { "#{home}/bin/nexus run" },
         description: 'Command used by systemd to run Nexus.'

property :service_actions, [Symbol, Array],
         default: [:enable, :start],
         description: 'Actions applied to the systemd service resource.'

property :wait_for_service, [true, false],
         default: true,
         description: 'Wait for the Nexus API to report STARTED after service start.'

action :create do
  group new_resource.group do
    system true
  end

  user new_resource.user do
    gid new_resource.group
    shell '/bin/bash'
    home new_resource.home
    system true
  end

  ark 'nexus' do
    url format(new_resource.download_url, version: new_resource.version)
    version new_resource.version
    path new_resource.home
    strip_components 1
    checksum new_resource.download_sha256_checksum
    owner new_resource.user
    action :install
  end

  %w(bin conf logs pid tmp work).each do |dir|
    directory ::File.join(new_resource.home, dir) do
      owner new_resource.user
      group new_resource.group
      recursive true
    end
  end

  template ::File.join(new_resource.home, 'conf', 'nexus.properties') do
    cookbook 'nexus'
    source 'nexus.properties.erb'
    owner new_resource.user
    group new_resource.group
    mode '0775'
    variables(
      nexus_port: new_resource.port,
      nexus_host: '0.0.0.0',
      nexus_context_path: new_resource.context_path,
      work_dir: new_resource.work_dir
    )
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  template ::File.join(new_resource.home, 'conf', 'jetty.xml') do
    cookbook 'nexus'
    source 'jetty.xml.erb'
    owner new_resource.user
    group new_resource.group
    mode '0775'
    variables(loopback: new_resource.loopback_only)
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  systemd_unit "#{new_resource.service_name}.service" do
    content(
      Unit: {
        Description: 'Sonatype Nexus Repository Manager',
        After: 'network-online.target',
        Wants: 'network-online.target',
      },
      Service: {
        Type: 'simple',
        User: new_resource.user,
        Group: new_resource.group,
        WorkingDirectory: new_resource.home,
        ExecStart: new_resource.service_command,
        Restart: 'on-failure',
        LimitNOFILE: '65536',
      },
      Install: {
        WantedBy: 'multi-user.target',
      }
    )
    action [:create, :enable]
    notifies :restart, "service[#{new_resource.service_name}]", :delayed
  end

  service new_resource.service_name do
    action new_resource.service_actions
  end

  ruby_block "wait until #{new_resource.service_name} ready" do
    block do
      ensure_nexus_service_available(
        nexus_config(
          url: default_nexus_url(port: new_resource.port, context_path: new_resource.context_path)
        )
      )
    end
    only_if { new_resource.wait_for_service }
  end
end

action :delete do
  service new_resource.service_name do
    action [:stop, :disable]
  end

  systemd_unit "#{new_resource.service_name}.service" do
    action :delete
  end

  %w(bin conf logs pid tmp work).each do |dir|
    directory ::File.join(new_resource.home, dir) do
      recursive true
      action :delete
    end
  end

  directory new_resource.home do
    recursive true
    action :delete
  end
end

action_class do
  include NexusCookbook::Helpers
end
