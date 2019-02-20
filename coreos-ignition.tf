# ignition config
data "ignition_config" "ha-web" {
  # load files
  files = [
    "${data.ignition_file.role.id}",
    "${data.ignition_file.web-index.id}",
    "${data.ignition_file.404.id}",
    "${data.ignition_file.nginx-config.id}",
  ]
  # load system units
  systemd = [
    "${data.ignition_systemd_unit.coreos_locksmithd_mask.id}",
    "${data.ignition_systemd_unit.web.id}",
  ]
}

# mask locksmithd to prevent unscheduled auto updates
data "ignition_systemd_unit" "coreos_locksmithd_mask" {
  name = "locksmithd.service"
  mask = true
}

# ha-web web service
data "ignition_systemd_unit" "web" {
  name = "web.service"
  enabled = true
  content = <<EOM
[Unit]
Description=web
After=docker.service
Requires=docker.service

[Service]
SyslogIdentifier=web
TimeoutStartSec=60
Restart=always
RestartSecs=30
ExecStartPre=-/usr/bin/docker rm -f web
ExecStart=/usr/bin/docker run --init --rm \
    -p 0.0.0.0:80:80 \
    -v /etc/index.html:/usr/share/nginx/html/index.html \
    -v /etc/404.html:/usr/share/nginx/html/404.html \
    -v /etc/nginx-config:/etc/nginx/conf.d/default.conf \
    --name web ${var.web_docker_image}
[Install]
WantedBy=multi-user.target
EOM
}

# add a file that describes its role
data "ignition_file" "role" {
  filesystem = "root"
  path = "/etc/instance-role"
  mode = "0444"
  content {
    content = "web"
  }
}

# custom index.html
data "ignition_file" "web-index" {
  filesystem = "root"
  path = "/etc/index.html"
  mode = "0444"
  content {
    content = "ha-web"
  }
}

# custom 404.html
data "ignition_file" "404" {
  filesystem = "root"
  path = "/etc/404.html"
  mode = "0444"
  content {
    content = "Custom 404 message"
  }
}

# nginx config
data "ignition_file" "nginx-config" {
  filesystem = "root"
  path = "/etc/nginx-config"
  mode = "0644"
  content = { 
    content = "${file("nginx.conf")}" 
  }
}