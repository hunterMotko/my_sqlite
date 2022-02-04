# my_sqlite

This is a project to interact with csv files like you were using the popular SQLite database engine.
The goal of this project was to reproduce the CRUD functionality and easy to use command line operations of SQLite.

## How To Use This Project

after cloning enter the working directory

```cd my_sqlite```

Then there are two different ways that you can use this project:

- To you the test case format given to you in the test_cases.txt.
  - copy them one at a time to them commented out main function in my_sqlite_request.rb and run ```ruby my_sqlite_request.rb```
- Or you can use the CLI option by running ```ruby my_sqlite_cli.rb```
  - Wait for the command line prompt ```>```
  - Then you can run the sql query format located at the bottom of the test_cases.txt

Not all sql querys available but the basic CRUD functionalites are

- SELECT
- INSERT
- UPDATE
- DELETE
- WHERE
- JOIN
- ORDER BY
Are included