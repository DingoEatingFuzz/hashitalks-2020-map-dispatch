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
      }

      artifact {
        source = "https://storage.googleapis.com/mlange-files/hashi-talks-1.0.0.tgz"
      }

      volume_mount {
        volume = "svgs"
        destination = "/svgs-mount"
      }

      config {
        command = "bin/node"
        args = [
          "local/package/make-svg.js",
          "${NOMAD_META_PROJECTION}",
          "data.json",
          "svgs-mount/svgs"
        ]

        // command = "bash"
        // args = [ "-c", "cat local/package/make-svg.js && sleep 1000" ]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
