<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="mMgr" class="pack.dao.MemberMgr" scope="page" />
<%
String uId = (String) session.getAttribute("uId_Session");
String uName = mMgr.getMemberName(uId);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,	initial-scale=1.0">
<title>글쓰기</title>
<link rel="stylesheet" href="/style/style_Common.css">
<link rel="stylesheet" href="/style/style_Template.css">
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/source/jquery-3.6.0.min.js"></script>
<script src="/script/script_BBS.js"></script>
</head>
<body>
	<div id="wrap">
		<!-- 헤더템플릿 시작 -->
		<%@	include file="/ind/headerTmp.jsp"%>
		<!--헤더템플릿 끝-->

		<main id="main" class="dFlex">

			<div id="lnb">
				<!-- 메인 LNB 템플릿 시작 -->
				<%@ include file="/ind/mainLnbTmp.jsp"%>
				<!--  메인 LNB 템플릿 끝 -->

				<!-- 실제 작업 영역 시작 -->
				<div id="contents" class="bbsWrite">
					<h2>글쓰기</h2>

					<form name="writeFrm" action="writeProc.jsp" method="post"
						id="writeFrm" enctype="multipart/form-data">
						<table>
							<tbody>
								<tr>
									<td class="req">성명</td>
									<!-- td.req 필수입력 -->
									<td><%=uName %> <input type="hidden" name="uName"
										vlaue="<%=uName %>"> <input type="hidden" name="uId"
										vlaue="<%=uId %>"></td>
								</tr>

								<tr>
									<td class="req">제목</td>
									<!-- td.req 필수입력 -->
									<td><input type="text" name="subject" maxlength="50"
										id="subject"></td>
								</tr>

								<tr>
									<td class="contentTD">내용</td>
									<td><textarea name="content" id="content" cols="60"
											wrap="hard"></textarea></td>
								</tr>

								<tr>
									<td>파일첨부</td>
									<td><span id="spanFile"> <input type="file"
											name="fileName" id="fileName">
									</span></td>
								</tr>

								<tr>
									<td>내용타입</td>
									<td><label><input type="radio" name="contentType"
											value="HTML"><span>HTML</span></label> <label><input
											type="radio" name="contentType" value="TEXT" checked><span>TEXT</span></label>
									</td>
								</tr>
							</tbody>
							<tfoot>
								<tr>
									<td colspan="2"><hr></td>
								</tr>

								<tr>
									<td colspan="2">
										<button type="button" id="regBtn">등록</button>
										<button type="reset">다시쓰기</button>
										<button type="button" id="listBtn">리스트</button>
									</td>
								</tr>
							</tfoot>
						</table>

						<input type="hidden" name="ip" value="<%=request.getRemoteAddr()%>">
						<!--		
								IP주소를 IPv4 형식으로 설정함.
								프로젝트 =>	Run	Configuration => Tomcat	클릭 =>	(x)Argument	탭	=>	
								VM arguments 입력란의 제일 아래줄에 아래 내용 입력
								-Djava.net.preferIPv4Stack=true		
								-->
					</form>
				</div>
					<!--실제 작업 영역 끝 -->
			</div>
		</main>
		<!--main#main-->
		
		<!-- 푸터템플릿 시작 -->
			<%@	include	file="/ind/footerTmp.jsp" %>
		<!-- 푸터템플릿 끝 -->
	</div>
	<!-- div#wrap -->
	
</body>
</html>
