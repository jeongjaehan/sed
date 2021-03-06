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
	        		
			<div class="span9">
				<form class="form-search">
					<div class="hero-unit">
						<label>X :</label> <input class="span2" type="text" placeholder="X" value="949038" id="X">
						<label>Y :</label><input class="span2" type="text" placeholder="Y" value="1943842" id="Y">
						<label>places:</label><input class="span1" type="text" placeholder="places" value="10" id="places">
						<label>addrs:</label><input class="span1" type="text" placeholder="addrs" value="10" id="addrs">
						<label>newaddrs:</label><input class="span1" type="text" placeholder="newaddrs" value="10" id="newaddrs">
						<label>option:</label><input class="span1" type="text" placeholder="option" value="1" id="option">
						<br/>
						<label>Query:</label><input type="text" class="input-xlarge" placeholder="검색어를 입력하세요." id="Query" value="중국집">
						<button type="button" class="btn" id="btnSearch">결과확인</button>
					</div>
					
					<div class="span10">
							<label>
								<span id="skeyword"></span> 
								<span id="totalcnt"></span>
							</label>
							<table class="table table-hover" id="searchTable">
								<tr>
									<th>DOCID</th>
									<th>NAME</th>
									<th>UJ_NAME</th>
									<th>X</th>
									<th>Y</th>
									<th>ADDR</th>
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
		var ollemapUrl="/Sed/apis/search/ollehmap";
		
		/*
		* add table row
		*/
		function addRow(item){
		   var rows =  $("#searchTable tr");
		   var idx = rows.length;
		   //console.log("idx : %d",idx);
		   
		   //http://wiki.kthcorp.com/pages/viewpage.action?pageId=26718600
		   $("#searchTable").append(
		    "<tr id='id_"+idx+"' class='rows'>"
		     +"<td>"+item.DOCID+"</td>"
		     +"<td>"+item.NAME+"</td>"
		     +"<td>"+item.UJ_NAME+"</td>"
		     +"<td>"+item.X+"</td>"
		     +"<td>"+item.Y+"</td>"
		     +"<td>"+item.ADDR+"</td>"
		     +"<td>"+item.TEL+"</td>"
		    +"</tr>"
		   );
	  	}
		
		/*
		* 모든 row 삭제
		*/
		function deleteAllRow(){
		   var rows = $(".rows");
		   rows.remove();
  		}
		
		function getJsonData(){
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
					$("#skeyword").text("["+data.RESULTDATA.QueryResult.Querystr+"] 에 대한 결과");
					$("#totalcnt").text("["+place.TotalCount+"] 건 검색됨");
					
					if(place.TotalCount==0){ // 검색결과 없음
						   $("#searchTable").append(
								    "<tr class='rows info'>"
								     +"<td colspan=10>검색결과 없음</td>"
								    +"</tr>"
						   );
					}else{
					    $.each(place.Data, function(i,item){
					    	addRow(item);
					    }); 
				  	}
			  });
		}
		
		function doSearch(){
			deleteAllRow();
			getJsonData();
		}
	
		$('#btnSearch').click(function (){
			doSearch();
		});
		
		$('#Query').keyup(function (e){
			//alert(e.keyCode);
			if(e.keyCode==13)
				doSearch();
		});

		/*
		* 메뉴 선택 
		*/
		$(document).ready(function(){
			url = document.URL;
			url = url.substring(url.lastIndexOf("/")+1,url.length);
			
			if(url=="iminSearch.jsp"){
				$('.menu1').addClass("active");
			}else if(url=="ollehMapSearch.jsp"){
				$('.menu2').addClass("active");
			}else if(url=="etriSearch.jsp"){
				$('.menu3').addClass("active");
			}else if(url=="allSearch.jsp"){
				$('.menu4').addClass("active");
			}
		});
	</script>
</body>
</html>