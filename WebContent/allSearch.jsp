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
					
					<div class="row-fluid">
					
						<div class="span3" style="width: 30%;font-size:12px;">
								<label>
									<b>아임인 검색</b>
									<span id="keyword1"></span> 
									<span id="totalcnt1"></span>
								</label>
								<table class="table table-hover" id="searchTable1">
									<tr>
										<th>no</th>
										<th>NAME</th>
										<!-- <th>X</th> -->
										<!-- <th>Y</th> -->
										<th>UJ</th>
										<th>TEL</th>
									</tr>
								</table>
						</div>
						
						<div class="span3" style="width: 30%;font-size:12px;">
								<label>
									<b>올레맵 검색</b>
									<span id="keyword2"></span> 
									<span id="totalcnt2"></span>
								</label>
								<table class="table table-hover" id="searchTable2">
									<tr>
										<th>no</th>
										<th>NAME</th>
										<!-- <th>X</th> -->
										<!-- <th>Y</th> -->
										<th>UJ</th>
										<th>TEL</th>
									</tr>
								</table>
						</div>
						
						<div class="span3" style="width: 30%;font-size:12px;">
								<label>
									<b>에트리 검색</b>
									<span id="keyword3"></span> 
									<span id="totalcnt3"></span>
								</label>
								<table class="table table-hover" id="searchTable3">
									<tr>
										<th>no</th>
										<th>NAME</th>
										<!-- <th>X</th> -->
										<!-- <th>Y</th> -->
										<th>UJ</th>
										<th>TEL</th>
									</tr>
								</table>
						</div>
					</div>

				</form>
			</div>
		</div>
	</div>

	<div id="loading1" class="loading">
		<img src="public/img/ajax-loader.gif" />
	</div>
	<div id="loading2" class="loading">
		<img src="public/img/ajax-loader.gif" />
	</div>
	<div id="loading3" class="loading">
		<img src="public/img/ajax-loader.gif" />
	</div>

	<footer>
		<p>&copy; kthcorp 2013</p>
	</footer>
	
	<!-- script area -->
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script type="text/javascript">
	
		// api url 정의 
		var iminUrl="/Sed/apis/search/imin";
		var ollemapUrl="/Sed/apis/search/ollehmap";
		var etriUrl="http://211.113.53.187:8080/MobileQA/apis/1/search";
		
		/*
		* add table row
		*/
		function addRow(idx, item, tbl){
			idx = idx+1;
		   //http://wiki.kthcorp.com/pages/viewpage.action?pageId=26718600
		    uj_name = item.UJ_NAME;
			start = uj_name.lastIndexOf(">") + 1;
			end = uj_name.length;
			uj_name = uj_name.substring(start,end);	// 업종 소분류만 자르기 
			
		    tbl.append(
			    "<tr id='id_"+idx+"' class='rows'>"
			     +"<td>"+idx+"</td>"
			     +"<td>"+item.NAME+"</td>"
			     +"<td>"+uj_name+"</td>"
			     //+"<td>"+item.X+"</td>"
			     //+"<td>"+item.Y+"</td>"
			     +"<td>"+item.TEL+"</td>"
			    +"</tr>"
		    );
	  	 }
		
		/*
		* 아임인 검색 api 호출 return json 
		*/
		function getJsonDataImin(){
			var tbl = $('#searchTable1');
			$.ajax({
					url : iminUrl
					, dataType : 'json'
					, data :  {
						loc_x: $('#X').val(),
						loc_y: $('#Y').val(),
						loc_range: $('#loc_range').val(),
						list_cnt: $('#places').val(),
						pg: $('#pg').val(),
						pivot: $('#pivot').val(),
						csort: $('#csort').val(),
					    f: $('#f').val(),
					    Query: $('#Query').val()
				  	}
					, error:function(xhr,status,e){       //에러 발생시 처리함수
						tbl.append(
							    "<tr class='rows error'>"
							     +"<td colspan=10>오류 발생!! 관리자에게 문의하세요.</td>"
							    +"</tr>"
					   );
					}
				  	, success : function(data) {
						$("#keyword1").text("["+data.Query+"] 에 대한 결과");
						$("#totalcnt1").text("["+data.totalcnt+"] 건 검색됨");
						
						if(data.totalcnt==0){ // 검색결과 없음
								tbl.append(
									    "<tr class='rows info'>"
									     +"<td colspan=10>검색결과 없음</td>"
									    +"</tr>"
							   );
						}else{
						    $.each(data.items, function(idx,item){
						    	addRow(idx,item,tbl);
						    });
					  }
				  }
				  , beforeSend: function() {
						var padingTop = (Number((tbl.css('height')).replace("px","")) / 2) - 20;
						//통신을 시작할때 처리
						$('#loading1').css('position', 'absolute');
						$('#loading1').css('left', tbl.offset().left);
						$('#loading1').css('top', tbl.offset().top);
						$('#loading1').css('width', tbl.css('width'));
						$('#loading1').css('height', "100%");
						$('#loading1').css('padding-top', padingTop);
						$('#loading1').show().fadeIn('fast');
					}
					, complete: function() {
						//통신이 완료된 후 처리
						$('#loading1').fadeOut();
					}
			});
		}
		
		/*
		* 올레맵 검색 api 호출 return json 
		*/
		function getJsonDataOllehmap(){
			var tbl = $('#searchTable2');
			
			$.ajax({
					url : ollemapUrl
					, dataType : 'json'
					, data :  {					
						X: $('#X').val(),
						Y: $('#Y').val(),
						places: $('#places').val(),
						addrs: $('#addrs').val(),
						newaddrs: $('#newaddrs').val(),
						option: $('#option').val(),
					    Query: $('#Query').val()
					  }
					  , error:function(xhr,status,e){       //에러 발생시 처리함수
							tbl.append(
								    "<tr class='rows error'>"
								     +"<td colspan=10>오류 발생!! 관리자에게 문의하세요.</td>"
								    +"</tr>"
						   );
					  }
					  , success : function(data) {
						place = data.RESULTDATA.place;
						//console.log(place);
						$("#keyword2").text("["+data.RESULTDATA.QueryResult.Querystr+"] 에 대한 결과");
						$("#totalcnt2").text("["+place.TotalCount+"] 건 검색됨");
						
						if(place.TotalCount==0){ // 검색결과 없음
								tbl.append(
									    "<tr class='rows info'>"
									     +"<td colspan=10>검색결과 없음</td>"
									    +"</tr>"
							   );
						}else{
						    $.each(place.Data, function(idx,item){
						    	addRow(idx,item,tbl);
						    }); 
					  	}
				  	  }
					  , beforeSend: function() {
							var padingTop = (Number((tbl.css('height')).replace("px","")) / 2) - 20;
							//통신을 시작할때 처리
							$('#loading2').css('position', 'absolute');
							$('#loading2').css('left', tbl.offset().left);
							$('#loading2').css('top', tbl.offset().top);
							$('#loading2').css('width', tbl.css('width'));
							$('#loading2').css('height', "100%");
							$('#loading2').css('padding-top', padingTop);
							$('#loading2').show().fadeIn('fast');
						}
						, complete: function() {
							//통신이 완료된 후 처리
							$('#loading2').fadeOut();
						}			  
			});
		}
		
		/*
		* etri 검색 api 호출 return json 
		*/
		function getXmlDataEtri(){
			var tbl = $('#searchTable3');
			$.ajax({
					url : etriUrl
					, dataType : 'xml'
					, data :  {					
						cur_x: $('#X').val(),
						cur_y: $('#Y').val(),
						n: $('#places').val(),
					    q: $('#Query').val()
					  }
					  , error:function(xhr,status,e){       //에러 발생시 처리함수
							tbl.append(
								    "<tr class='rows error'>"
								     +"<td colspan=10>오류 발생!! 관리자에게 문의하세요.</td>"
								    +"</tr>"
						   );
					  }
					  , success : function(data) {
						    query = $(data).find("QUERY").text();
						    totalCount = $(data).find("TotalCount").text();
						    
							$("#keyword3").text("["+query+"] 에 대한 결과");
							$("#totalcnt3").text("["+totalCount+"] 건 검색됨");
							
							
							if($(data).find("Data").size()==0){ // 검색결과 없음
								tbl.append(
									    "<tr class='rows info'>"
									     +"<td colspan=10>검색결과 없음</td>"
									    +"</tr>"
							   );
							}else{
							    $.each($(data).find("Data"), function(idx,item){
							    	
							    	//console.log($(item).find("NM").text());
							    	//console.log($(item).find("PN").text());
							    	//http://211.113.53.187:8080/MobileQA/apis/1/search?q=중국집&p=1&n=1
							    	_item = {
							    				NAME : $(item).find("NM").text()
							    				,TEL : $(item).find("PN").text()
							    				,UJ_NAME : $(item).find("UJ").text()
							    			};
							    	//console.log(_item);
							    	addRow(idx, _item, tbl);
							    }); 
						  	}
					  	  }
						  , beforeSend: function() {
								var padingTop = (Number((tbl.css('height')).replace("px","")) / 2) - 20;
								//통신을 시작할때 처리
								$('#loading3').css('position', 'absolute');
								$('#loading3').css('left', tbl.offset().left);
								$('#loading3').css('top', tbl.offset().top);
								$('#loading3').css('width', tbl.css('width'));
								$('#loading3').css('height', "100%");
								$('#loading3').css('padding-top', padingTop);
								$('#loading3').show().fadeIn('fast');
							}
							, complete: function() {
								//통신이 완료된 후 처리
								$('#loading3').fadeOut();
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