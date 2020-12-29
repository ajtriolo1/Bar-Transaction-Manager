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
	
			ApplicationDB db = new ApplicationDB();
			Connection con = db.getConnection();		

			Statement stmt = con.createStatement();
			
			String str = "SELECT distinct name FROM beer";
			
			ResultSet result = stmt.executeQuery(str);
		%>

	<form method="post" action="beerInfo.jsp" target="results">
		<label for="beer">Beer:</label>
		<br>
		<select id="beer" name="beer" size=1>
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
			<option value="topBars">Top Bars</option>
			<option value="topDrinkers">Top Drinkers</option>
			<option value="soldMost">Graph Time Most Sold</option>
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