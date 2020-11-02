<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

    <c:set var="user_email" scope="session" value="david-eichmann@uiowa.edu"/>
    
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

    <n3c:registration email="david-eichmann@uiowa.edu">
        <n3c:registrationOfficialFirstName officialFirstName="David"/>
        <n3c:registrationOfficialLastName officialLastName="Eichmann"/>
        <n3c:registrationOfficialFullName officialFullName="Eichmann, David"/>
        <n3c:registrationFirstName firstName="David"/>
        <n3c:registrationLastName lastName="Eichmann"/>
        <n3c:registrationInstitution  institution="University of Iowa"/>
        <n3c:registrationOfficialInstitution  officialInstitution="University of Iowa"/>
        <n3c:registrationCreatedToNow/>
        <n3c:registrationUpdatedToNow/>
    </n3c:registration>
    
    <c:redirect url="register.jsp"/>
