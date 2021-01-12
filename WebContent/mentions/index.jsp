<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<!DOCTYPE html>
<html>
<jsp:include page="../head.jsp" flush="true" />

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<!-- jQuery library -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

<!-- Latest compiled JavaScript -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script src="resources/d3.v3.min.js"></script>

<style type="text/css" media="all">
@import "../resources/n3c_login_style.css";
</style>

<style type="text/css">
table.dataTable thead .sorting_asc {
	background-image: none !important;
}
</style>

<body>

	<jsp:include page="../navbar.jsp" flush="true" />

	<div class="container center-box">
		<h2 class="header-text"><img src="../images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C COVID-19 Clinical Trial Exploration</h2>
		<div>
				<sql:query var="cuis" dataSource="jdbc/N3CExpertiseTagLib">
					select doi,unnest(regexp_matches(contents, '.{30}[nN]3[cC].{30}', 'g')) as match
					from  covid_biorxiv.biorxiv_text
					where contents~'[nN]3[cC]' order by  1;
				</sql:query>
				<form method='POST' action='submit_suppress.jsp'>
					<table class="table table-striped">
						<c:forEach items="${cuis.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td><input type="radio" id="true" name="${row.cui}"	value="true"><label for="true"> Suppress</label>
									<input type="radio" id="false" name="${row.cui}" value="false" checked><label for="true"> Keep</label>
									</td>
								<td>${row.doi}</td>
								<td>${row.match}</td>
							</tr>
						</c:forEach>
					</table>
					<button type="submit" name="action" value="submit">Submit</button>
				</form>
		</div>
		<jsp:include page="../footer.jsp" flush="true" />
	</div>
</body>
</html>
