<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>

<n3c:enclave email="${user_email}">
    <n3c:enclaveSftp sftp="${not empty param.sftp}"/>
    <n3c:enclaveLevel level="${param.level}"/>
    <n3c:enclaveRequestedToNow/>
</n3c:enclave>

<c:redirect url="profile.jsp"/>
