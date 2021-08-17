# Changelog

## 4.0.4 - *2021-08-17*

Standardise files with files in sous-chefs/repo-management

## 4.0.3 - *2021-06-01*

- resolved cookstyle error: libraries/chef_nexus_artifact.rb:60:1 refactor: `ChefCorrectness/IncorrectLibraryInjection`

## 4.0.2 (2020-05-05)

- resolved cookstyle error: libraries/chef_nexus.rb:87:9 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: libraries/chef_nexus_artifact.rb:44:13 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: libraries/chef_nexus_artifact.rb:50:13 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: providers/user.rb:54:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: providers/user.rb:58:3 refactor: `ChefCorrectness/ChefApplicationFatal`
- resolved cookstyle error: providers/user.rb:62:3 refactor: `ChefCorrectness/ChefApplicationFatal`

## 4.0.1

- Remove unnecessary actions method in the resources
- Remove unnecessary :name properties from the resources
- Remove unnecessary return statements
- Use Chef::Recipe.include not Chef::Recipe.send
- Remove long_description from the metadata.rb
- Migrated to Github actions for testing
- Remove the .foodcritic file since we use Cookstyle now

## v1.0.0

- Initial release!
