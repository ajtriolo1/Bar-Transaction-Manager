<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link href="css/drinker.css" type="text/css" rel="stylesheet" />
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Welcome</title>
	</head>
	<body>
		<h1>Welcome to the BeerBarDrinker App!</h1>
		<h3>Choose which page you'd like to visit:</h3>
		<a href="Drinker.jsp"><button class="btn-gradient blue small">Drinker</button></a>
		<a href="Bar.jsp"><button class="btn-gradient blue small">Bar</button></a>
		<a href="Beer.jsp"><button class="btn-gradient blue small">Beer</button></a>
		<a href="Modifications.jsp"><button class="btn-gradient blue small">Modifications</button></a>
	</body>
</html>