job "make-map" {
  datacenters = ["dc1"]

  type = "batch"

  parameterized {
    payload = "forbidden"
    meta_required = [ "DATA_FILE", "PROJECTION" ],
  }

  group "map" {

    volume "svgs" {
      type = "host"
      source = "maps"
      read_only = false
    }

    task "map" {
      driver = "exec"

      # https://git.io/JvB6U
      artifact {
        source = "${NOMAD_META_DATA_FILE}"
        destination = "data.json"
        mode = "file"
      }

      artifact {
        source = "https://storage.googleapis.com/mlange-files/make-svg-linux"
      }

      volume_mount {
        volume = "svgs"
        destination = "/svgs-mount"
        read_only = false
      }

      config {
        command = "make-svg-linux"
        args = [
          "${NOMAD_META_PROJECTION}",
          "data.json",
          "svgs-mount/svgs"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
