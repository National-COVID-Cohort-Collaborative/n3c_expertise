<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="mail" uri="http://slis.uiowa.edu/mailtaglib"%>

<mail:message host="gmail">
	<mail:fromAddress address="david-eichmann@uiowa.edu" name="David Eichmann" />
	<mail:recipientAddress address="david-eichmann@uiowa.edu" name="David Eichmann" />
	<mail:subject>Testing tag lib</mail:subject>
	<mail:htmlBody>This is a <b>test</b>.</mail:htmlBody>
</mail:message>
