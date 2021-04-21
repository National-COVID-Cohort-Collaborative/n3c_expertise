<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

		<sql:update dataSource="jdbc/N3CExpertiseTagLib">
		    insert into n3c_pubs.suppress values(?,?::int)
		    <sql:param>${param.doi}</sql:param>
			<sql:param>${param.pmid}</sql:param>
		</sql:update>

<c:redirect url="scan.jsp">
<c:param name="author">${param.author}</c:param>
</c:redirect>
