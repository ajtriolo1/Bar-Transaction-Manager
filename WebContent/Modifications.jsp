<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Modifications Page</title>
<link href="css/chooseMod.css" type="text/css" rel="stylesheet" />
</head>
<body style="display:flex; flex-direction:column; min-height:100vh; overflow:auto;">
<a href="Welcome.jsp"><button class="btn-gradient blue small" style="cursor:pointer; position:absolute; top:10px; right:10px;">Home</button></a>
	<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA='beerbardrinkerplus'";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>

	<form method="post" action="chooseMod.jsp" target="_self">
		<label for="table">Table:</label>
		<br>
		<select class="custom-select" id="table" name="table" size=1>
			<%
			//parse out the results
			while (result.next()) { %>
			<option><%= result.getString("TABLE_NAME") %></option>
			<% }
			//close the connection.
			result.close();
			db.closeConnection(con);
			%>
		</select>
		<br>
		<br>
		<input style="cursor:pointer;" class="btn-gradient blue small" type="submit" value="Go">
	</form>
	<%} catch (Exception e) {
			out.print(e);
		}%>
</body>
</html>