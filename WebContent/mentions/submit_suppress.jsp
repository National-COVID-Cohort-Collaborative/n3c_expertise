<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<c:forEach var="par" items="${param}">
	<c:if test="${par.key ne 'action'}">
		<sql:update dataSource="jdbc/N3CExpertiseTagLib">
		    insert into covid_biorxiv.n3c_mention_suppress values(?,?::boolean)
		    <sql:param>${par.key}</sql:param>
			<sql:param>${par.value}</sql:param>
		</sql:update>
	</c:if>
	<br>
</c:forEach>

<c:redirect url="index.jsp"/>
