import time
import mysql.connector

while(True):
    mysqlconnection = mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="d4rkac",
        auth_plugin='mysql_native_password'
    )
    mysqlcursor = mysqlconnection.cursor()
    mysqlcursor.execute("SELECT * FROM `licenses` WHERE `Tempo` > 0")
    result = mysqlcursor.fetchall()
    for x in result:
        mysqlcursor.execute("UPDATE `licenses` SET `Tempo` = %s WHERE owner = %s", [(int(x[4])-1), (x[1])])
        mysqlconnection.commit()
        print(f"O tempo de licença de {x[1]} foi atualizado para {int(x[4])-1} dias.")
    time.sleep(86400)