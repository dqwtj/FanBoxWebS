# rainbows config
worker_processes 4

Rainbows! do
  use :ThreadSpawn
  worker_connections 25
end