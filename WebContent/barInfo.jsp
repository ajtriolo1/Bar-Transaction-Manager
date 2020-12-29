<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*, java.text.DecimalFormat"%>
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
		DecimalFormat df = new DecimalFormat("0.00");
		//Get the database connection
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt1 = con.createStatement();
		Statement stmt2 = con.createStatement();

		String bar = request.getParameter("bar").replace("'", "''");
		String option = request.getParameter("option");

		if (option.equals("largestSpenders")) {
			String query = "select drinker, sum(total_price) as amt_spent from bills where bar='" + bar + "' group by drinker order by amt_spent desc limit 10";
			ResultSet spentResult = stmt1.executeQuery(query);
	%>

	<!--  Make an HTML table to show the infoResults in: -->
		<table class="styled-table">
		<caption>Top 10 drinkers at <%=bar.replace("''", "'")%></caption>
			<thead>
				<tr>
					<th>Drinker</th>
					<th>Amount Spent</th>
				</tr>
			</thead>
			<tbody>
			<%
			while (spentResult.next()) {
			%>
				<tr>
					<td><%=spentResult.getString("drinker")%></td>
					<td><%=df.format(spentResult.getDouble("amt_spent"))%></td>
				</tr>
			<%
			}
			spentResult.close();
			%>
			</tbody>
		</table>
	<%
		}else if (option.equals("popularBeers")){
			String query = "select item as beer, sum(quantity) as amt_sold from transactions, bills where transactions.bill_id=bills.bill_id and bills.bar='" + bar + "' and transactions.type='beer' group by beer order by amt_sold desc limit 10";
			ResultSet soldResult = stmt1.executeQuery(query);
		%>
			<table class="styled-table">
			<caption>Top 10 beers sold at <%=bar.replace("''", "'")%></caption>
				<thead>
					<tr>
						<th>Beer</th>
						<th>Amount Sold</th>
					</tr>
				</thead>
				<tbody>
				<%
				while (soldResult.next()) {
				%>
					<tr>
						<td><%=soldResult.getString("beer")%></td>
						<td><%=soldResult.getString("amt_sold")%></td>
					</tr>
				<%
				}
				soldResult.close();
				%>
				</tbody>
			</table>
		<%	
		} else if (option.equals("topManufacturers")){
			String query = "select manf, sum(quantity) as amt_sold from beer, transactions, bills where transactions.bill_id=bills.bill_id and bills.bar='" + bar + "' and transactions.type='beer' and beer.name = transactions.item group by manf order by amt_sold desc limit 5";
			ResultSet soldResult = stmt1.executeQuery(query);
		%>
			<table class="styled-table">
				<caption>Top 5 selling manufacturers at <%=bar.replace("''", "'")%></caption>
					<thead>
						<tr>
							<th>Manufacturer</th>
							<th>Amount Sold</th>
						</tr>
					</thead>
					<tbody>
					<%
					while (soldResult.next()) {
					%>
						<tr>
							<td><%=soldResult.getString("manf")%></td>
							<td><%=soldResult.getString("amt_sold")%></td>
						</tr>
					<%
					}
					soldResult.close();
					%>
					</tbody>
				</table>
		<%
		} else{
			String query = "select day, count(*) as nmb_trans from bills where bar='" + bar + "' group by day";
			ResultSet soldResult = stmt1.executeQuery(query);
			Map<String, String> map = null;
			StringBuilder myData=new StringBuilder();
			ArrayList<Map<String,String>> list = new ArrayList();
			String strData ="";
		    String chartTitle="";
		    String legend="";
			while (soldResult.next()) { 
	   			map=new HashMap<String,String>();
	   	   		map.put(soldResult.getString("day"),soldResult.getString("nmb_trans"));
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
			strData = myData.substring(0, myData.length()-1);
			chartTitle = "Busiest periods of the week for " + bar.replace("''", "\\'");
			legend = bar.replace("''", "\\'");
		%>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
			var title = '<%=chartTitle%>'; 
			var legend = '<%=legend%>';
			var cat = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
			document.addEventListener('DOMContentLoaded', function () {
				var perDay = Highcharts.chart('perDay', {
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
				        	text: 'Transactions'
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
         		perDay.addSeries({
         			type:'column',
         			name: legend,
         			data: data
         		});
			});
		
		</script>
		<div id="perDay"></div>
		<br>
		<br>
		<%
		String query2 = "select hour(bills.time) as hour, count(*) as nmb_trans from bills where bar='" + bar + "' group by hour(bills.time) order by hour(bills.time) asc";
		ResultSet soldResult2 = stmt2.executeQuery(query2);
		Map<String, String> map2 = null;
		StringBuilder myData2=new StringBuilder();
		ArrayList<Map<String,String>> list2 = new ArrayList();
		String strData2 ="";
	    String chartTitle2="";
	    String legend2="";
		while (soldResult2.next()) { 
   			map2=new HashMap<String,String>();
   	   		map2.put(soldResult2.getString("hour"),soldResult2.getString("nmb_trans"));
   			list2.add(map2);
   	    } 
   	    soldResult2.close();
   	    
   	 	for(Map<String,String> hashmap : list2){
     		Iterator it2 = hashmap.entrySet().iterator();
         	while (it2.hasNext()) { 
        		Map.Entry pair = (Map.Entry)it2.next();
        		String key = pair.getKey().toString().replaceAll("'", "");
        		myData2.append("['"+ key +"',"+ pair.getValue() +"],");
        	}
	     }
		strData2 = myData2.substring(0, myData2.length()-1);
		chartTitle2 = "Busiest periods of the day for " + bar.replace("''", "\\'");
		legend2 = bar.replace("''", "\\'");
		%>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
			var data2 = [<%=strData2%>];
			var title2 = '<%=chartTitle2%>'; 
			var legend2 = '<%=legend2%>';
			var cat2 = [];
			data2.forEach(function(item) {
				  cat2.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function () {
				var perHour = Highcharts.chart('perHour', {
				    chart: {
				        defaultSeriesType: 'column',
				    },
				    title: {
				        text: title2
				    },
				    xAxis: {
				        categories: cat2
				    },
				    yAxis: {
				        title: {
				        	text: 'Transactions'
				        }
				    },
				    series: [{
		     			name: legend2,
		     			data: data2
				    }]
				});
			});
		</script>
		<div id="perHour"></div>
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