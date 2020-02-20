# Run this job like this:
#
# echo "HashiTalks!" | nomad job dispatch hi -
#
job "hi" {
  datacenters = ["dc1"]

  type = "batch"

  parameterized {
    payload = "required"
  }

  task "hi" {
    driver = "exec"

    dispatch_payload {
      file = "message.txt"
    }

    config {
      command = "bash"
      args = ["-c", "echo \"Hello, $(cat ${NOMAD_TASK_DIR}/message.txt)\"; sleep 120"]
    }

    resources {
      cpu    = 100
      memory = 64
    }
  }
}
