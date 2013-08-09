<!doctype html>
<html lang="en">
<head>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>jQuery Modal Contact Demo</title>

<script type="text/javascript" src="<c:url value="/resources/extjs-4.2.1/ext-all.js" /> "></script>
<script type="text/javascript" src="<c:url value="/resources/js/SearchResult.js" /> "></script>
<link rel="stylesheet" href="<c:url value="/resources/extjs-4.2.1/resources/css/ext-all-gray.css" />" type="text/css"></link>
<script type="text/javascript">
	var jsonData = Ext.decode('${jsonData}');
	console.log(jsonData);
	SearchResult.display(jsonData);
</script>
</head>

<body>
</body>
</html>