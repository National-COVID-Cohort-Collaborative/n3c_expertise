<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>

<c:if test="${not empty param.analytics}">
    <n3c:membership email="${user_email}" label="analytics">
        <n3c:membershipJoinedToNow/>
    </n3c:membership>
</c:if>
<c:if test="${not empty param.governance}">
    <n3c:membership email="${user_email}" label="governance">
        <n3c:membershipJoinedToNow/>
    </n3c:membership>
</c:if>
<c:if test="${not empty param.phenotype}">
    <n3c:membership email="${user_email}" label="phenotype">
        <n3c:membershipJoinedToNow/>
    </n3c:membership>
</c:if>
<c:if test="${not empty param.harmonization}">
    <n3c:membership email="${user_email}" label="harmonization">
        <n3c:membershipJoinedToNow/>
    </n3c:membership>
</c:if>
<c:if test="${not empty param.synthetic}">
    <n3c:membership email="${user_email}" label="synthetic">
        <n3c:membershipJoinedToNow/>
    </n3c:membership>
</c:if>

<c:redirect url="profile.jsp"/>
