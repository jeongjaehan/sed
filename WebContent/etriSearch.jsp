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

.loading {
  border:0;
  display:none;
  text-align: center;
  background: #FFFFF0;
  filter: alpha(opacity=60);
  opacity: alpha*0.6;
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
					
					<div class="hero-unit">
						<label>X :</label> <input class="span2" type="text" placeholder="X" value="949038" id="x">
						<label>Y :</label><input class="span2" type="text" placeholder="Y" value="1943842" id="y">
						<label>n:</label><input class="span1" type="text" placeholder="n" value="10" id="n">
						<label>p:</label><input class="span1" type="text" placeholder="p" value="1" id="p">
						<label>opt:</label><input class="span1" type="text" placeholder="opt" value="4" id="opt">
						<br/>
						<label>Query:</label><input type="text" class="input-xlarge" placeholder="검색어를 입력하세요." id="Query" value="중국집">
						<button type="button" class="btn" id="btnSearch">결과확인</button>
					</div>

					
					<div class="span10">
							<label>
								<span id="keyword"></span> 
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
	
		// api url 정의 
		var etriUrl="http://211.113.53.187:8080/MobileQA/apis/1/search";
		
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
		* etri 검색 api 호출 return json 
		*/
		function getXmlDataEtri(){
			
			$.ajax({
					url : etriUrl
					, dataType : 'xml'
					, data :  {					
						cur_x: $('#x').val(),
						cur_y: $('#y').val(),
						n: $('#n').val(),
						p: $('#p').val(),
						opt: $('#opt').val(),
					    q: $('#Query').val()
					  }
					  , error:function(xhr,status,e){       //에러 발생시 처리함수
							$('#searchTable').append(
								    "<tr class='rows error'>"
								     +"<td colspan=10>오류 발생!! 관리자에게 문의하세요.</td>"
								    +"</tr>"
						   );
					  }
					  , success : function(data) {
						    query = $(data).find("QUERY").text();
						    totalCount = $(data).find("TotalCount").text();
						    
							$("#keyword").text("["+query+"] 에 대한 결과");
							$("#totalcnt").text("["+totalCount+"] 건 검색됨");
							
							
							if($(data).find("Data").size()==0){ // 검색결과 없음
								$('#searchTable').append(
									    "<tr class='rows info'>"
									     +"<td colspan=10>검색결과 없음</td>"
									    +"</tr>"
							   );
							}else{
							    $.each($(data).find("Data"), function(idx,item){
							    	_item = {
							    				NAME : $(item).find("NM").text()
							    				,TEL : $(item).find("PN").text()
							    				,ADDR : $(item).find("AD").text()
							    				,UJ_NAME : $(item).find("UJ").text()
							    				,X : $(item).find("PX").text()
							    				,Y : $(item).find("PY").text()
							    				,DOCID : $(item).find("DOCID").text()
							    			};
							    	addRow(_item);
							    }); 
						  	}
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
			getXmlDataEtri();	// etri 검색 api 호출
		}
	
		
		// jquery event handler
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