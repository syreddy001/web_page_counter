  storage "consul" {
    address = "127.0.0.1:8321"
    scheme = "https"
    path    = "vault/"
    tls_ca_file = "/etc/ssl/certs/consul-agent-ca.pem"
    tls_cert_file = "/etc/consul.d/pki/tls/certs/consul-client.pem"
    tls_key_file = "/etc/consul.d/pki/tls/private/consul-client-key.pem"
    token = "f53dc001-2252-7f48-90c0-77d6f65c3b37"
  }

  ui = true

  listener "tcp" {
    address = "0.0.0.0:8322"
    tls_disable = 0
    tls_cert_file = "/etc/vault.d/pki/tls/certs/vault-server.pem"
    tls_key_file = "/etc/vault.d/pki/tls/private/vault-server-key.pem"
  }

  # Advertise the non-loopback interface
  api_addr = "https://192.168.9.11:8322"
  cluster_addr = "https://192.168.9.11:8322"
