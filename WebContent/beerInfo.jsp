<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
parent.iframeLoaded();
</script>
<script src="https://code.highcharts.com/highcharts.js"></script>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link href="css/drinkerInfo.css" type="text/css" rel="stylesheet" />
</head>
<body style="display:flex; flex-direction:column; overflow:hidden;">
	<%
		try {
		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt1 = con.createStatement();

		String beer = request.getParameter("beer").replace("'", "''");
		String option = request.getParameter("option");

		if (option.equals("topBars")) {
			String query = "select bar, sum(quantity) as amt_sold from bills, transactions where bills.bill_id=transactions.bill_id and transactions.item ='" + beer + "' group by bills.bar order by sum(quantity) desc limit 5";
			ResultSet soldResult = stmt1.executeQuery(query);
	%>

	<!--  Make an HTML table to show the infoResults in: -->
		<table class="styled-table">
		<caption>Top 5 sellers of <%=beer.replace("''","'")%></caption>
			<thead>
				<tr>
					<th>Bar</th>
					<th>Amount Sold</th>
				</tr>
			</thead>
			<tbody>
			<%
			while (soldResult.next()) {
			%>
				<tr>
					<td><%=soldResult.getString("bar")%></td>
					<td><%=soldResult.getString("amt_sold")%></td>
				</tr>
			<%
			}
			soldResult.close();
			%>
			</tbody>
		</table>
	<%
		}else if (option.equals("topDrinkers")){
			String query = "select drinker, sum(quantity) as amt from bills, transactions where bills.bill_id=transactions.bill_id and transactions.item='" + beer + "' group by drinker order by amt desc limit 10";
			ResultSet boughtResult = stmt1.executeQuery(query);
		%>
			<table class="styled-table">
			<caption>Top 10 drinkers of <%=beer.replace("''","'")%></caption>
				<thead>
					<tr>
						<th>Beer</th>
						<th>Amount Purchased</th>
					</tr>
				</thead>
				<tbody>
				<%
				while (boughtResult.next()) {
				%>
					<tr>
						<td><%=boughtResult.getString("drinker")%></td>
						<td><%=boughtResult.getString("amt")%></td>
					</tr>
				<%
				}
				boughtResult.close();
				%>
				</tbody>
			</table>
		<%	
		} else{
			String query = "select day, sum(quantity) as amt from bills, transactions where bills.bill_id=transactions.bill_id and transactions.item='" + beer + "' group by day";
			ResultSet soldResult = stmt1.executeQuery(query);
			Map<String, String> map = null;
			StringBuilder myData=new StringBuilder();
			ArrayList<Map<String,String>> list = new ArrayList();
			String strData ="";
		    String chartTitle="";
		    String legend="";
			while (soldResult.next()) { 
	   			map=new HashMap<String,String>();
	   	   		map.put(soldResult.getString("day"),soldResult.getString("amt"));
	   			list.add(map);
	   	    } 
	   	    soldResult.close();
	   	    
	   	 for(Map<String,String> hashmap : list){
	     		Iterator it = hashmap.entrySet().iterator();
	         	while (it.hasNext()) { 
	        		Map.Entry pair = (Map.Entry)it.next();
	        		String key = pair.getKey().toString().replaceAll("'", "");
	        		myData.append("['"+ key +"',"+ pair.getValue() +"],");
	        	}
		     }
	   	String replaced = beer.replace("''", "\\'");
		strData = myData.substring(0, myData.length()-1);
		chartTitle = replaced + " sold per day";
		legend = replaced;
		%>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
			var title = '<%=chartTitle%>'; 
			var legend = '<%=legend%>';
			var cat = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
			document.addEventListener('DOMContentLoaded', function () {
				var myChart = Highcharts.chart('graphContainer', {
				    chart: {
				        defaultSeriesType: 'column',
				    },
				    title: {
				        text: title
				    },
				    xAxis: {
				        categories: cat
				    },
				    yAxis: {
				        title: {
				        	text: 'Amount Sold'
				        }
				    }
				});
				<%
         		String[] cats = {"Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
         		String[] splits = strData.split("],");
         		String[] data = {"0", "0", "0", "0", "0", "0", "0"};
         		for(int i = 0; i<cats.length; i++){
         			for(int j = 0; j<splits.length; j++){
         				if(splits[j].contains(cats[i])){
         					if(j==splits.length-1){
         						data[i] = splits[j];
         					}else{
         						data[i] = splits[j] + "]";
         					}
         				}
         			}
         		}	
	         	%>
         		var data = [<%=data[0]%>, <%=data[1]%>,<%=data[2]%>, <%=data[3]%>, <%=data[4]%>, <%=data[5]%>, <%=data[6]%>]
         		myChart.addSeries({
         			type:'column',
         			name: '<%=replaced%>',
         			data: data
         		});
			});
		
		</script>
		<div id="graphContainer"></div>
		<%
		}
		%>
	<%	
	db.closeConnection(con);
	}catch (Exception e) {
	%>	
		<script>
			alert("<%=e%>")
		</script>
	<%	
	}
	%>


</body>
</html>