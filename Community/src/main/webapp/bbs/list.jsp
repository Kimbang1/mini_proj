<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
String uId_Session = (String) session.getAttribute("uId_Session");
%>

<%@ page import="pack.dto.BoardBean,java.util.Vector"%>
<jsp:useBean id="bMgr" class="pack.dao.BoardMgr" />

<%
/////////////////////페이징 관련 속성 값 시작////////////////////
//페이징(Paging) = 페이지 나누기를 의미함
int totalRecord = 0; //전체 데이터 수(DB에 저장된 row 개수)
int numPerPage = 5; //페이지당 출력하는 데이터 수(=게시글 숫자)
int pagePerBlock = 5; //블럭당 표시되는 페이지  수의 개수
int totalPage = 0; //전체 페이지 수
int totalBlock = 0; //전체 블록수

int nowPage = 1; //현재 (사용자가 보고 있는)페이지 번호
int nowBlock = 1; //현재 (사용자가 보고 있는) 블럭

int start = 0; //DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 5; //시작하는 인덱스 번호부터 반환하는(=출력하는 ) 데이터 개수
//select * from T/N where ... order by ... limit start, end;

int listSize = 0; //1페이지에서 보여주는 데이터 수
//출력할 데이터의 개수 == 데이터 1개는 가로줄 1개

//게시판 검색 관련소스
String keyField = ""; //DB의 컬럼명
String keyWord = ""; //DB의 검색어

if (request.getParameter("keyWord") != null) {
	keyField = request.getParameter("keyField");
	keyWord = request.getParameter("keyWord");
}

if (request.getParameter("nowPage") != null) {
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
}

totalRecord = bMgr.getTotalCount(keyField, keyWord);
//전체 데이터 수 반환

totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
nowBlock = (int) Math.ceil((double) nowPage / pagePerBlock);
totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);
////////////////////////페이징 관련 속성 값 끝//////////////////////

Vector<BoardBean> vList = null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,	initial-scale=1.0">
<title>게시판목록</title>
<link rel="stylesheet" href="/style/style_Common.css">
<link rel="stylesheet" href="/style/style_Template.css">
<link rel="stylesheet" href="/style/style_BBS.css">
<script src="/source/jquery-3.6.0.min.js"></script>
<script src="/script/script_BBS.js"></script>
</head>
<body>
	<div id="wrap">
		<!--헤더템플릿 시작 -->
		<%@	include file="/ind/headerTmp.jsp"%>
		<!--헤더템플릿 끝-->

		<main id="main" class="dFlex">

			<div id="lnb">
				<!-- 메인 LNB 템플릿 시작 -->
				<%@ include file="/ind/mainLnbTmp.jsp"%>
				<!-- 메인 LNB 템플릿 끝 -->
			</div>

			<!-- 실제 작업 영역 시작 -->
			<div id="contents" class="bbsList">

				<%
				String prnType = "";
				if (keyWord.equals("null") || keyWord.equals("")) {
					prnType = "전체 게시글";
				} else {
					prnType = "검색 결과";
				}
				%>

				<div id="pageInfo" class="dFelx">
					<span><%=prnType%> : <%=totalRecord%>개</span> <span>페이지 :
						<%=nowPage + "/" + totalPage%></span>
				</div>

				<table id="boardList">
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>이름</th>
							<th>날짜</th>
							<th>조회수</th>
						</tr>
						<tr>
							<td colspan="5" class="spaceTd"></td>
						</tr>
					</thead>
					<tbody>
						<%
						vList = bMgr.getBoardList(keyField, keyWord, start, end);//DB에서 데이터 불러오기
						listSize = vList.size();

						if (vList.isEmpty()) {
						%>
						<tr>
							<td colspan="5"><%="게시물이 없습니다."%></td>
						</tr>
						<%
						} else {
						for (int i = 0; i < numPerPage; i++) {
							if (i == listSize)
								break;
							BoardBean bean = vList.get(i);
							int num = bean.getNum();
							String uName = bean.getuName();
							String subject = bean.getSubject();
							String regTM = bean.getRegTM();

							int depth = bean.getDepth();
							int readCnt = bean.getReadCnt();
						%>
						<tr class="prnTr" onclick="read('<%=num%>','<%=nowPage%>')">
							<td>
								<%
								if (depth == 0)
									out.print(num); //답변글이 아님을 의미함
								%>
							</td>
							<td class="subjectTd">
								<%
								if (depth > 0) { //답변글을 의미함
									for (int blank = 0; blank < depth; blank++) {
										out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
									} //End of inner for
								} //End of inner if
								out.print(subject);
								%>
							</td>
							<td><%=uName%></td>
							<td><%=regTM%></td>
							<td><%=readCnt%></td>
						</tr>
						<%
						} //End of inner for 데이터가 있을 경우 출력 끝
						} //End of inner if
						%>

						<tr id="listBtnArea">
							<td colspan="2">
								<%
								if (uId_Session == null) {
								%>
								<button id="loginAlertBtn" class="listBtnStyle" type="button">글쓰기</button>
								<%
								} else {
								%>
								<button id="writeBtn" class="listBtnStyle" type="button">글쓰기</button>
								<%
								}
								%>
							</td>
							<td colspan="3">
								<form name="searchFrm" class="dFelx" id="searchFrm">
									<div>
										<select name="keyField" id="keyField">
										<option value="subject"<%if (keyField.equals("subject"))out.print("selected");%>>제목</option>
										<option value="uName"<%if (keyField.equals("uName"))out.print("selected");%>>이름</option>
										<option value="content"<%if (keyField.equals("content"))out.print("selected");%>>내용</option>
										</select>
									</div>
									<div>
										<input type="text" name="keyWord" id="keyWord" id="keyWord"	size="20" maxlength="30" value="<%=keyWord%>">
									</div>
									<div>
										<button type="button" id="searchBtn" class="listBtnStyle">검색</button>
									</div>
									
									
								</form>
								
								<!-- 검색결과 유지용 매개변수 데이터시작 -->
								<input type="text" id="pKeyField" value="<%=keyField%>">
								<input type="text" id="pKeyWord" value="<%=keyWord%>">
								<!-- 검색결과 유지용 매개변수 데이터끝 -->
							</td>
						</tr>
						<!--  tr#listBtnArea -->
						
						<tr id="listPaignArea">
							<!-- 페이징 시작 -->
							<td id="paginTd"colspan="5">
							<%int pageStart =(nowBlock -1) * pagePerBlock +1;
								//26개 자료기준
								//현재 기주 numPerpage : 5;		//페이지당 출력 데이터 수
								//			pagePreBlock : 5;	//블럭당 페이지 수
								//			nowBlock : 현재블럭,
								//			totalBlock : 전체블럭
								//	------------------------------------------------------
								//			totalRecord:26 		totalPage : 6
								// 적용결과	nowBlock : 1 => pageStart :1 pageEnd:5
								// 			nowBlock : 2 => pageStart :6 pageEnd:6(=totalPage)
								
								 int pageEnd = (nowBlock < totalBlock) ? pageStart + pagePerBlock - 1 : totalPage;
								
								//블럭당 5페이지 출력 => 	pageStart  pageEnd
								//						1블럭  1            5 
								//						1블럭  6            10 
								
								
								//블럭마다 시작되는 처 페이지와 마지막 페이지 관련 작업
								if(totalPage != 0){	// 전체 페이지가 0이 아니라면  = 게시글이 1개라도 있다면
								
							%>
							
							<%if(nowBlock>1){		//페이지 블럭이 2이상이면 => 2개 이상의 블럭이 있어야 가능 %>
							 	<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock-1%>','<%=pagePerBlock%>')">&lt;</span>
							 <%}else{ %>
							 	<span class="moveBlockArea"></span>
							 <%} //End of inner if %>
							 
							 <!-- 페이지 나누기용 페이지 번호 출력 시작  -->
							 	<%	
							 	for( ; pageStart <= pageEnd; pageStart++){
							 		if(pageStart == nowPage){//현재 사용자가 보고있는 페이지 %>
									<span class="nowPageNum"><%=pageStart %></span>
							 	<%} else { //현재 사용자가 보고있지 않은 페이지 %>
							 		<span class="PageNum" onclick="movePage('<%=pageStart %>')"><%=pageStart %></span>
							 	<%}// End If %>
							 	<%} //End of For %><!--  페이지 나누기용 페이지 번호 출력 끝 -->
							 	
							 	<%if(totalBlock>nowBlock) {//다음 블럭이 남아 있다면%>
							 		<span class="moveBlockArea" onclick="mveBlock('<%=nowBlock +1%>','<%=pagePerBlock%>')">&gt;</span>
							 	<% } else {	%>
							 		<span class="moveBlockArea"></span>
							 		<%} //End of inner if 
								}else {
									out.print("<b>[Paging Area]</b>");
								}	//End od outer if
							 	%>
							 		
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!-- 실제작업  영역 끝 -->
		</main>
		<!-- main#main --> 
		
		<!-- 푸터 템플릿 시작 -->
		<%@ include file="/ind/footerTmp.jsp" %>
		<!-- 푸터 템플릿 끝 -->
	</div>
	<!-- div#wrap -->

</body>
</html>
