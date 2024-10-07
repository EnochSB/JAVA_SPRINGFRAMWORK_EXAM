<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 목록</title>
<link rel="stylesheet" href="/resources/CSS/board.css">
<script>
// 웹브라우저에서 쿠키 가져오기
const getCookie = (name) => {
	
	const cookies = document.cookie.split(`; `).map((el) => el.split('='));
	let getItem = [];	// es6+에서 사용 가능한 배열 만들기
	
	// name: 찾고자 하는 쿠키 이름
	for(let i=0; i<cookies.length; i++){
		if(cookies[i][0] === name) {
			getItem.push(cookies[i][1]); // 찾은 쿠키를 getItem에 그 값을 추가
			break;
		}
	}
	if(getItem.length > 0) { // 찾고자 하는 쿠키가 있다.
		return decodeURIComponent(getItem[0]); // 쿠키 값을 리턴
	}
}

const search = () => {
	
	const keyword = document.querySelector('#keyword');
	document.location = '/board/list?page=1&keyword=' + keyword.value;
}

const press = () => {
	
	if(event.keyCode == 13){
		search();	
	}
}

const logout = () => {
	if(confirm("로그아웃 하시겠습니까?")){
		let authkey = getCookie('authkey');
		// 쿠키삭제
		if(authkey !== undefined) {
			document.cookie = 'authkey=' + authkey + ';path=/;max-age=0';
		}
		// 세션 삭제
		document.location = '/member/logout';
	}
}

let userid = '${userid}';
if(userid == ''){
	document.location = '/member/login';
}
</script>	
</head>
<body>
    <div class="tableDiv">
        <img class="topBanner" src="/resources/images/logo.jpg" title="서울기술교육센터">
        <h1>게시물 목록보기</h1>
        <input style="width: 40%;height: 30px; border: 2px solid #168;; font-size: 16px;"
        		type="text" name="keyword" id="keyword" placeholder="검색할 제목, 작성자 및 내용을 입력해 주세요." onkeydown="press()">
        <input style="width: 5%;height: 30px; background: #158; color:white; font-weight: bold; cursor: pointer;"
        		type="button" value="검색" onclick="search()">
        <br><br>
        <table class="InfoTable">
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>조회수</th>
                <th>작성일</th>
            </tr>
            <tbody>
			<c:if test="${not empty list}">
				<c:forEach items="${list}" var="list">
	                <tr onmouseover="this.style.background='#46D2D2'" onmouseout="this.style.background='white'">
	                    <td>${list.seqno}</td>
	                    <td>
	                        <a href="/board/view?seqno=${list.seqno}}" onmouseover="this.style.textDecoration='underline'"
	                        onmouseout="this.style.textDecoration='none'">${list.title}</a>
	                    </td>
	                    <td>${list.writer}</td>
	                    <td>${list.hitno}</td>
	                    <td>
	                    	<fmt:formatDate value="${list.regdate}" pattern="yyyy-MM-dd a hh:mm:ss" />
	                    </td>
	                </tr>
                </c:forEach>
			</c:if>
			<c:if test="${empty list}">
				<tr>
					<td colspan="5">검색된 게시물이 없습니다.</td>
				</tr>
			</c:if>
            </tbody>
        </table>
        <div>${pageListView}</div>
        <div class="bottom_menu">
        	<a href="/board/list?page=1">처음으로</a>&nbsp;&nbsp;
            <a href="/board/write">글 쓰기</a>&nbsp;&nbsp;
            <a href="/member/viewMemberInfo">사용자 관리</a>&nbsp;&nbsp;
            <c:if test="${role == 'MASTER'}">
            	<a href="/master/sysmanage">시스템 관리</a>&nbsp;&nbsp;
            </c:if>
            <a href="javascript:logout()">로그아웃</a>&nbsp;&nbsp;
        </div>
    </div>

    
</body>
</html>