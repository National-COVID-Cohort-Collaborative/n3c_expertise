<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<!DOCTYPE html>

<c:if test="${empty user_email}">
	<c:set scope="session" var="not_logged_in" value="t" />
	<c:redirect url="index.jsp" />
</c:if>

<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>N3C Registration Admin</title>
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
	integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk"
	crossorigin="anonymous">
<link rel="stylesheet" id='font-awesome'
	href="https://use.fontawesome.com/releases/v5.7.2/css/all.css"
	integrity="sha384-fnmOCqbTlWIlj8LyTjo7mOUStjsKC4pOpQbqyi7RrhN7udi9RwhKkMHpvLbHG9Sr"
	crossorigin="anonymous">
<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.css">


<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
       <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
       <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
     <![endif]-->
</head>

<style type="text/css" media="all">
@import "resources/n3c_login_style.css";
</style>

<body>
<script type="text/javascript" language="javascript" src="https://code.jquery.com/jquery-3.5.1.js"></script>
<script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.js"></script>
<script type="text/javascript">
$(document).ready( function () {
    $('#roster').DataTable( {
    	"order": [[ 2, 'asc' ], [ 1, 'asc' ]]
    } );
} );
</script>

	<jsp:include page="navbar.jsp" flush="true" />
	
	<div class="container center-box shadow-border">
		<h2 class="header-text">
			<img src="images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C Registration Admin
		</h2>
		
		<h3>${param.category} User Roster</h3>
	    <sql:query var="categories" dataSource="jdbc/N3CLoginTagLib">
	        select email,first_name,last_name,institution,orcid_id,updated
	        <c:choose>
	           <c:when test="${param.category == 'Citizen Scientist'}">
                    from n3c_admin.staging_user_citizen
	           </c:when>
               <c:when test="${param.category == 'InCommon'}">
                    from n3c_admin.staging_user_incommon
               </c:when>
               <c:when test="${param.category == 'InCommon (name mismatch)'}">
                    from n3c_admin.staging_user_incommon_mismatch
               </c:when>
               <c:when test="${param.category == 'NIH'}">
                    from n3c_admin.staging_user_nih
               </c:when>
               <c:when test="${param.category == 'Non-InCommon'}">
                    from n3c_admin.staging_user_non_incommon
               </c:when>
	           <c:otherwise>
                   from n3c_admin.staging_user_incommon
	           </c:otherwise>
	        </c:choose>
	        order by 4,3;
	    </sql:query>
	    <table id="roster" class="display">
	    <thead><tr><th>Email</th><th>Name</th><th>Institution</th><th>ORCiD</th><th>Last Updated</th></tr></thead>
	    <tbody>
	    <c:forEach items="${categories.rows}" var="row" varStatus="rowCounter">
	        <tr><td>${row.email}</td><td>${row.last_name}, ${row.first_name}</td><td>${row.institution}</td><td>${row.orcid_id}</td><td>${row.updated}</td></tr>
	    </c:forEach>
        </tbody>
	    </table>

	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
</html>
