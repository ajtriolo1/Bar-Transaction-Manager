<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Drinker Page</title>
<link href="css/drinker.css" type="text/css" rel="stylesheet" />
</head>
<script type="text/javascript">
  function iframeLoaded() {
      var iFrameID = document.getElementById('results');
      if(iFrameID) {
            iFrameID.height = "";
            iFrameID.height = iFrameID.contentWindow.document.body.scrollHeight + "px";
      }   
  }
</script>
<body style="display:flex; flex-direction:column; min-height:100vh; overflow:auto;">
	<a href="Welcome.jsp"><button class="btn-gradient blue small" style="position:absolute; top:10px; right:10px;">Home</button></a>
	<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected radio button from the index.jsp
			//Make a SELECT query from the table specified by the 'command' parameter at the index.jsp
			String str = "SELECT distinct name FROM bar";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>

	<form method="post" action="barInfo.jsp" target="results">
		<label for="bar">Bar:</label>
		<br>
		<select id="bar" name="bar" size=1>
			<%
			//parse out the results
			while (result.next()) { %>
			<option><%= result.getString("name") %></option>
			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</select>
		<br>
		<br>
		<label for="option">Information:</label>
		<br>
		<select id="option" name="option" size=1>
			<option value="largestSpenders">Largest Spenders</option>
			<option value="popularBeers">Popular Beers</option>
			<option value="topManufacturers">Top Manufacturers</option>
			<option value="busiestPeriods">Graph Busiest Periods</option>
		</select> 
		<br>
		<br>
		<input style="cursor:pointer;" class="btn-gradient blue small" type="submit" value="Submit">
	</form>
	<br>
	<iframe id="results" onLoad="iframeLoaded()" name="results" style="border:none; flex-grow:1;"></iframe>
	<%} catch (Exception e) {
			out.print(e);
		}%>
</body>
</html>