group node[:nexus][:group] do
  system true
end

user node[:nexus][:user] do
  gid node[:nexus][:group]
  shell '/bin/bash'
  home node[:nexus][:home]
  system true
end
