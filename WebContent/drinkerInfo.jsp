<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script>
function submitInfo(s){
	document.getElementById("bill_id").value = s;
	document.getElementById("info").target="_blank"
	document.getElementById("info").submit();
	
}
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

		String drinker = request.getParameter("drinker").replace("'", "''");
		String option = request.getParameter("option");

		String bars = "";

		if (option.equals("showTransactions")) {
		bars = "select distinct bar from bills where drinker=\"" + drinker + "\"";
		ResultSet barsResult = stmt1.executeQuery(bars);
	%>

	<!--  Make an HTML table to show the infoResults in: -->
	<%
		while (barsResult.next()) {
	%>
	<%
		Statement stmt2 = con.createStatement();
	String info = "select * from bills where drinker=\"" + drinker + "\" and bar = \"" + barsResult.getString("bar")
			+ "\" order by date asc, time asc";
	ResultSet infoResult = stmt2.executeQuery(info);
	%>
	<table class="styled-table">
	<caption><%=barsResult.getString("bar")%></caption>
		<thead>
			<tr>
				<th>Bill ID</th>
				<th>Item Price</th>
				<th>Tax Price</th>
				<th>Tip</th>
				<th>Total</th>
				<th>Bartender</th>
				<th>Day</th>
				<th>Date</th>
				<th>Time</th>
			</tr>
		</thead>
		<%
			//parse out the infoResults
		while (infoResult.next()) {
		%>
		<tr>
			<form id="info" method="post" action="transactionInfo.jsp">
				<input id="bill_id" type="hidden" name="bill_id">
				<td class="id" onclick="submitInfo('<%=infoResult.getString("bill_id")%>')"><%=infoResult.getString("bill_id")%></td>
			</form>
			<td><%=infoResult.getString("items_price")%></td>
			<td><%=infoResult.getString("tax_price")%></td>
			<td><%=infoResult.getString("tip")%></td>
			<td><%=infoResult.getString("total_price")%></td>
			<td><%=infoResult.getString("bartender")%></td>
			<td><%=infoResult.getString("day")%></td>
			<td><%=infoResult.getString("date")%></td>
			<td><%=infoResult.getString("time")%></td>
		</tr>
		<%
			}
		infoResult.close();
		%>
	</table>
	<%
		}
	barsResult.close();
	%>
	<%
		} else if (option.equals("graphBeers")) {
			StringBuilder myData=new StringBuilder();
			String strData ="";
		    String chartTitle="";
		    String legend="";
			ArrayList<Map<String,Integer>> list = new ArrayList();
	   		Map<String,Integer> map = null;
	   		
	   		String query = "select item as beer, sum(quantity) as nmb_beer from(select item, quantity from transactions, bills where bills.bill_id = transactions.bill_id and bills.drinker='" + drinker + "' and transactions.type='beer') as beers group by item";
	   		ResultSet result = stmt1.executeQuery(query);
	   		
	   		while (result.next()) { 
	   			map=new HashMap<String,Integer>();
	   	   		map.put(result.getString("beer"),result.getInt("nmb_beer"));
	   			list.add(map);
	   	    } 
	   	    result.close();
	   	    
	   	 for(Map<String,Integer> hashmap : list){
     		Iterator it = hashmap.entrySet().iterator();
         	while (it.hasNext()) { 
        		Map.Entry pair = (Map.Entry)it.next();
        		String key = pair.getKey().toString().replaceAll("'", "");
        		myData.append("['"+ key +"',"+ pair.getValue() +"],");
        	}
	     }
	     strData = myData.substring(0, myData.length()-1);
	     chartTitle = "Number of beers purchased";
         legend = "Beers";
         
         
		%>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
		
			var data = [<%=strData%>]; //contains the data of the graph in the form: [ ["Caravan", 3],["Cabana",2],...]
			var title = '<%=chartTitle%>'; 
			var legend = '<%=legend%>';
			var cat = [];
			data.forEach(function(item) {
			  cat.push(item[0]);
			});
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
				        	text: 'Amount'
				        }
				    },
				    series: [{
				        name: legend,
				        data: data
				    }]
				});
			});
		
		</script>
		<div id="graphContainer"></div>
		<%}else{
			bars = "select distinct bar from bills where drinker=\"" + drinker + "\"";
			ResultSet barsResult = stmt1.executeQuery(bars);
			Map<String, String> vars = new HashMap<String, String>();
			while(barsResult.next()){
				vars.put(barsResult.getString("bar"), null);
			}
			String chartTitle="";
		    String legend="";
		    barsResult.beforeFirst();
			while(barsResult.next()){
				StringBuilder myData=new StringBuilder();
				ArrayList<Map<String,Double>> list = new ArrayList();
		   		Map<String,Double> map = null;
		   		
		   		Statement stmt2 = con.createStatement();
		   		String query = "select sum(total_price) as spent, day from bills where bar = '" + barsResult.getString("bar") + "' and drinker='" + drinker + "' group by day";
		   		ResultSet result = stmt2.executeQuery(query);
		   		
		   		while (result.next()) { 
		   			map=new HashMap<String,Double>();
		   	   		map.put(result.getString("day"),result.getDouble("spent"));
		   			list.add(map);
		   	    } 
		   	    result.close();
		   	    
		   	 for(Map<String,Double> hashmap : list){
	     		Iterator it = hashmap.entrySet().iterator();
	         	while (it.hasNext()) { 
	        		Map.Entry pair = (Map.Entry)it.next();
	        		String key = pair.getKey().toString().replaceAll("'", "");
	        		myData.append("['"+ key +"',"+ pair.getValue() +"],");
	        	}
		     }
		     vars.put(barsResult.getString("bar"), myData.substring(0, myData.length()-1));
			}
		     chartTitle = "Money spent at each bar per day";
	         legend = "Day";
	         %>
			<script> 
			
				var title = '<%=chartTitle%>'
				var cat = ['Sunday','Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
				document.addEventListener('DOMContentLoaded', function () {
					var graph = Highcharts.chart('perDay', {
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
					        	text: 'Total Spent'
					        }
					    }
					});
					<% Iterator it = vars.entrySet().iterator();
		         	while (it.hasNext()) {
		         		String[] cats = {"Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"};
		         		Map.Entry pair = (Map.Entry)it.next();
		         		String key = pair.getKey().toString().replaceAll("'", "");
		         		String value = pair.getValue().toString();
		         		String[] splits = value.split("],");
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
		         		graph.addSeries({
		         			type:'column',
		         			name: '<%=key%>',
		         			data: data
		         		});
		         	<%}%>
				});
			
			</script>
			<div id="perDay"></div>
			<br>
			<%
			vars = new HashMap<String, String>();
			while(barsResult.next()){
				vars.put(barsResult.getString("bar"), null);
			}
			barsResult.beforeFirst();
			while(barsResult.next()){
				StringBuilder myData=new StringBuilder();
				ArrayList<Map<String,Double>> list = new ArrayList();
		   		Map<String,Double> map = null;
		   		
		   		Statement stmt2 = con.createStatement();
		   		String query = "select sum(total_price) as spent, monthname(date) as month from bills where bar = '" + barsResult.getString("bar") + "' and drinker='" + drinker + "' group by month(date)";
		   		ResultSet result = stmt2.executeQuery(query);
		   		
		   		while (result.next()) { 
		   			map=new HashMap<String,Double>();
		   	   		map.put(result.getString("month"),result.getDouble("spent"));
		   			list.add(map);
		   	    } 
		   	    result.close();
		   	    
		   	 for(Map<String,Double> hashmap : list){
	     		Iterator it1 = hashmap.entrySet().iterator();
	         	while (it1.hasNext()) { 
	        		Map.Entry pair = (Map.Entry)it1.next();
	        		String key = pair.getKey().toString().replaceAll("'", "");
	        		myData.append("['"+ key +"',"+ pair.getValue() +"],");
	        	}
		     }
		     vars.put(barsResult.getString("bar"), myData.substring(0, myData.length()-1));
			}
			barsResult.close();
		     String chartTitle2 = "Money spent at each bar per month";
	         %>
			<script> 
			
				var title2 = '<%=chartTitle2%>'
				var cat2 = ["January","February", "March", "April", "May", "June", "July", "August", "Spetember", "October", "November", "December"];
				document.addEventListener('DOMContentLoaded', function () {
					var graph2 = Highcharts.chart('perMonth', {
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
					        	text: 'Total Spent'
					        }
					    }
					});
					<% Iterator it1 = vars.entrySet().iterator();
		         	while (it1.hasNext()) {
		         		String[] cats = {"January","February", "March", "April", "May", "June", "July", "August", "Spetember", "October", "November", "December"};
		         		Map.Entry pair = (Map.Entry)it1.next();
		         		String key = pair.getKey().toString().replaceAll("'", "");
		         		String value = pair.getValue().toString();
		         		String[] splits = value.split("],");
		         		String[] data = {"0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"};
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
		         		var data2 = [<%=data[0]%>, <%=data[1]%>,<%=data[2]%>, <%=data[3]%>, <%=data[4]%>, <%=data[5]%>, <%=data[6]%>, <%=data[7]%>, <%=data[8]%>, <%=data[9]%>, <%=data[10]%>, <%=data[11]%>]
		         		graph2.addSeries({
		         			type:'column',
		         			name: '<%=key%>',
		         			data: data2
		         		});
		         	<%}%>
				});
			
			</script>
			<div id="perMonth"></div>
		<%}%>
	<%	
	db.closeConnection(con);
	}catch (Exception e) {
	%>	
		<script>
			alert("There was an error!");
		</script>
	<%	
	}
	%>


</body>
</html>