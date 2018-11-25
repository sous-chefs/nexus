#
# Author:: Heavy Water Operations LLC <support@hw-ops.com>
#
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
default['nexus']['user'] = 'nexus'
default['nexus']['group'] = 'nexus'
default['nexus']['home'] = '/usr/local/nexus'
default['nexus']['port'] = 8080
default['nexus']['context_path'] = '/nexus'
default['nexus']['loopback_only'] = false
default['nexus']['work_dir'] = '/usr/local/nexus/work'
default['nexus']['version'] = '3.14.0-04'
default['nexus']['download_url'] =
  'https://sonatype-download.global.ssl.fastly.net/repository/repositoryManager/3/nexus-%{version}-unix.tar.gz'
default['nexus']['download_sha256_checksum'] =
  'ae8cc7891942d71cf12c11e1a98d70c1310e788ab44aa95c5d1e7671cc0187e2'

default['java']['jdk_version'] = 11
