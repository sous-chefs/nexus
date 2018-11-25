#
# Author:: Sous Chefs
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
nexus_install do
  download_url node['nexus']['download_url']
  checksum node['nexus']['download_sha256_checksum']
  version node['nexus']['version']
  home node['nexus']['home']
  user node['nexus']['user']
  group node['nexus']['group']
  context_path node['nexus']['context_path']
  loopback_only node['nexus']['loopback_only']
end
