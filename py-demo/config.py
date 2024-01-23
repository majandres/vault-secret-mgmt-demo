from os import environ

class Config():
    LOG_LEVEL = environ.get('LOG_LEVEL', 'INFO')
    VAUL_ADDR = environ.get('VAULT_ADDR', 'http://localhost:8200')
    VAUL_TOKEN = environ.get('VAUL_TOKEN')
    VAULT_DB_MOUNT_POINT = environ.get('VAULT_DB_MOUNT_POINT', 'database')
    VAULT_DB_ROLE = environ.get('VAULT_DB_ROLE', 'NONE')
