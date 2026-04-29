# frozen_string_literal: true

property :config, Hash,
         default: {},
         description: 'Nexus API connection configuration. Supports url, username, password, ssl_verify, retries, retry_delay, and skip_service_check.'
