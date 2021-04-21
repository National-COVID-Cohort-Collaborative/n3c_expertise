<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<c:choose>
	<c:when test="${not empty param.preprint_choice}">
		<sql:update dataSource="jdbc/N3CExpertiseTagLib">
		    insert into n3c_pubs.match(ms_id,doi) values(?,?)
		    <sql:param>${param.manuscript_choice}</sql:param>
			<sql:param>${param.preprint_choice}</sql:param>
		</sql:update>
	</c:when>
	<c:otherwise>
		<sql:update dataSource="jdbc/N3CExpertiseTagLib">
		    insert into n3c_pubs.match(ms_id,pmid) values(?,?::int)
		    <sql:param>${param.manuscript_choice}</sql:param>
			<sql:param>${param.litcovid_choice}</sql:param>
		</sql:update>
	</c:otherwise>
</c:choose>

<c:redirect url="scan.jsp" />
