<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script src="https://code.highcharts.com/highcharts.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add</title>
<link href="css/drinkerInfo.css" type="text/css" rel="stylesheet" />
</head>
<script>
function onLoad(){
	document.getElementById("goback").target="_self";
	document.getElementById("goback").submit();
}
</script>
<body style="display:flex; flex-direction:column;">
	<%
		String table = request.getParameter("table");
		try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement st=con.createStatement();

		String vals = "";
		String cols = "";
		List<String> parameterNames = new ArrayList<String>(request.getParameterMap().keySet());
		for(String name : parameterNames){
			if(!name.equals("table") && !name.equals("id")){
				cols+=name + ",";
				vals+= "'"+request.getParameter(name).replace("'", "''") + "',";
			}
		}
		cols = cols.substring(0, cols.length()-1);
		vals = vals.substring(0, vals.length()-1);
		int i=st.executeUpdate("insert into " + table + "(" + cols + ")values(" + vals + ")");
		%>
		<form id="goback" method="post" action="chooseMod.jsp">
			<input id="table" type="hidden" name="table" value="<%=table%>">
			<h2>Add successful!</h2>
			<button onclick="onClick()">Go back</button>
		</form>
		<%
		db.closeConnection(con);
		}catch (Exception e) {
		%>
			<form id="fail" method="post" action="chooseMod.jsp">
				<input id="table" type="hidden" name="table" value="<%=table%>">
			</form>
			<script>
			alert("ERROR: Primary Key violation!");
			document.getElementById("fail").target="_self";
			document.getElementById("fail").submit();
			</script>
		<%	
		}
		%>


</body>
</html>