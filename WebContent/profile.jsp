<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="n3c" uri="http://icts.uiowa.edu/n3c"%>
<!DOCTYPE html>

<c:if test="${empty user_email}">
	<c:set scope="session" var="not_logged_in" value="t" />
	<c:redirect url="index.jsp" />
</c:if>

<html>
	<jsp:include page="head.jsp" flush="true" />

<style type="text/css" media="all">
@import "resources/n3c_login_style.css";
</style>

<body>

	<jsp:include page="navbar.jsp" flush="true" />
	
	<div class="container center-box shadow-border">
		<h2 class="header-text">
			<img src="images/n3c_logo.png" class="n3c_logo_header" alt="N3C Logo">N3C & CD2H Registration
		</h2>

		<n3c:registration email="${user_email}">
			<div class="mb-3" style="text-align:center;">
				<h3>Profile for: <n3c:registrationEmail /></h3>
				<small>Created: <n3c:registrationCreated /> &emsp; Updated: <n3c:registrationUpdated /></small>
			</div>
			<div class="container">
				<div class="row mb-4">
					<div class="col-md-6">
						<strong>Official First Name:</strong> <n3c:registrationOfficialFirstName /><br>
						<strong>Official Last Name:</strong> <n3c:registrationOfficialLastName /><br>
						<strong>Official Full Name:</strong> <n3c:registrationOfficialFullName /><br>
						<strong>First Name:</strong> <n3c:registrationFirstName /><br>
						<strong>Last Name:</strong> <n3c:registrationLastName />
					</div>
					<div class="col-md-6">
						<strong>Institution:</strong> <n3c:registrationInstitution /><br>
						<strong>ORCiD ID:</strong> <n3c:registrationOrcidId /><br>
						<strong>Expertise:</strong> <n3c:registrationExpertise /><br>
						<strong>Therapeutic Area:</strong> <n3c:registrationTherapeuticArea />
						
					</div>
				</div>
				<div class="row mb-4">
					<div class="col-md-6">
						<strong>GSuite Email:</strong> <n3c:registrationGsuiteEmail /><br>
						<strong>Assistant's Email:</strong> <n3c:registrationAssistantEmail />
					</div>
					<div class="col-md-6">
						<strong>Slack ID:</strong> <n3c:registrationSlackId /><br>
						<strong>GitHub ID:</strong> <n3c:registrationGithubId /><br>
						<strong>Twitter ID:</strong> <n3c:registrationTwitterId />
					</div>
				</div>
			</div>

           <c:if test="${n3c:registrationEnclaveValue()}">
           		<h4 class="accent-text">N3C Enclave Access</h4>
                 <p style="font-style: italic; margin-bottom:30px;"><i class="fa fa-check" aria-hidden="true">&ensp;</i>Access to the N3C Enclave has been requested.</p>
            </c:if>
            
			<c:if test="${n3c:registrationWorkstreamsValue()}">
				<h4 class="accent-text">N3C Workstream Memberships</h4>
				<p style="font-style:italic;">If you have joined an N3C workstream and have not yet completed the onboarding process, please follow Step 2 in the
			     <a href="https://covid.cd2h.org/onboarding_instructions" target="_blank">instructions on the N3C website</a> to gain access to important documents and communications.</p>
				<div class="row">
					<n3c:foreachMembership var="x">
						<n3c:membership>
							<div class="col-md-6 mb-3">
								Workstream: <n3c:membershipLabel /><br>
								<small>Joined: <n3c:membershipJoined /></small>
							</div>
						</n3c:membership>
					</n3c:foreachMembership>
				</div>
			</c:if>
 
            <div class="container" style="text-align:center;">
                <div class="row mb-4 justify-content-center">
                    <div class="col-md-4">
                        <a href="register.jsp">Edit This Profile</a>
                    </div>
                </div>
            </div>
        <c:if test="${empty n3c:registrationEmailedValue()}">
        	<p>You have successfully completed your registration for membership to N3C and the N3C Data Enclave!</p>

			<p>Within the next 24-72 hours, you will receive an email at the account address used for registration with instructions
			for creating your N3C Data Enclave account. Please follow the instructions in that email once you have received it.</p>

			<p>For assistance, contact the <a href="https://covid.cd2h.org/help_desk">N3C Help Desk</a>.</p>

			<p>Best regards and happy researching!</p>
 
			<p>NCATS and the Center for Data to Health (CD2H)<br>
			<a href="mailto:data2health@gmail.com">data2health@gmail.com</a></p>
        	<jsp:include page="email/send.jsp"/>
        </c:if>
 		</n3c:registration>
	</div>
	<jsp:include page="footer.jsp" flush="true" />
</body>
</html>
