nexus
=====

[![Cookbook Version](https://img.shields.io/cookbook/v/nexus.svg?style=flat)](https://supermarket.chef.io/cookbooks/nexus) [![CircleCI](https://circleci.com/gh/sous-chefs/nexus.svg?style=svg)](https://circleci.com/gh/sous-chefs/nexus) [![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)


This is a cookbook for installing Sonatype Nexus. It is inspired by [RiotGamesCookbooks/nexus-cookbook](https://github.com/RiotGamesCookbooks/nexus-cookbook) but attempts to avoid managing things like HTTP proxies and SSL certificates.

Attributes
----------

* `node['nexus']['version']` - version of nexus to install (`2.0.9`)
* `node['nexus']['download_url']` - url to nexus tarball (`http://download.sonatype.com/nexus/oss/nexus-%{version}-bundle.tar.gz` [this string is interpolated with the version attrbute above](https://coderanger.net/derived-attributes/))
* `node['nexus']['download_sha256_checksum']` - checksum corresponding to the above tarball (default matches `2.0.9` version)'
* `n'od'['nexus']['user']` - username to run as (`nexus`)
* `node['nexus']['group']` - group to associate user with (`nexus`)
* `node['nexus']['home']` - install path for nexus (`/usr/local/nexus`)
* `node['nexus']['port']` - port for nexus to listen on (`8080`)
* `node['nexus']['context_path']` - URL path where nexus will be served (`/nexus`')
* `node['nexus']['loopback_only']` - controlls whether nexus binds to 127.0.0.1 (`false`)
* `node['nexus']['work_dir']` - file system path for nexus artifacts and other files (`/usr/local/nexus/work`')
