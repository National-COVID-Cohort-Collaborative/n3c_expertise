<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<!DOCTYPE html>
<html>
<jsp:include page="head.jsp" flush="true" />

<style type="text/css" media="all">
@import "resources/n3c_login_style.css";
</style>

<body>

	<jsp:include page="navbar.jsp" flush="true" />

	<c:if test="${not empty not_logged_in}">
		<div class=" n3c_alert">
			<i class="fa fa-exclamation" aria-hidden="true">&emsp;</i>Our
			apologies, but you must successfully log in through NIH prior to
			registering. Click <a href="dologin.jsp">here</a> to be redirected.<br />
		</div>
		<c:remove var="not_logged_in" />
	</c:if>


	<div class="container center-box shadow-border">
		<h2 class="header-text">
			<img src="images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C
			Expertise Discovery
		</h2>
		<h2>
			<i style="color: #7bbac6;" class="fas fa-search"></i> Faceted Search
		</h2>
		<div id=form>
			<form method='POST' action='search.jsp'>
				<fieldset>
					<input class='search-box' name="query" value="${param.query}"
						size=50> <input type=submit name=submitButton value=Go!>
					<c:if test="${not empty param.query}">
						<a class="search-reset" href="search.jsp" title="Reset Search"><i
							class="far fa-times-circle"></i></a>
					</c:if>
				</fieldset>
			</form>
		</div>
		<br />
		<c:choose>
			<c:when test="${not empty param.query}">
				<p />
				<c:set var="host">
					<util:requestingHost />
				</c:set>
				<util:Log line="" message="requesting host: ${host}"
					page="ctsaSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${param.query}" page="ctsaSearch"
					level="INFO"></util:Log>

				<h3>
					<c:out value="${displayString}" />
				</h3>
				<lucene:search lucenePath="/Users/eichmann/Documents/Components/lucene/n3c_expertise"
					label="content" queryParserName="boolean"
					queryString="${param.query}" useConjunctionByDefault="true">
					<div id="results-box">
						<div id="results-header-box">
							<h3 id="results-header">Search Results: ${param.query}</h3>
							<p>
								Result Count:
								<lucene:count />
							</p>
						</div>
						<div id="results-table" onscroll="scrollFunction()">
							<table style="width: 100%">
								<tr>
									<th>Result</th>
									<th>Source</th>
								</tr>
								<lucene:searchIterator>
									<tr>
										<td><a href="<lucene:hit label="email" />"><lucene:hit
													label="orcid" /></a></td>
										<td><lucene:hit label="first_name" /> <lucene:hit label="last_name" /></td>
									<tr>
								</lucene:searchIterator>
							</table>
						</div>
						<div id="results-scroll" style="text-align: right;">
							<button id="backtop" title="Back to Top">
								<i class="fas fa-chevron-up"></i>
							</button>
						</div>
					</div>
				</lucene:search>
			</c:when>
			<c:otherwise>
				<div class='desc-text' style="width: 80%;">
					<p>
						This proof-of-concept explores multi-faceted search across
						multiple federated sources, both internal to CD2H and the CTSA
						Consortium and more broadly across the entire informatics
						community. <b>Comments and questions are welcome!</b> We are
						particularly interested in feedback regarding the nature and
						organization of the facets used to filter search results. The
						facet taxonomy is readily restructured as we index data.
					</p>

				</div>
			</c:otherwise>
		</c:choose>

	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
</html>
