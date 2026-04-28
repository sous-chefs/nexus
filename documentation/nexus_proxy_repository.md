# nexus_proxy_repository

Manages a proxy Nexus repository through the Nexus API.

## Actions

* `:create` - Creates the repository when missing and applies publisher/subscriber state.
* `:update` - Updates publisher/subscriber state when the repository exists.
* `:delete` - Deletes the repository when present.

## Properties

* `url` - Remote repository URL. Required.
* `policy` - Repository policy: `RELEASE`, `SNAPSHOT`, or `MIXED`.
* `publisher` - Enables or disables artifact publishing.
* `subscriber` - Enables or disables artifact subscription.
* `preemptive_fetch` - Enables preemptive fetch when subscribing. Default: `false`.
* `config` - API connection overrides.

## Example

```ruby
nexus_proxy_repository 'maven_central' do
  url 'https://repo1.maven.org/maven2/'
  policy 'RELEASE'
end
```
