<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

    <c:set var="user_email" scope="session">${attributes.get("email")[0]}</c:set>

    <sql:query var="admins" dataSource="jdbc/N3CLoginTagLib">
        select email from n3c_admin.admin where email = ?
        <sql:param>${user_email}</sql:param>
    </sql:query>
    <c:forEach items="${admins.rows}" var="row" varStatus="rowCounter">
        <c:set scope="session" var='admin' value='yes' />
    </c:forEach>
 
    <c:if test="${not empty admin}">
        <c:redirect url="admin.jsp"/>
    </c:if>

    <c:if test="${n3c:registrationExists(user_email)}">
        <c:redirect url="profile.jsp"/>
    </c:if>

    <c:set var="first_name">${attributes.get("given_name")[0]}</c:set>
    <c:set var="last_name">${attributes.get("family_name")[0]}</c:set>
    <c:set var="institution">${attributes.get("org")[0]}</c:set>
    <c:set var="name">${attributes.get("name")[0]}</c:set>
    <n3c:registration email="${user_email}">
        <n3c:registrationOfficialFirstName officialFirstName="${first_name}"/>
        <n3c:registrationOfficialLastName officialLastName="${last_name}"/>
        <n3c:registrationOfficialFullName officialFullName="${name}"/>
        <n3c:registrationFirstName firstName="${first_name}"/>
        <n3c:registrationLastName lastName="${last_name}"/>
        <n3c:registrationInstitution  institution="${institution}"/>
        <n3c:registrationOfficialInstitution  officialInstitution="${institution}"/>
        <n3c:registrationCreatedToNow/>
        <n3c:registrationUpdatedToNow/>
    </n3c:registration>
    
    <c:redirect url="register.jsp"/>
