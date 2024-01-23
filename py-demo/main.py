import logging
import hvac
import time

from config import Config
from mysql.connector import connect, Error


def print_db_records(host, database, table, username, password):
    log.debug(f"Establishing DB connection...")
    try:
        with connect(
            host=host,
            database=database,
            user=username,
            password=password
        ) as connection:
            select_query = f"SELECT * from {database}.{table};"
            log.info(f"DB connection established, issuing query: {select_query}")

            with connection.cursor() as cursor:
                cursor.execute(select_query)
                for record in cursor:
                    log.info(record)
    except Error as e:
        log.error(e)


def main():
    try:
        log.debug(f"Using role '{Config.VAULT_DB_ROLE}' to request DB credentials")
        credentials = client.secrets.database.generate_credentials(
            name=Config.VAULT_DB_ROLE,
            mount_point=Config.VAULT_DB_MOUNT_POINT
        )
    except Exception as e:
        log.error(e)
        exit(1)

    username = credentials['data']['username']
    password = credentials['data']['password']
    log.debug(f"Credentials received: {username}")

    print_db_records('localhost', 'demo', 'countries', username, password)


if __name__ == "__main__":
    logging.basicConfig(format='[%(asctime)s] %(levelname)s %(filename)s:%(lineno)s %(funcName)s(): %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p')
    log = logging.getLogger(__name__)
    log.setLevel(Config.LOG_LEVEL)

    client = hvac.Client(
        url=Config.VAULT_ADDR,
        token=Config.VAULT_TOKEN
    )
    log.info(f"hvac client created for {Config.VAULT_ADDR}")

    # Basic checks before continuing
    try:
        log.info(f"Checking if Vault is initialized and unsealed")
        if not client.sys.is_initialized():
            log.error(f"Vault is not initialized")
            exit(1)

        if client.sys.is_sealed():
            log.error(f"Vault is sealed")
            exit(1)
    except Exception as e:
        log.error(e)
        exit(1)

    log.info(f"Vault at {Config.VAULT_ADDR} is available")
    main()
