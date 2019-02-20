# HA webapp on AWS with Terraform and CoreOS
This is an example of deploying an HA webapp on AWS with Terraform and CoreOS.

### Web server
* CoreOS instance bootstrapped using ignition. 
* Runs web server as a systemd service with nginx container.
* Nginx config, custom 404 page and default index page are bootstrapped and mounted into the container (For demo purpose only, images should be built and pushed to registry.)

### Jumpbox
* A public facing host that allows system admins to management instances in the same VPC.

### Application Load Balancer
* ALB load balances web traffic to all web servers across multiple AZs
* Terminates SSL at ALB
* Two listners. Reidrects HTTP to HTTPS
* Communication between ALB and web servers is HTTP

### Auto Scaling Group
* Loads launch configuration from rendered Ignition config
* Auto scales web instances across multiple AZs
* Attaches to afore created ALB

### SSL
* Self signed certs
* Imported into ACM

### Traffic flow

```
Users

 | http / https

ALB (http -> https)

 | http

Instances
```

## How to run this
* Set up proper AWS creds
* Modify `vars.tf` accordingly
* Run terraform
```
terraform init
terraform plan
terraform apply
```

## SSH key for access intances
SSH private key is genreated by Terraform. To get the private key, you can run the following command:
```
terraform state show tls_private_key.ssh
```
