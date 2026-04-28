# Nexus Custom Resource Migration

This release removes the legacy `nexus::default`, `nexus::cli`, and `nexus::manage_user` recipes and the `node['nexus']` attributes. Configure Nexus by declaring resources directly.

## Install Nexus

Before:

```ruby
node.default['nexus']['port'] = 8080
node.default['nexus']['context_path'] = '/nexus'

include_recipe 'nexus'
```

After:

```ruby
nexus_install 'default' do
  port 8080
  context_path '/nexus'
end
```

The old recipe used runit to manage the service. `nexus_install` now writes and enables a native `nexus.service` systemd unit.

## Manage API Objects

The repository and user resources remain available, but their implementation is now a modern custom resource instead of a legacy provider.

```ruby
nexus_user 'testuser' do
  email 'user@example.com'
  password 'secret'
  enabled true
  roles ['wonderland']
end

nexus_proxy_repository 'java-dot-net' do
  url 'https://maven.java.net/content/repositories/snapshots/'
  subscriber true
  publisher false
  policy 'SNAPSHOT'
end
```

The API resources still install `nexus_cli` internally. Use the `config` property to override URL, credentials, retry behavior, or SSL verification.
