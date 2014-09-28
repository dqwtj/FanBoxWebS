# rainbows config
worker_processes 4

Rainbows! do
  use :ThreadPool
  worker_connections 64
end

preload_app true

timeout 30

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end