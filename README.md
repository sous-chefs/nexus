# nexus

This is a cookbook for installing Sonatype Nexus. It is inspired by [RiotGamesCookbooks/nexus-cookbook](https://github.com/RiotGamesCookbooks/nexus-cookbook) but attempts to avoid managing things like HTTP proxies and SSL certificates.

## Attributes

- `node['nexus']['version]` - version of nexus to install (`2.0.9`)
- `node['nexus']['download_url]` - url to nexus tarball (`http://download.sonatype.com/nexus/oss/nexus-%{version}-bundle.tar.gz` [this string is interpolated with the version attribute above](https://coderanger.net/derived-attributes/))
- `node['nexus']['download_sha256_checksum]` - checksum corresponding to the above tarball (default matches `2.0.9` version)

- `node['nexus']['user]` - username to run as (`nexus`)

- `node['nexus']['group]` - group to associate user with (`nexus`)

- `node['nexus']['home]` - install path for nexus (`/usr/local/nexus`)
- `node['nexus']['port]` - port for nexus to listen on (`8080`)
- `node['nexus']['context_path]` - URL path where nexus will be served (`/nexus`')
- `node['nexus']['loopback_only]` - controlls whether nexus binds to 127.0.0.1 (`false`)
- `node['nexus']['work_dir]` - file system path for nexus artifacts and other files (`/usr/local/nexus/work`')

## Contributors

This project exists thanks to all the people who contribute.
<img src="https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false" /></a>


### Backers

Thank you to all our backers! 🙏 [[Become a backer](https://opencollective.com/sous-chefs#backer)]
<a href="https://opencollective.com/sous-chefs#backers" target="_blank"><img src="https://opencollective.com/sous-chefs/backers.svg?width=890"></a>

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website. [[Become a sponsor](https://opencollective.com/sous-chefs#sponsor)]
<a href="https://opencollective.com/sous-chefs/sponsor/0/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/1/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/2/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/3/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/4/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/5/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/6/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/7/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/8/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/sous-chefs/sponsor/9/website" target="_blank"><img src="https://opencollective.com/sous-chefs/sponsor/9/avatar.svg"></a>
