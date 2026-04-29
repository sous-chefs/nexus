# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../../libraries/helpers'

describe NexusCookbook::Helpers do
  subject(:helper) { Class.new { include NexusCookbook::Helpers }.new }

  it 'builds the default Nexus URL' do
    expect(helper.default_nexus_url(port: 8081, context_path: '/repository')).to eq('http://localhost:8081/repository')
  end

  it 'normalizes Nexus identifiers' do
    expect(helper.nexus_identifier('Internal Releases')).to eq('internal_releases')
  end

  it 'decodes base64 values' do
    expect(helper.decoded_value('c2VjcmV0')).to eq('secret')
  end
end
