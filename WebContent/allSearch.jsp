<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>검색엔진 비교</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link href="public/css/bootstrap-responsive.css" rel="stylesheet">
<link href="public/css/bootstrap.css" rel="stylesheet">
<link href="public/js/bootstrap.js" rel="stylesheet">
<!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
<!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
 <![endif]-->
<style type="text/css">
body {
	padding-top: 60px;
	padding-bottom: 40px;
}

.sidebar-nav {
	padding: 9px 0;
}
</style>
</head>
<body>
<%@include file="inc/top_menu.jsp" %>
	
	<div class="container-fluid">
		<div class="row-fluid">
<!-- left menu -->
<%@include file="inc/left_menu.jsp" %>
	        
			<div class="span10">
				<form class="form-search">
					<!-- imin  hidden parameter -->
					<input type="hidden" id="pg" value="1">
					<input type="hidden" id="pivot" value="20000">
					<input type="hidden" id="csort" value="RANK">
					<input type="hidden" id="loc_range" value="0">
					<input type="hidden" id="f" value="j">
					
					<!-- ollehmap  hidden parameter -->
					<input type="hidden" id="addrs" value="10">
					<input type="hidden" id="newaddrs" value="10">
					<input type="hidden" id="option" value="1">
					
					<div class="hero-unit">
						<label>X :</label> <input class="span2" type="text" placeholder="X" value="949038" id="X">
						<label>Y :</label><input class="span2" type="text" placeholder="Y" value="1943842" id="Y">
						<label>places:</label><input class="span1" type="text" placeholder="places" value="10" id="places">
						<br/>
						<label>Query:</label><input type="text" class="input-xlarge" placeholder="검색어를 입력하세요." id="Query" value="중국집">
						<button type="button" class="btn" id="btnSearch">결과확인</button>
					</div>
					
					<div class="span4">
							<label>
								<b>아임인 검색</b>
								<span id="keyword1"></span> 
								<span id="totalcnt1"></span>
							</label>
							<table class="table table-hover" id="searchTable1">
								<tr>
									<th>no</th>
									<th>NAME</th>
									<th>X</th>
									<th>Y</th>
									<th>TEL</th>
								</tr>
							</table>
					</div>
					
					<div class="span4">
							<label>
								<b>올레맵 검색</b>
								<span id="keyword2"></span> 
								<span id="totalcnt2"></span>
							</label>
							<table class="table table-hover" id="searchTable2">
								<tr>
									<th>no</th>
									<th>NAME</th>
									<th>X</th>
									<th>Y</th>
									<th>TEL</th>
								</tr>
							</table>
					</div>

				</form>
			</div>
		</div>
	</div>
	
	<footer>
		<p>&copy; kthcorp 2013</p>
	</footer>
	
	<!-- script area -->
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script type="text/javascript">
		var iminUrl="/Sed/apis/search/imin";
		var ollemapUrl="/Sed/apis/search/ollehmap";
		
		/*
		* add table row
		*/
		function addRow(item,tid){
		   var rows =  $("#"+tid+" tr");
		   var idx = rows.length;
			//console.log("idx : %d",idx);
		   
		   //http://wiki.kthcorp.com/pages/viewpage.action?pageId=26718600
		   $("#"+tid+"").append(
		    "<tr id='id_"+idx+"' class='rows'>"
		     +"<td>"+idx+"</td>"
		     +"<td>"+item.NAME+"</td>"
		     +"<td>"+item.X+"</td>"
		     +"<td>"+item.Y+"</td>"
		     +"<td>"+item.TEL+"</td>"
		    +"</tr>"
		   );
	  	}
		
		/*
		* 아임인 검색 api 호출 return json 
		*/
		function getJsonDataImin(){
			$.getJSON(iminUrl,
				  {
					loc_x: $('#X').val(),
					loc_y: $('#Y').val(),
					loc_range: $('#loc_range').val(),
					list_cnt: $('#places').val(),
					pg: $('#pg').val(),
					pivot: $('#pivot').val(),
					csort: $('#csort').val(),
				    f: $('#f').val(),
				    Query: $('#Query').val()
				  },
				  function(data) {
					$("#keyword1").text("["+data.Query+"] 에 대한 결과");
					$("#totalcnt1").text("["+data.totalcnt+"] 건 검색됨");
					
					if(data.totalcnt==0){ // 검색결과 없음
						   $("#searchTable1").append(
								    "<tr class='rows info'>"
								     +"<td colspan=10>검색결과 없음</td>"
								    +"</tr>"
						   );
					}else{
					    $.each(data.items, function(i,item){
					    	addRow(item,"searchTable1");
					    });
				  }
			  });
		}
		
		/*
		* 올레맵 검색 api 호출 return json 
		*/
		function getJsonDataOllehmap(){
			$.getJSON(ollemapUrl,
				  {
					X: $('#X').val(),
					Y: $('#Y').val(),
					places: $('#places').val(),
					addrs: $('#addrs').val(),
					newaddrs: $('#newaddrs').val(),
					option: $('#option').val(),
				    Query: $('#Query').val()
				  },
				  function(data) {
					place = data.RESULTDATA.place;
					//console.log(place);
					$("#keyword2").text("["+data.RESULTDATA.QueryResult.Querystr+"] 에 대한 결과");
					$("#totalcnt2").text("["+place.TotalCount+"] 건 검색됨");
					
					if(place.TotalCount==0){ // 검색결과 없음
						   $("#searchTable2").append(
								    "<tr class='rows info'>"
								     +"<td colspan=10>검색결과 없음</td>"
								    +"</tr>"
						   );
					}else{
					    $.each(place.Data, function(i,item){
					    	addRow(item,"searchTable2");
					    }); 
				  	}
			  });
		}
		
		
		/*
		* 모든 row 삭제
		*/
		function deleteAllRow(){
		   var rows = $(".rows");
		   rows.remove();
  		}
		
		/*
		* 모두 검색
		*/
		function doSearch(){
			deleteAllRow();	// 모든 검색 row 삭제
			getJsonDataImin();	// 아임인 검색 api 호출 
			getJsonDataOllehmap();	// 올래멥 검색 api 호출
		}
	
		$('#btnSearch').click(function (){
			doSearch();
		});
		
		$('#Query').keyup(function (e){
			//alert(e.keyCode);
			if(e.keyCode==13)
				doSearch();
		});

	</script>
</body>
</html>