<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

    <c:set var="user_email" scope="session" value="david-eichmann@uiowa.edu"/>
    
    <sql:query var="admins" dataSource="jdbc/N3CExpertiseTagLib">
        select email from n3c_admin.admin where email = ?
        <sql:param>${user_email}</sql:param>
    </sql:query>
    <c:forEach items="${admins.rows}" var="row" varStatus="rowCounter">
        <c:set scope="session" var='admin' value='yes' />
    </c:forEach>
 
    <c:redirect url="index.jsp"/>
