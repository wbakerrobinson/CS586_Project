## Project for Databases class CS 586 at PSU
This project was created by Will Baker-Robinson and Kevin Ng for CS 586. It is designed to help with the analysis of surveys relating to the PSU Senior Capstone Class. Hopefully, this document, and the database created, will be able to be used for easier selection of project teams. The project user interface for the project was created using the R package Shiny. Parameters are given to an Rmarkdown file which then connects to a database using Psycopg2. We first attempted to use an ODBC Postgres driver, but this proved to be too much of a headache to set up. Cleaning of data is done using a variety of base R functions and loaded packages. This data is uploaded to a Postgres database, and then used to answer questions about the data. Finally, an html markdown report is generated for the user with the answers. The data is small enough that we could have completed this project just using memory, but it was done for a relational database management systems class.

Some notes about our program:  
1. This program will create a database of the information supplied on whichiver database you provide credentials for. This should work as long as the database is Postgres.  
2. After the database is created, you will recieve a document as a .html file with answers to our 20 questions.  
3. If there are no files submitted at the start, the program will attempt to connect to the database and run the report.  
4. We expect .csv files for all data.
