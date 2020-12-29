<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="https://code.highcharts.com/highcharts.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Modify</title>
<link href="css/chooseMod.css" type="text/css" rel="stylesheet" />
</head>
<script>
function onClick(){
	document.getElementById("goback").target="_self";
	document.getElementById("goback").submit();
}
</script>
<body style="display:flex; flex-direction:column;">
	<%
		String modType = request.getParameter("modType");
		String table = request.getParameter("table");
		String id = request.getParameter("id");
		try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		
		if(modType.equals("add")){
			Statement st = con.createStatement();
			String query1 = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'beerbardrinkerplus' AND TABLE_NAME = '" + table + "'";
			ResultSet columns = st.executeQuery(query1);	
			ArrayList<String> columnNames = new ArrayList<String>();
			while(columns.next()){
				if(!columns.getString("COLUMN_NAME").equals("id")){
					columnNames.add(columns.getString("COLUMN_NAME"));
				}
			}
			
		%>
			<form name="add" method="post" action="doAdd.jsp">
				<%
				for(String col : columnNames){
				%>
					<%=col%>:<input type="text" name=<%=col%>>
					<br>
					<br>
				<%}%>
				<input name="table" type="hidden" value="<%=table%>">
				<input class="btn-gradient blue small" style="cursor:pointer;" type="submit" value="Submit">
			</form>
		<%	
		}
		%>
		
		<%
		if(modType.equals("update")){
			Statement st1 = con.createStatement();
			Statement stmt2 = con.createStatement();
			String query1 = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'beerbardrinkerplus' AND TABLE_NAME = '" + table + "'";
			ResultSet columns = st1.executeQuery(query1);	
			ArrayList<String> columnNames = new ArrayList<String>();
			while(columns.next()){
				if(!columns.getString("COLUMN_NAME").equals("id")){
					columnNames.add(columns.getString("COLUMN_NAME"));
				}
			}
			
			String query2 = "select * from " + table + " where id='" + request.getParameter("id") + "'";
			ResultSet row = stmt2.executeQuery(query2);
			row.next();
		%>
			<form name="update" method="post" action="doUpdate.jsp">
				<%
				for(String col : columnNames){
				%>
					<%=col%>:<input type="text" name=<%=col%> value="<%=row.getString(col)%>">
					<br>
					<br>
				<%}%>
				<input name="table" type="hidden" value="<%=table%>">
				<input name="id" type="hidden" value="<%=id%>">
				<input class="btn-gradient blue small" style="cursor:pointer;" type="submit" value="Submit">
			</form>
		<%	
		}
		%>
		<%
		if(modType.equals("delete")){
			Statement st = con.createStatement();
			String query = "DELETE FROM " + table + " WHERE id='" + id + "'";
			int i=st.executeUpdate(query);
		%>
		<form id="goback" method="post" action="chooseMod.jsp">
			<input id="table" type="hidden" name="table" value="<%=table%>">
			<h2>Deletion successful!</h2>
			<button class="btn-gradient blue small" style="cursor:pointer;" onclick="onClick()">Go back</button>
		</form>
		<%
		}%>
		<%
		db.closeConnection(con);
		}catch (Exception e) {
		%>
		<form id="fail" method="post" action="chooseMod.jsp">
			<input id="table" type="hidden" name="table" value="<%=table%>">
		</form>
		<script>
		alert("ERROR: Foreign Key violation!");
		document.getElementById("fail").target="_self";
		document.getElementById("fail").submit();
		</script>
		<%
		}
		%>


</body>
</html>