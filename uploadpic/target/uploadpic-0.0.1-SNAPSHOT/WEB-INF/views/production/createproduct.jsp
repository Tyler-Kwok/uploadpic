<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page import="java.util.*" language="java" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<!--[if IE]>
<style type="text/css">
fieldset{
	height:150;
}
</style>
<![endif]-->
<style type="text/css">
<!--
body {
max-width:800px;
text-align: center;
}

table{
	align: "left";
	}
table thead{
  margin: 0;
  padding: 0;
  
  text-align: center;
  font-family: "Lucida Sans Unicode", "Lucida Grande", sans-serif;
  font-size: 1.5em;
  color:#363636;
  
}


.products {
	
	margin: 20px auto;
}



.products li {
	left : 10px;
	width: 110px;
	height: 130px;
	float: left;
	margin-left:20px; 
	display: inline;
}

.products li a {
	
}

.products li img {
	border: 1px solid #666;
	padding: 1px;
}

.products li span a { 
width:110px; 
height:30px; 
line-height:24px; 
white-space:nowrap; 
text-overflow:ellipsis; 
overflow: hidden; 
}

.productdefault {
	
	margin: 20px auto;
}

.productdefault li {
	left : 10px;
	width: 110px;
	height: 130px;
	float: left;
	margin-left:20px; 
	display: inline;
}

.productdefault li a {
	display: block;
}

.productdefault li a img {
	border: 1px solid #666;
	padding: 1px;
}

.productdefault li span a { 
width:110px; 
height:30px; 
line-height:24px; 
white-space:nowrap; 
text-overflow:ellipsis; 
overflow: hidden; 
}

.link{
	text-decoration: underline;
	color: #00F;
	}
fieldset{
	align: "left";
	min-height: 150;
	min-width: 150;
	overflow-x: auto;
	text-align: left;
	position: relative;
	}
-->
</style>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script type="text/javascript">



	function submitform() {
		
		this.document.forms['add_category_form'].submit();
	}

	function openUploadImagePage() {
		sessionStorage.setItem('name', document.getElementById("name").value);
		sessionStorage.setItem('describe', document.getElementById('describe').value);
		window.open('<c:url value="addimages/${pbid}"/>','','width=700,height=620');

	}
	
	function removeallpic(){
		
		
	   $.ajax({    
        type:'post',        
        url:'delpic/<c:out value="${pbid}"/>',    
        data:{pbid   : '<c:out value="${pbid}"/>'},    
        cache:false,    
           
        success:function(data){
           document.getElementById("picset").innerHTML="<p>No pictures uploaded</p>";
           document.getElementById("picsize").innerHTML="0";
           document.getElementById("defaultpic").innerHTML="<p>No pictures uploaded</p>";
		   //alert(data.message);   
        },
        error: function(e){
		   alert(e.massage());
		   }   
    });
	   
}

	 function remove(pic){
		 var picid=pic.split('.')[0];
		   $.ajax({    
		        type:'post',        
		        url:'delpic/<c:out value="${pbid}"/>/'+picid,    
		        data:{  picid : pic},    
		        cache:false,    
		           
		        success:function(data){
		        	window.location.reload();
			        //var imgsrc='<c:out value="${path}/"/>'+pic;
					//var pics=$(".products li img");
					/*var length=$(".products").children().length;
					var index=$(".products").children().IndexOf(element.parentNode.parentNode);
					$(element.parentNode.parentNode).remove();
					if($(".products").children().length==0){
				           picset.innerHTML="<p>No pictures uploaded</p>";
						   picsize.innerHTML="0";
						   defaultpic.innerHTML="<p>No pictures uploaded</p>";
						}*/
				   //alert(data.message);   
		        },
		        error: function(e){
				   alert(e);
				   }   
		    });
		 }

	 function selectdef(pic){
		 var picid=pic.split('.')[0];
		   $.ajax({    
		        type:'post',        
		        url:'defaultset/<c:out value="${pbid}"/>/'+picid,    
		        data: {picid   : pic},    
		        cache:false,    
		           
		        success:function(data){
		        	$('.productdefault li img').prop("src", '<c:out value="${path}/"/>'+pic);
 
		        },
		        error: function(e){
				   alert(e.massage());
				   }   
		    });
		 
		 }
	 
	 function onload(){
		 document.getElementById("name").value=sessionStorage.getItem("name");
		 document.getElementById('describe').value=sessionStorage.getItem("describe");
		 sessionStorage.setItem('name', document.getElementById("name").value);
		 sessionStorage.setItem('describe', document.getElementById('describe').value);
	 }

</script>
</head>
<body style="text-decoration: underline; right: auto; left: auto; text-align: center;" onload="onload()">
	<form:form method="post" modelAttribute="productbean" action="" id="form1">

	<table align="left">
		<tr style="background-color: #F1F1F1;">
			<td   colspan="3">
			<strong>Bring your item life to pictures </strong>
			<a link="#">add or remove options </a> |
			<a link="#"> Get help</a>
            </td>
        </tr>

		<tr>
			<td width="118"><form:label for="name" path="name" > Production Name:</form:label></td>
			<td colspan="2"><form:hidden path="pbid"/><form:input path="name" type="text" size="50" id="name"/></td>
		</tr>
		<tr>
			<td><form:label for="describe" path="describe" > Product description:</form:label></td>
			<td colspan="2"><form:textarea path="describe" rows="6" cols="80" id="describe"></form:textarea>
		</tr>

		<tr>
			<td><b>All pictures:</b></td>
		</tr>
		<tr>
			<td style="FONT-FAMILY: 'DejaVu Sans Condensed';" ><input
				type="button" value="Add new pictures"
				onclick="openUploadImagePage()" /></td><td width="129">|<a href="#" class="link" onClick="removeallpic()"> remove all pictures</a></td>
			<td width="364" style="text-align: right">Your pictures: <span id="picsize"><c:out value="${productbean.getMpf().size()}"/></span></td>
		</tr>
<tr><td colspan="3">
<br>
			<fieldset  id="picset"  name="picset">
			<c:choose>

					<c:when test="${productbean.getMpf().size()==0}">

						<p align="center">No pictures uploaded</p>
					</c:when>
					<c:otherwise>
					    
						<ul class="products">
							<c:forEach var="i" begin="1" end="${productbean.getMpf().size() }" step="1">
								<li>
<!--  <a href="#"><img src="" alt=""  height="90"/></a>-->
<img src="${path}/${productbean.getMpf().getIndexfilename(i-1)}" alt=""  
height="100" onClick="selectdef('${productbean.getMpf().getIndexfilename(i-1)}')"/>

									<span><a href="#" class="link" align="center" onClick="remove('${productbean.getMpf().getIndexfilename(i-1)}')">delete pic</a></span>
								</li>
							</c:forEach>
						</ul>
					</c:otherwise>
				</c:choose>
				</fieldset></td></tr>
		<tr>
		<td>
		Your default picture of this product is:
		</td>
		</tr>
		<tr>
			<td >
			<fieldset id="defaultpic">
			<c:choose>

					<c:when test="${productbean.getMpf().size()==0}">

						<p>No pictures uploaded</p>
					</c:when>
					<c:otherwise>
					    
						<ul class="productdefault">
							
								<li>
<!--  <a href="#"><img src="" alt=""  height="90"/></a>-->
<img src="${path}/${productbean.getMpf().getDefaultFileName()}" alt=""  
height="100" />

									
								</li>
							
						</ul>
					</c:otherwise>
				</c:choose>
			
			</fieldset>
			</td>
		</tr>
		<tr>
			<td colspan=2><hr>
				<input type="submit" value="submit" onclick="sessionStorage.clear();"/></td>
		</tr>
	</table>
	</form:form>
</body>
</html>