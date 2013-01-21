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
						<label>loc_x :</label> <input class="span2" type="text" placeholder="loc_x" value="949038.437500" id="loc_x">
						<label>loc_y :</label><input class="span2" type="text" placeholder="loc_y" value="1943842.250000" id="loc_y">
						<label>loc_range:</label><input class="span1" type="text" placeholder="loc_range" value="0" id="loc_range"><br/>
						<label>list_cnt:</label><input class="span1" type="text" placeholder="list_cnt" value="10" id="list_cnt">
						<label>pg:</label><input class="span1" type="text" placeholder="pg" value="1" id="pg">
						<label>pivot:</label><input class="span1" type="text" placeholder="pivot" value="20000" id="pivot">
						<label>csort:</label>
						<select class="span2" id="csort">
                			<option value="RANK" selected="selected">RANK</option>
			                <option value="DIS">DIS</option>
			                <option value="DATE">DATE</option>
		              	</select>						
						<label>f :</label><input class="span1" type="text" placeholder="f" value="j" id="f" readonly="readonly">
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
		var iminUrl="/Sed/apis/search/imin";
		
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
			$.getJSON(iminUrl,
				  {
					loc_x: $('#loc_x').val(),
					loc_y: $('#loc_y').val(),
					loc_range: $('#loc_range').val(),
					list_cnt: $('#list_cnt').val(),
					pg: $('#pg').val(),
					pivot: $('#pivot').val(),
					csort: $('#csort').val(),
				    f: $('#f').val(),
				    Query: $('#Query').val()
				  },
				  function(data) {
					$("#skeyword").text("["+data.Query+"] 에 대한 결과");
					$("#totalcnt").text("["+data.totalcnt+"] 건 검색됨");
					
					if(data.totalcnt==0){ // 검색결과 없음
						   $("#searchTable").append(
								    "<tr class='rows info'>"
								     +"<td colspan=10>검색결과 없음</td>"
								    +"</tr>"
						   );
					}else{
					    $.each(data.items, function(i,item){
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