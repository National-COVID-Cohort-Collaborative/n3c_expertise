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
		<h2 class="header-text"><img src="../images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C Manuscript Tracking</h2>
		<div class="container">
			<c:choose>
			<c:when test="${empty param.author}">
				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select ms_id,tentative_manuscript_or_publication_title,corresponding_author_name,pmid,article_title from n3c_pubs.manuscript natural join n3c_pubs.match natural join covid_litcovid.article_title;
				</sql:query>

				<h3>LITCOVID Articles</h3>
				<table class="table table-striped">
					<tr><th>MS ID</th><th>Manuscript Title</th><th>Corresponding Author</th><th>PMID</th><th>LITCOVID Title</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td>${row.ms_id}</td>
							<td>${row.tentative_manuscript_or_publication_title}</td>
							<td>${row.corresponding_author_name}</td>
							<td><a href="https://pubmed.ncbi.nlm.nih.gov/${row.pmid}">${row.pmid}</a></td>
							<td>${row.article_title}</td>
						</tr>
					</c:forEach>
				</table>

				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select ms_id,tentative_manuscript_or_publication_title,corresponding_author_name,doi,title from n3c_pubs.manuscript natural join n3c_pubs.match natural join covid_biorxiv.biorxiv_current order by doi;
				</sql:query>

				<h3>medRxiv/bioRxiv Preprints</h3>
				<table class="table table-striped">
					<tr><th>MS ID</th><th>Manuscript Title</th><th>Corresponding Author</th><th>DOI</th><th>Preprint Title</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td>${row.ms_id}</td>
							<td>${row.tentative_manuscript_or_publication_title}</td>
							<td>${row.corresponding_author_name}</td>
							<td><a href="https://doi.org/${row.doi}">${row.doi}</a></td>
							<td>${row.title}</td>
						</tr>
					</c:forEach>
				</table>

				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select corresponding_author_last_name as author,substring(corresponding_author_name from 1 for 1) as initial,
						count(*)
					from n3c_pubs.manuscript
					where not exists (select ms_id from n3c_pubs.match where manuscript.ms_id=match.ms_id)
					  and exists (select doi from covid_biorxiv.biorxiv_current_author
					  			  where biorxiv_current_author.name ~ ('^'||substring(corresponding_author_name from 1 for 1)||'.*[^a-zA-Z]+'||corresponding_author_last_name||'($|[^a-zA-Z])')
					  			    and not exists (select * from n3c_pubs.suppress where suppress.doi = biorxiv_current_author.doi)
					  			    and not exists (select * from n3c_pubs.match where match.doi = biorxiv_current_author.doi)
					  			  union
					  			  select pmid::text from covid_litcovid.author
					  			  where author.last_name = corresponding_author_last_name
					  			    and author.fore_name ~ ('^'||substring(corresponding_author_name from 1 for 1))
					  			    and not exists (select * from n3c_pubs.suppress where suppress.pmid = author.pmid)
					  			    and not exists (select * from n3c_pubs.match where match.pmid = author.pmid)
					  			  )
					group by 1,2
					order by 1
					;
				</sql:query>

				<h3>Unbound Manuscript Corresponding Authors</h3>
				<table class="table table-striped">
					<tr><th>Corresponding Author</th><th>Count</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td><a href="scan.jsp?author=${row.author}&initial=${row.initial}">${row.author}</a></td>
							<td>${row.count}</td>
						</tr>
					</c:forEach>
				</table>
			</c:when>
			<c:when test="${not empty param.author}">
				<form action="submit_link.jsp">
            	<button type="submit" name="action" value="submit">Submit</button>
				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select
						ms_id,
						tentative_manuscript_or_publication_title as title,
						corresponding_author_last_name as author_last_name,
						corresponding_author_name as author_name
					from n3c_pubs.manuscript
					where not exists (select ms_id from n3c_pubs.match where match.ms_id = manuscript.ms_id)
					  and corresponding_author_last_name = ?
					;
					<sql:param>${param.author}</sql:param>
				</sql:query>

				<a href="scan.jsp">back</a>
				<h3>N3C Manuscripts - Corresponding Author: ${param.author}</h3>
				<table class="table table-striped">
					<tr><th>Link?</th><th>MS ID</th><th>Title</th><th>Corresponding Author</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td><input type="radio" id="manuscript_choice" name="manuscript_choice" value="${row.ms_id}"></td>
							<td>${row.ms_id}</td>
							<td>${row.title}</td>
							<td>${row.author_name}</td>
						</tr>
					</c:forEach>
				</table>

				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select
						doi,
						title,
						rank,
						name
					from covid_biorxiv.biorxiv_current natural join covid_biorxiv.biorxiv_current_author
					where not exists (select doi from n3c_pubs.suppress where suppress.doi=biorxiv_current.doi)
					  and not exists (select doi from n3c_pubs.match where match.doi=biorxiv_current.doi)
					  and name ~ ('^'||?||'.*[^a-zA-Z]+'||?||'($|[^a-zA-Z])')
					order by name;
					<sql:param>${param.initial}</sql:param>
					<sql:param>${param.author}</sql:param>
				</sql:query>

				<h3>medRxiv/bioRxiv Preprints</h3>
				<table class="table table-striped">
					<tr><th>Link?</th><th>Suppress?</th><th>DOI</th><th>Title</th><th>Rank</th><th>Author</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td><input type="radio" id="preprint_choice" name="preprint_choice" value="${row.doi}"></td>
							<td><a href="submit_suppress.jsp?author=${param.author}&initial=${param.initial}&doi=${row.doi}">suppress</a></td>
							<td><a href="https://doi.org/${row.doi}">${row.doi}</a></td>
							<td>${row.title}</td>
							<td>${row.seqnum}</td>
							<td>${row.name}</td>
						</tr>
					</c:forEach>
				</table>

				<sql:query var="names" dataSource="jdbc/N3CExpertiseTagLib">
					select
						article_title.pmid,
						article_title,
						author.seqnum,
						last_name,
						fore_name
					from covid_litcovid.article_title, covid_litcovid.author
					where article_title.pmid=author.pmid
					  and not exists (select pmid from n3c_pubs.suppress where suppress.pmid=article_title.pmid)
					  and not exists (select pmid from n3c_pubs.match where match.pmid=article_title.pmid)
					  and author.last_name = ?
					  and author.fore_name ~ ('^'||?)
					order by last_name,fore_name, article_title;
					<sql:param>${param.author}</sql:param>
					<sql:param>${param.initial}</sql:param>
				</sql:query>

				<h3>NIH LitCOVID Publications</h3>
				<table class="table table-striped">
					<tr><th>Link?</th><th>Suppress?</th><th>PMID</th><th>Title</th><th>Rank</th><th>Author</th></tr>
					<c:forEach items="${names.rows}" var="row" varStatus="rowCounter">
						<tr>
							<td><input type="radio" id="litcovid_choice" name="litcovid_choice" value="${row.pmid}"></td>
							<td><a href="submit_suppress.jsp?author=${param.author}&initial=${param.initial}&pmid=${row.pmid}">suppress</a></td>
							<td><a href="https://pubmed.ncbi.nlm.nih.gov/${row.pmid}">${row.pmid}</a></td>
							<td>${row.article_title}</td>
							<td>${row.seqnum}</td>
							<td>${row.last_name}, ${row.fore_name}</td>
						</tr>
					</c:forEach>
				</table>
				</form>
			</c:when>
			</c:choose>
		</div>
		<jsp:include page="../footer.jsp" flush="true" />
	</div>
</body>
</html>
