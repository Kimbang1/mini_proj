<%@page import="pack.dto.ZipcodeBean"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" />

<%
request.setCharacterEncoding("UTF-8");

String area3 = request.getParameter("area3");
//참조자료형ㅇ은 미입력 상태에서 null값이 기본값으로 저장된다.
List<ZipcodeBean> objList = null;
if (area3 == null) {

	area3 = "";
} else {
	objList = mMgr.zipcodeRead(area3);
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>우편번호 찾기</title>
<link rel="stylesheet" href="/style/style.css?v">
</head>
<body>

	<div id="wrap_zipcodePopup">
		<h1>우편번호 찾기</h1>
		<form name="zipFrm" id="zipFrm">
			<table id="zipFrmTbl">
				<tbody>
					<tr>
						<td id="searchInputArea"><span>동 이름 입력</span> <input
							type="text" name="area3" id="aera3">
							<button type="button" id="addrSearchBtn">검색</button></td>
					</tr>
					<tr>
						<td><hr></td>
					</tr>
					<tr>
						<td id="zipResArea">
							<%
							if (area3.equals("")) {
							%> <span>검색어를 입력해 주세요</span> 
							<% } else { %>
							 <span><b>[<%=area3%>]</b></span>에 대한 검색결과 입니다.
							
							<table id="zipResTbl">
								<tbody>
									<%for (int i = 0; i < objList.size(); i++) {
										ZipcodeBean bean = objList.get(i);
										String addr = bean.getZipcode() + "	";
										addr += bean.getArea1() + "	";
										addr += bean.getArea2() + "	";
										addr += bean.getArea3() + "	";
										addr += bean.getArea4();
									%>
									<tr>
										<td><span><%=addr%></span></td>
									</tr>
									<%}	%>
								</tbody>
							</table> 
							<% } %>
						</td>
					</tr>
				</tbody>
			</table>


		</form>


	</div>
	<!-- div#wrap -->
	<script src="/script/jquery-3.7.1.min.js"></script>
	<script src="/script/script.js"></script>
</body>
</html>
