# nexus_hosted_repository

Manages a hosted Nexus repository through the Nexus API.

## Actions

* `:create` - Creates the repository when missing and applies publisher state.
* `:update` - Updates publisher state when the repository exists.
* `:delete` - Deletes the repository when present.

## Properties

* `policy` - Repository policy: `RELEASE`, `SNAPSHOT`, or `MIXED`.
* `publisher` - Enables or disables artifact publishing.
* `config` - API connection overrides.

## Example

```ruby
nexus_hosted_repository 'internal_releases' do
  policy 'RELEASE'
  publisher true
end
```
