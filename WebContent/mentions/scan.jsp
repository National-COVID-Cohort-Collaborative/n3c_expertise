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
		<h2 class="header-text"><img src="../images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C Mentions in medRxiv / bioRxiv Preprints</h2>
		<div class="container">
				<sql:query var="dois" dataSource="jdbc/N3CExpertiseTagLib">
					select distinct doi
					from  covid_biorxiv.biorxiv_text
					where contents~'[nN]3[cC]'
					  and doi not in (select doi from covid_biorxiv.n3c_mention_suppress)
					order by  1;
				</sql:query>
				<form method='POST' action='submit_suppress.jsp'>
					<table class="table table-striped">
						<c:forEach items="${dois.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td><input type="radio" id="true" name="${row.doi}"	value="true"><label for="true"> Suppress</label>
									<input type="radio" id="false" name="${row.doi}" value="false" checked><label for="true"> Keep</label>
									</td>
								<td>${row.doi}</td>
								<td><sql:query var="matches" dataSource="jdbc/N3CExpertiseTagLib">
										select unnest(regexp_matches(contents, '.{50}[nN]3[cC].{50}', 'g')) as match
										from covid_biorxiv.biorxiv_text
										where doi = ?;
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<ul>
										<c:forEach items="${matches.rows}" var="row2"	varStatus="rowCounter">
											<li>${row2.match}
										</c:forEach>
									</ul>
									</td>
							</tr>
						</c:forEach>
					</table>
					<button type="submit" name="action" value="submit">Submit</button>
				</form>
		</div>

		<div class="container">
				<sql:query var="dois" dataSource="jdbc/N3CExpertiseTagLib">
					select pub_date,doi,title
					from  covid_biorxiv.biorxiv_current natural join covid_biorxiv.n3c_mention_suppress where not suppress
					order by 1 desc, 2;
				</sql:query>
					<table class="table table-striped">
						<tr><th>Upload&nbsp;Date</th><th>Preprint</th><th>Mention Text Fragments</th></tr>
						<c:forEach items="${dois.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td>${row.pub_date}</td>
								<td><a href="https://doi.org/${row.doi}"><span style="color:#376076">${row.title}</span></a></td>
								<td><sql:query var="matches" dataSource="jdbc/N3CExpertiseTagLib">
										select unnest(regexp_matches(contents, '.{50}[nN]3[cC].{50}', 'g')) as match
										from covid_biorxiv.biorxiv_text
										where doi = ?;
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<ul>
										<c:forEach items="${matches.rows}" var="row2"	varStatus="rowCounter">
											<li>${row2.match}
										</c:forEach>
									</ul>
									</td>
							</tr>
						</c:forEach>
					</table>
		</div>
		<jsp:include page="../footer.jsp" flush="true" />
	</div>
</body>
</html>
