data_dir = "/tmp/nomad-test"

# Enable the server
server {
    enabled = true
    bootstrap_expect = 1
}

# Enable the client
client {
  enabled = true

  # Artificially limit Memory
  memory_total_mb = 1000

  options = {
    "driver.raw_exec.enable" = "1"
  }

  host_volume "maps" {
    path = "/maps/svg-maps"
    read_only = false
  }
}
