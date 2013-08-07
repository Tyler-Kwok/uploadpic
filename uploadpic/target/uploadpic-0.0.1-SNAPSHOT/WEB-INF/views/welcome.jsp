<%@page contentType="text/html;charset=UTF-8"%>
<%@page pageEncoding="UTF-8"%>
<%@ page session="true" %>
<% session.removeAttribute("pbid");
   session.removeAttribute("productbean");

%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.UUID" language="java"%>
<html>
<head>
	<META http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<title><fmt:message key="welcome.title"/></title>
	<link rel="stylesheet" href="<c:url value="/resources/screen.css" />" type="text/css" media="screen, projection">
	<link rel="stylesheet" href="<c:url value="/resources/print.css" />" type="text/css" media="print">
	<!--[if lt IE 8]>
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
	<![endif]-->
	<script type="text/javascript">
	function openUploadImagePage() {
		//window.open('popupPage','Popup Page','width=800,height=600');
		window.open('production/addimages','Upload images for your added production','width=800,height=600');
		}
	</script>
</head>
<body>
<div class="container">  
	<h1>
		<fmt:message key="welcome.title"/>
	</h1>
	<p>
		Locale = ${pageContext.response.locale}
	</p>
	<hr>
	<ul>
	<li><a href="production/createproduct">click here to added production</a></li>
	</ul>
	<ul>
	<li><input type="button" value="up images" onclick="openUploadImagePage()"/></li>
	</ul>
</div>
</body>
</html>