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

require 'serverspec'
set :backend, :exec

describe user('nexus') do
  it { should exist }
end

describe group('nexus') do
  it { should exist }
end

describe 'Nexus' do
  describe service('nexus') do
    it { should be_running }
  end

  it 'is listening on port 8080' do
    expect(port(8080)).to be_listening
  end
end

describe file('/usr/local/nexus/conf/nexus.properties') do
  its(:content) { should match /application-port=8080/ }
  its(:content) { should match /application-host=0.0.0.0/ }
  its(:content) { should match %r{nexus-work=/usr/local/nexus/work} }
  its(:content) { should match %r{nexus-webapp-context-path=/nexus} }
end
