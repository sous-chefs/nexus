# nexus

[![Cookbook Version](https://img.shields.io/cookbook/v/nexus.svg)](https://supermarket.chef.io/cookbooks/nexus)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/nexus/master.svg)](https://circleci.com/gh/sous-chefs/nexus)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

This is a cookbook for installing Sonatype Nexus. It is inspired by [RiotGamesCookbooks/nexus-cookbook](https://github.com/RiotGamesCookbooks/nexus-cookbook) but attempts to avoid managing things like HTTP proxies and SSL certificates.

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

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

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
