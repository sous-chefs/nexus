require 'spec_helper'

describe 'nexus_install' do
  step_into :nexus_install
  platform 'ubuntu'

  context 'install nexus' do
    recipe do
      nexus_install ''
    end

    it { is_expected.to create_template('/etc/systemd/system/nexus.service') }
  end
end
