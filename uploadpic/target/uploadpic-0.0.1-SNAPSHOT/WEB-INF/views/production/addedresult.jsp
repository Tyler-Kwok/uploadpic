<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<title>Results:</title>
<script src="http://code.jquery.com/jquery-1.8.2.js"></script>
<script type="text/javascript">

function closeupload(){
	window.opener.location.reload();
	window.close();
}
$(document).ready(function(){
	
	if (window.opener && !window.opener.closed) {
		self.setTimeout(closeupload(),1000);
		
	}
	
});

</script>
</head>
<body>
<c:choose>
<c:when test="${message eq 'success'}">
<h2>Your picture successful submit</h2>
</c:when>
  <c:otherwise>
    <h2>Your picture does not submit success for:</h2>
    <h2><c:out value="${message}"/></h2>
  </c:otherwise>
</c:choose>



</body>
</html>