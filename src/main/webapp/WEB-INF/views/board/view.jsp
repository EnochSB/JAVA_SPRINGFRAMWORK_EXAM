<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시물 상세 보기</title>
<link rel="stylesheet" href="/resources/CSS/board.css">
<style>
.likeClick, .dislikeClick {
	padding: 10px 10px;
	text-align: center;
	text-decoration: none;
	border: solid 1px #a0a0a0;
	display: inline-block;
	background-color: #d2d2d2;
	border-radius: 20px;
}
</style>
<script>

var myLikeCheck;
var myDislikeCheck;
var username;

window.onload = () => {
	
	likeCnt = ${view.likecnt};
	dislikeCnt = ${view.dislikecnt};
	myLikeCheck = '${myLikeCheck}';
	myDislikeCheck = '${myDislikeCheck}';
	username = '${username}';
	like.innerHTML = likeCnt;
	dislike.innerHTML = dislikeCnt;
	
	if(myLikeCheck == 'Y') {
		document.querySelector('.likeClick').style.backgroundColor = '#00B9FF';
		myChoice.innerHTML = username + '님의 선택은 좋아요 입니다.';
	} else if(myDislikeCheck == 'Y') {
		document.querySelector('.dislikeClick').style.backgroundColor = '#00B9FF';
		myChoice.innerHTML = username + '님의 선택은 싫어요 입니다.';
	} else if(myLikeCheck == 'N' && myDislikeCheck == 'N') {
		myChoice.innerHTML = username + '님은 아직 선택하지 않으셨습니다.';
	}
	
}
</script>
</head>
<body>
<script>
	let userid = '${userid}';
	if (userid == '') document.location = '/member/login';
</script>

<div>
	<img class="topBanner" src="/resources/images/logo.jpg" title="서울기술교육센터">
</div>

<div class="main">
	<div class="boardView">
		<div class="field">이름: ${view.writer}</div>
		<div class="field">제목: ${view.title}</div>
		<div class="field">날짜: <fmt:formatDate value="${view.regdate}" pattern="yyyy-MM-dd a hh:mm:ss" /></div>
		<div class="content"><pre>${view.content}</pre></div>
		<div class="likeForm" style="width: 30%; height: auto; margin: auto;">
			<span id='like'></span>&nbsp;<a href='javascript:likeView()' id="likeClick" class="likeClick">좋아요</a>
			<a href="javascript:dislikeView()" id="dislikeClick" class="dislikeClick">싫어요</a>&nbsp;<span id="dislike"></span><br>
			<span id="myChoice" style="text-align:center; color:red"></span>
		</div>
		<c:if test="${not empty fileListView}">
			<c:forEach items="${fileListView}" var="fileView">
				<div class="field">파일명 : <a href="/board/fileDownload?fileseqno=${fileView.fileseqno}">${fileView.org_filename}</a> (${fileView.filesize} Byte)</div>
			</c:forEach>
		</c:if>
		<c:if test="${empty fileListView}">
			<div class="field">첨부된 파일이 없습니다.</div>
		</c:if>
	</div>
	<br>
	<div class="bottom_menu">
		<c:if test="${pre_seqno != 0}">
			&nbsp;&nbsp;<a href="/board/view/?seqno=${pre_seqno}&page=${page}&keyword=${keyword}">이전글▼</a>
		</c:if>
		&nbsp;&nbsp;<a href="/board/list/?page=${page}&keyword=${keyword}">목록보기</a>
		<c:if test="${next_seqno != 0}">
		&nbsp;&nbsp;<a href="/board/view/?seqno=${next_seqno}&page=${page}&keyword=${keyword}">다음글▲</a>
		</c:if>
		&nbsp;&nbsp;<a href="/board/write">글 작성</a>
		<c:if test="${userid == view.userid}">
			&nbsp;&nbsp;<a href="/board/modify?seqno=${view.seqno}&page=${page}&keyword=${keyword}">글 수정</a>
			&nbsp;&nbsp;<a href="javascript:deleteBoard()">글 삭제</a>
		</c:if>
	</div>
	<br>
	<div class="replyDiv" style="width:60%; height:300px; margin:auto; text-align:left;">
		<p id="replyNotice">댓글을 작성해 주세요</p>
		<form id="replyForm" name="replyForm" method="POST">
			작성자: <input type="text" id="replywriter" name="replywriter" value=${username} readonly><br>
			<textarea id="replycontent" name="replycontent" rows="5" cols="80" maxlength="150" placeholder="글자 수: 150자 이내"></textarea>
			<br>
			<input type="hidden" id="seqno" name="seqno" value="${view.seqno}">
			<input type="hidden" id="userid" name="userid" value="${view.userid}">
		</form>
		<input type="button" id="btn_reply" value="댓글등록" onclick="replyRegister()">
		<input type="button" id="btn_cancel" value="취소" onclick="replyCancel()">
	</div>
</div>

<script>
const deleteBoard = () => {
	if(confirm("정말로 삭제하시겠습니까?"))
		document.location='/board/deleteBoard/?seqno=${view.seqno}';
}

</script>
</body>
</html>