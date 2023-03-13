unified_mode true

property :download_url, String, default: lazy { "https://download.sonatype.com/nexus/3/nexus-#{version}-unix.tar.gz"}

property :download_sha256_checksum, String

property :version, String, default: '3.49.0-02'

property :nexus_home, String, default: '/usr/local/nexus'

property :nexus_user, String, default: 'nexus'

property :nexus_group, String, default: 'nexus'

property :nexus_port, Integer, default: 8080

property :nexus_context_path, String, default: '/nexus'

property :nexus_loopback_only, [true, false], default: false

property :nexus_work_dir, String, default: '/usr/local/nexus/work'

property :install_java, [true, false], default: true

action :install do

  group new_resource.nexus_group do
    system true
  end

  user new_resource.nexus_user do
    gid new_resource.nexus_group
    shell '/bin/bash'
    home new_resource.nexus_home
    system true
  end

  ark 'nexus' do
    url format(new_resource.download_url, version: new_resource.version)
    version new_resource.version
    path new_resource.nexus_home
    strip_components 1
    checksum new_resource.download_sha256_checksum if new_resource.download_sha256_checksum
    owner new_resource.nexus_user
    action :install
  end

  %w(
    bin
    conf
    logs
    pid
    tmp
    work
  ).each do |dir|
    directory ::File.join(new_resource.nexus_home, dir) do
      owner new_resource.nexus_user
      group new_resource.nexus_group
    end
  end

  template ::File.join(new_resource.nexus_home, 'conf', 'nexus.properties') do
    source 'nexus.properties.erb'
    owner new_resource.nexus_user
    group new_resource.nexus_group
    cookbook 'nexus'
    mode '775'
    variables(
      nexus_port: new_resource.nexus_port,
      nexus_host: '0.0.0.0',
      nexus_context_path: new_resource.nexus_context_path,
      work_dir: new_resource.nexus_work_dir
    )
  end

  template ::File.join(new_resource.nexus_home, 'conf', 'jetty.xml') do
    source 'jetty.xml.erb'
    owner new_resource.nexus_user
    group new_resource.nexus_group
    cookbook 'nexus'
    mode '775'
    variables(loopback: new_resource.nexus_loopback_only)
  end

  link '/etc/init.d/nexus' do
    to ::File.join(new_resource.nexus_home, 'bin', 'nexus')
  end

  openjdk_pkg_install '8' if new_resource.install_java

  systemd_unit 'nexus.service' do
    content(
      Unit: {
        Description: 'nexus service',
        After: 'network.target'
      },
      Service: {
        Type: 'forking',
        LimitNOFILE: 65_536,
        ExecStart: '/etc/init.d/nexus start',
        ExecStop: '/etc/init.d/nexus stop',
        User: new_resource.nexus_user,
        Restart: 'on-abort',
        TimeoutSec: 600
      },
      Install: {
        WantedBy: 'multi-user.target'
      }
    )
    action [:start]
    # start|stop|run|run-redirect|status|restart|force-reload
  end
end
