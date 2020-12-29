<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<style type="text/css">
.styled-table {
    border-collapse: collapse;
    margin: 25px 0;
    font-family: sans-serif;
    min-width: 400px;
    box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
}

.styled-table thead tr {
    background-color: #009879;
    color: #ffffff;
    text-align: left;
}

.styled-table th{
	padding: 12px 15px;
	font-size: 16px;
}

.styled-table td {
    padding: 12px 15px;
    font-size:14px;
}

.styled-table tbody tr {
    border-bottom: 1px solid #dddddd;
}

.styled-table tbody tr:nth-of-type(even) {
    background-color: #f3f3f3;
}

.styled-table tbody tr:last-of-type {
    border-bottom: 2px solid #009879;
}

caption {
	color: #ffffff;
	padding: .2em .8em;
	border: 1px solid #fff;
	background: #006e57;
	font-weight: bold;
	font-size: 24px;
}
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Transaction Information</title>
</head>
<body style="display:flex; flex-direction:column; min-height:calc(100vh-30px);">
	<%
		try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		String bill_id = request.getParameter("bill_id");

		String transaction = "select * from transactions where bill_id = \"" + bill_id + "\" order by price desc";
		ResultSet result = stmt.executeQuery(transaction);

	%>
	<table class="styled-table">
	<caption>Details for transaction: "<%=bill_id%>"</caption>
		<thead>
			<tr>
				<th>Item</th>
				<th>Quantity</th>
				<th>Price</th>
				<th>Type</th>
			</tr>
		</thead>
		<%
		while(result.next()){
		%>
		<tr>
			<td><%=result.getString("item")%></td>
			<td><%=result.getString("quantity")%></td>
			<td><%=result.getString("price")%></td>
			<td><%=result.getString("type")%></td>
		</tr>
		<%	
		}
		%>
	</table>	
	<%
		db.closeConnection(con);
	%>
	<% 
	}catch (Exception e) {
		out.print(e);
	}
	%>


</body>
</html>