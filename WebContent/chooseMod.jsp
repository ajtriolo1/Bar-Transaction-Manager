<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="https://code.highcharts.com/highcharts.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Choose Modification</title>
<link href="css/chooseMod.css" type="text/css" rel="stylesheet" />
</head>
<body style="display:flex; flex-direction:column;">
<a href="Modifications.jsp"><button class="btn-gradient blue small" style="cursor:pointer; position:absolute; top:10px; right:10px;">Back</button></a>
	<%
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		try {

		//Get the database connection
		

		//Create a SQL statement
		Statement stmt1 = con.createStatement();
		Statement stmt2 = con.createStatement();

		String table = request.getParameter("table");
		
		String query1 = "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'beerbardrinkerplus' AND TABLE_NAME = '" + table + "'";
		ResultSet columns = stmt1.executeQuery(query1);	
		ArrayList<String> columnNames = new ArrayList<String>(); 
		
		String query2 = "select * from " + table;
		ResultSet rows = stmt2.executeQuery(query2);
		%>
		<a href="performMod.jsp?modType=add&table=<%=table%>" style="position:absolute"><button style="cursor:pointer;" class="btn-gradient blue small">Add Entry</button></a>
		<br>
		<table class=styled-table>
		<caption><%=table%></caption>
			<thead>
			<% 
			while(columns.next()){
				if(!columns.getString("COLUMN_NAME").equals("id")){
					columnNames.add(columns.getString("COLUMN_NAME"));
			%>
					<th><%=columns.getString("COLUMN_NAME")%></th>
			<%	
				}
			}
			%>
				<th>Modification</th>		
			</thead>
			<tbody>
				<%
				while(rows.next()){
				%>
					<tr>
						<%
						for(String col : columnNames){
						%>
							<td><%=rows.getString(col)%></td>
						<%}%>
							<td><a href="performMod.jsp?id=<%=rows.getString("id")%>&modType=update&table=<%=table%>"><button style="cursor:pointer;" class="btn-gradient green small">Update</button></a>
								<a href="performMod.jsp?id=<%=rows.getString("id")%>&modType=delete&table=<%=table%>"><button style="cursor:pointer;" class="btn-gradient green small">Delete</button></a>
							</td>
					</tr>
				<% 	
				}
				%>
			</tbody>
		</table>
		<%
		db.closeConnection(con);
		}catch (Exception e) {
			System.out.print(e);
		}
		%>


</body>
</html>