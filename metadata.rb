name              'nexus'
version           '4.0.6'
chef_version      '>= 13.0'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures Sonatype Nexus'
source_url        'https://github.com/sous-chefs/nexus'
issues_url        'https://github.com/sous-chefs/nexus/issues'

depends 'ark'
depends 'java'
depends 'runit'

supports 'debian'
supports 'ubuntu'
supports 'centos'
supports 'redhat'
supports 'oracle'
supports 'amazon'
