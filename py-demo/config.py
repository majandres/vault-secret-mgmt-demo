from os import environ

class Config():
    LOG_LEVEL = environ.get('LOG_LEVEL', 'INFO')
    VAULT_ADDR = environ.get('VAULT_ADDR', 'http://localhost:8200')
    VAULT_TOKEN = environ.get('VAULT_TOKEN')
    VAULT_DB_MOUNT_POINT = environ.get('VAULT_DB_MOUNT_POINT', 'database')
    VAULT_DB_ROLE = environ.get('VAULT_DB_ROLE', 'NONE')
    VAULT_K8S_AUTH_ROLE = environ.get('VAULT_K8S_AUTH_ROLE')
    KUBERNETES_SERVICE_HOST = environ.get('KUBERNETES_SERVICE_HOST')
    DB_HOST = environ.get('DB_HOST', 'localhost')
    DB_NAME = environ.get('DB_NAME', 'demo')
    DB_TABLE = environ.get('DB_TABLE', 'countries')
