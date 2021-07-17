import 'dart:async';
import 'package:mysql1/mysql1.dart';

Future getDataFromMysql() async {
  // Open a connection
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      db: 'test',
      password: 'test'));


  // Query the database using a parameterized query
  var results = await conn.query('SELECT id,user_id,password,first_name FROM `user_profile` WHERE id=2');
  for (var row in results) {
    print('Student Name: ${row[3]}, Student ID: ${row[1]} , Password: ${row[2]}');
  }
  

  // Finally, close the connection
  await conn.close();
}