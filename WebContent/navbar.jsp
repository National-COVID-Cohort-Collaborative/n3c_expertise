<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<nav class="navbar navbar-expand navbar-light bg-light">
	<img src="<util:applicationRoot/>/images/n3c_logo.png" class="n3c_logo_navbar" alt="N3C Logo">
	<div class="collapse navbar-collapse" id="navbarNav">
		<ul class="navbar-nav" style="display: flex; width: 100%;">
			<li class="nav-item">
				<a class="nav-link" href="<util:applicationRoot/>/index.jsp">Home</a>
			</li>
			<c:if test="${not empty admin}">
				<li class="nav-item">
					<a class="nav-link" href="<util:applicationRoot/>/dashboard.jsp">Dashboard</a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<util:applicationRoot/>/admin.jsp">Admin</a>
				</li>
			</c:if>
			<li class="nav-item">
				<a class="nav-link" href="<util:applicationRoot/>/search.jsp">Search</a>
			</li>
			<li class="nav-item" style="flex-grow: 1; text-align: right;">
				<a class="nav-link" href="<util:applicationRoot/>/logout.jsp"><small>Logout</small></a>
			</li>
		</ul>
	</div>
</nav>