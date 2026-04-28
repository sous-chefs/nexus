# frozen_string_literal: true

property :policy, String,
         description: 'Repository policy.'

property :publisher, [true, false, nil],
         default: nil,
         description: 'Whether artifact publishing is enabled for the repository.'
