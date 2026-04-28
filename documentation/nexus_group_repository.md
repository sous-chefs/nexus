# nexus_group_repository

Manages a Nexus group repository and group membership through the Nexus API.

## Actions

* `:create` - Creates the group repository when missing.
* `:delete` - Deletes the group repository when present.
* `:add_to` - Adds a repository to the group.
* `:remove_from` - Removes a repository from the group.

## Properties

* `repository` - Repository to add or remove from the group.
* `config` - API connection overrides.

## Example

```ruby
nexus_group_repository 'public' do
  action :create
end

nexus_group_repository 'public' do
  repository 'maven_central'
  action :add_to
end
```
