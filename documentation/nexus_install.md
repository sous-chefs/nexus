# nexus_install

Installs Nexus Repository from an archive, configures the local service user, renders Nexus configuration files, and manages a native systemd service.

## Actions

* `:create` - Installs and configures Nexus.
* `:delete` - Stops and disables the service, removes the systemd unit, and removes the installation directory.

## Properties

* `user` - System user. Default: `nexus`.
* `group` - System group. Default: `nexus`.
* `home` - Installation path. Default: `/usr/local/nexus`.
* `port` - HTTP port. Default: `8080`.
* `context_path` - Web context path. Default: `/nexus`.
* `loopback_only` - Bind Jetty to loopback. Default: `false`.
* `work_dir` - Nexus work directory. Default: `/usr/local/nexus/work`.
* `version` - Nexus version. Default: `3.91.1-04`.
* `download_url` - Archive URL interpolated with `version`.
* `download_sha256_checksum` - Archive checksum.
* `service_name` - Systemd service name. Default: `nexus`.
* `service_command` - Command used by systemd. Default: `<home>/bin/nexus run`.
* `service_actions` - Actions applied to the systemd service resource. Default: `[:enable, :start]`.
* `wait_for_service` - Wait for API readiness. Default: `true`.

## Example

```ruby
nexus_install 'default' do
  port 8081
  context_path '/'
end
```
