require 'spec_helper'

describe 'Nexus User' do
  step_into :nexus_user
  platform 'ubuntu'

  context 'Add a nexus user' do
    recipe do
      nexus_user ''
    end

    # it { is_expected.to create_template('/etc/systemd/system/nexus.service') }
  end
end
