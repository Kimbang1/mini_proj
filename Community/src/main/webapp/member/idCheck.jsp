<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" />
<!-- 액션태그는 Java 클래스를 객체로 생성하고
		JSP에서  참조할 수 있도록 만든다.
		mMgr : 객체의 인스턴스 변수
		위의 액션태그는 아래의 코드와 동일하다
		MemberMgr mMgr = new MemberMgr(); -->

<%
request.setCharacterEncoding("UTF-8");
String uId = request.getParameter("uId");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,	initial-scale=1.0">
<title>아이디 중복 체크</title>
<link rel="stylesheet" href="/style/style_Common.css">
<script src="/source/jquery-3.6.0.min.js"></script>
<script src="/script/script_Join.js"></script>
</head>
<body>
	<div id="wrap_Popup">
		<div>
			<h1><%=uId%></h1>

			<span> <%
 boolean result = mMgr.checkId(uId);
 //result => true라면 입력한 아이디 사용 불가(=이미 가입한 ID)
 String btnCap = null;

 if (result) {
 	out.print("는 존재하는 ID 입니다.");
 	btnCap = "ID 재입력";
 } else {
 	out.print("는 사용가능한 ID 입니다.");
 	btnCap = "사용하기";
 }
 %>

			</span>
		</div>
		<hr>
		<div id="closeBtnArea">
			<button type="button"><%=btnCap%></button>
		</div>
	</div>
	<!-- div#wrap -->
	<script src="/script/jquery-3.7.1.min.js"></script>
	<script src="/script/script.js"></script>
</body>
</html>
