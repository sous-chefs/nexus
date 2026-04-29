# nexus_user

Manages a Nexus local user through the Nexus API.

## Actions

* `:create` - Creates the user when missing.
* `:update` - Updates the user when present.
* `:delete` - Deletes the user when present.

## Properties

* `username` - User ID. Name property.
* `first_name` - First name.
* `last_name` - Last name.
* `email` - Email address. Required for create.
* `enabled` - Whether the user is active. Required for create.
* `password` - Password.
* `old_password` - Existing password for password changes.
* `roles` - Role names. Required for create.
* `config` - API connection overrides.

## Example

```ruby
nexus_user 'deploy' do
  email 'deploy@example.com'
  enabled true
  password 'secret'
  roles ['nx-admin']
end
```
