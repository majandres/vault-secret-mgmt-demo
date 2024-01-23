# Secret Management with HashiCorp Vault

## Required Tools
* terraform
* tflint
* [pre-commit](https://pre-commit.com/)
* minikube
* helm

## Infrastructure Setup
To run this demo, we will use terraform to deploy the required infrastructure components such as VPC, Networking, EC2 machine, etc.  Note that the terraform code is specific to AWS.

Before creating these infrastructure components, it's recommended to create an S3 bucket which will contain the terraform state for these components.  Checkout the `remote-state-s3-backend` [module](https://registry.terraform.io/modules/nozaq/remote-state-s3-backend/aws/latest).

Create configuration files under the `./terraofrm/config` directory.  See examples below.

backend-demo.conf
```
bucket         = "<s3_bucket_name>"
key            = "<s3_bucket_key>"
region         = "us-east-1"
encrypt        = true
dynamodb_table = "<dynamodb_table>"
```

demo.tfvars
```
vpc_name            = "<vpc_name>"
vpc_cidr            = "10.10.0.0/16"
vpc_azs             = ["us-east-1a", "us-east-1b"]
vpc_public_subnets  = ["10.10.0.0/24", "10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
vpc_private_subnets = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24"]

ec2_name          = ""
ec2_ami           = "ami-01234567891234567"
ec2_instance_type = "t3.medium"
ec2_key_name      = ""
src_ips           = []
```

Afterwards, navigate to the `./terraform` directory where the required infrastructure can now be provisioned.
1. `terraform init -reconfigure -backend-config=config/backend-demo.conf`
2. `terraform plan -var-file=config/demo.tfvars -out=test`

## Vault Provisioning
Initialize Vault
```
kubectl exec vault-0 -- vault operator init \
    -key-shares=1 \
    -key-threshold=1 \
    -format=json > cluster-keys.json

VAULT_UNSEAL_KEY=$(jq -r ".unseal_keys_b64[]" cluster-keys.json)
```

Unseal vault pod
```
kubectl exec vault-0 -- vault operator unseal $VAULT_UNSEAL_KEY
```

Join the other vaults to the Raft cluster
```
kubectl exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
kubectl exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
```

Unseatl the other vaults
```
kubectl exec -ti vault-1 -- vault operator unseal $VAULT_UNSEAL_KEY
kubectl exec -ti vault-2 -- vault operator unseal $VAULT_UNSEAL_KEY
```

## Enable Kubernetes Auth on Vault
```
kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh

vault auth enable kubernetes
vault write auth/kubernetes/config \
    kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"
```
Create policy
```
vault policy write py-demo - <<EOF
path "database/creds/py-demo" {
  capabilities = ["read"]
}
EOF
```
Create role
```
vault write auth/kubernetes/role/py-demo \
        bound_service_account_names=py-demo \
        bound_service_account_namespaces=demo \
        policies=py-demo \
        ttl=24h
```

## Enable Databas secrets engine
```
vault secrets enable database

vault write database/roles/py-demo \
    db_name=mysql-database \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT ON *.* TO '{{name}}'@'%';" \
    default_ttl="1m" \
    max_ttl="2m"

vault write database/config/mysql-database \
     plugin_name=mysql-database-plugin \
     connection_url="{{username}}:{{password}}@tcp(mysql.mysql.svc.cluster.local:3306)/" \
     revocation_statements="DROP USER '{{name}}'@'%';" \
     allowed_roles=py-demo \
     username="root" \
     password="demo"
```
