provider "null" {}

resource "null_resource" "apache_install" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y apache2"
  }
}

resource "null_resource" "apache_config" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
    echo '<VirtualHost *:80>
      ServerName localhost
      DocumentRoot /var/www/html
    </VirtualHost>
    <VirtualHost *:443>
      ServerName localhost
      DocumentRoot /var/www/html
      SSLEngine on
      SSLCertificateFile /etc/ssl/certs/ssl-cert-snakeoil.pem
      SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key
    </VirtualHost>
    ' | sudo tee /etc/apache2/sites-available/localhost.conf
    sudo a2enmod ssl
    sudo a2ensite localhost.conf
    sudo systemctl restart apache2
    EOT
  }
}
