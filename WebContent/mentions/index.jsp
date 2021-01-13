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

		<p>Mentions in column three are either in the text of a sentence in the preprint or the reference list.
		<br>The third mention element is a simple text snippet &plusmn;50 characters of the matching string.
		<br>Missing elements are typically due to a failed extraction from the original PDF.</p>
		
		<div class="container">
				<sql:query var="dois" dataSource="jdbc/N3CExpertiseTagLib">
					select distinct pub_date,doi,title
					from  covid_biorxiv.n3c_mention
					order by  1 desc,2;
				</sql:query>
					<table class="table table-striped">
						<tr><th>Upload&nbsp;Date</th><th style="width:40%">Preprint</th><th style="width:60%">N3C Mentions</th></tr>
						<c:forEach items="${dois.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td>${row.pub_date}</td>
								<td><a href="https://doi.org/${row.doi}"><span style="color:#376076">${row.title}</span></a></td>
								<td>
									<sql:query var="matches" dataSource="jdbc/N3CExpertiseTagLib">
										select doi,seqnum,sentnum,full_text
										from covid_biorxiv.sentence
										where full_text ~'[nN]3[cC]'
										  and doi = ?
										order by 1,2,3;
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<sql:query var="cites" dataSource="jdbc/N3CExpertiseTagLib">
										select sentence.doi,full_text,refnum,reference
										from covid_biorxiv.sentence natural join covid_biorxiv.citation,covid_biorxiv.reference
										where sentence.doi=reference.doi
										  and citation.refnum=reference.seqnum
										  and sentence.doi = ?
										  and (reference ~'[nN]3[cC]' or reference~'Cohort Collaborative');
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<p>Sentences</p>
									<ul>
										<c:forEach items="${matches.rows}" var="row2"	varStatus="rowCounter">
											<li>${row2.full_text}
										</c:forEach>
										<c:forEach items="${cites.rows}" var="row2"	varStatus="rowCounter">
											<li>${row2.full_text}
										</c:forEach>
									</ul>
									<sql:query var="matches" dataSource="jdbc/N3CExpertiseTagLib">
										select doi,seqnum,reference
										from covid_biorxiv.reference
										where reference ~'[nN]3[cC]'
										  and doi = ?
										order by 1,2;
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<p>References</p>
									<ul>
										<c:forEach items="${matches.rows}" var="row2"	varStatus="rowCounter">
											<li>(${row2.seqnum}) ${row2.reference}
										</c:forEach>
									</ul>
									<sql:query var="matches" dataSource="jdbc/N3CExpertiseTagLib">
										select match
										from covid_biorxiv.n3c_mention
										where doi = ?;
										<sql:param>${row.doi}</sql:param>
									</sql:query>
									<p>Text fragments</p>
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
