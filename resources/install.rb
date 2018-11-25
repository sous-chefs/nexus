property :host, String, 
         default: '0.0.0.0'
property :download_url, String, 
         default: lazy { "https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/3/nexus-#{version}-unix.tar.gz" }
property :checksum, String,
         default: 'ae8cc7891942d71cf12c11e1a98d70c1310e788ab44aa95c5d1e7671cc0187e2'
property :version,  String,
         default: '3.14.0-04'
property :home, String,
         default: '/opt/nexus'
property :user, String,
         default: 'nexus'
property :group, String,
         default: 'nexus'
property :context_path, String,
         default: '/nexus'
property :loopback_only, [true, false],
         default: false
property :cli_version, String,
         default: '4.1.1'
property :port, Integer,
         default: 8080

action :install do 
  # include_recipe 'ark'
  # include_recipe 'java'

  group new_resource.group do
    system true
  end

  user new_resource.user do
    gid new_resource.group
    shell '/bin/bash'
    home new_resource.home
    system true
  end

  chef_gem 'nexus_cli' do
    version new_resource.cli_version
  end

  ark 'nexus' do
    url format(new_resource.download_url, version: new_resource.version)
    version new_resource.version
    path new_resource.home
    strip_components 1
    checksum new_resource.checksum
    owner new_resource.user
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
    directory ::File.join(new_resource.home, dir) do
      owner new_resource.user
      group new_resource.group
    end
  end

  template ::File.join(new_resource.home, 'conf', 'nexus.properties') do
    source 'nexus.properties.erb'
    owner new_resource.user
    group new_resource.group
    mode 0775
    variables(
      nexus_port: new_resource.port,
      nexus_host: new_resource.host,
      nexus_context_path: new_resource.context_path,
      work_dir: new_resource.work_dir
    )
  end

  template ::File.join(new_resource.home, 'conf', 'jetty.xml') do
    source 'jetty.xml.erb'
    owner new_resource.user
    group new_resource.group
    mode 0775
    variables(loopback: new_resource.loopback_only)
  end

  template 'Nexus service' do
    cookbook 'nexus'
    source 'nexus.service.erb'
    user new_resource.user
    group new_resource.group
    path "/etc/systemd/system/nexus.service"
  end

  service 'nexus'

  # runit_service 'nexus' do
  #   default_logger true
  #   options(
  #     nexus_user: new_resource.user
  #   )
  #   action [:enable, :start]
  # end

  ruby_block 'wait until nexus ready' do
    block do
      config = Chef::Nexus.merge_config({}, node)
      Chef::Nexus.ensure_service_available(config)
    end
  end
end
