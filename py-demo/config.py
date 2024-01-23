from os import environ

class Config():
    LOG_LEVEL = environ.get('LOG_LEVEL', 'INFO')
    VAULT_ADDR = environ.get('VAULT_ADDR', 'http://localhost:8200')
    VAULT_TOKEN = environ.get('VAULT_TOKEN')
    VAULT_DB_MOUNT_POINT = environ.get('VAULT_DB_MOUNT_POINT', 'database')
    VAULT_DB_ROLE = environ.get('VAULT_DB_ROLE', 'NONE')
