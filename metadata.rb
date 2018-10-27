#
# Author:: Heavy Water Operations LLC <support@hw-ops.com>
#
# Copyright 2014, Heavy Water Operations LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name              'nexus'
version           '1.0.0'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Installs and configures sonatype nexus'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url        'https://github.com/sous-chefs/nexus'
issues_url        'https://github.com/sous-chefs/nexus/issues'
chef_version      '>= 13.0'

depends 'ark'
depends 'java'
depends 'runit'

%w(ubuntu redhat centos).each do |os|
  supports os
end
