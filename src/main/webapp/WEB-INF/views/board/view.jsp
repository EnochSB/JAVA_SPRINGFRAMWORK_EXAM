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
	
	startupPage();
	
}

// 좋아요 싫어요 처리 함수 시작
const sendDataToServer = async (myLike, myDislike, checkCount) => {
	
	const myLikeCheck = myLike;
	const myDislikeCheck = myDislike;
	const checkCnt = checkCount;
	
	const queryString = {	// JSON 형태로 구성되어있지만 자바 객체
		"seqno": ${view.seqno},
		"userid": "${userid}",
		"mylikecheck": myLikeCheck,
		"mydislikecheck": myDislikeCheck,
		"checkCnt": checkCnt
	};
	
	await fetch('/board/likeCheck', {
		method: "POST",
		headers: {"content-type": "application/json"},
		body: JSON.stringify(queryString)	// 자바 객체를 JSON으로 변환해서 서버로 요청 전송
	}).then((response) => response.json()
	).then((data) => {
		like.innerHTML = data.likeCnt;
		dislike.innerHTML = data.dislikeCnt;
	}).catch((error) => {
		console.log("error=" + error);
	});
	
}

const likeView = () => {
	
	if(myLikeCheck == "Y" && myDislikeCheck == "N") { // 좋아요 취소
		alert("좋아요를 취소합니다.");
		const checkCnt = 1;	// likeCnt --;
		myLikeCheck = "N";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.likeClick').style.backgroundColor = '#d2d2d2';
	} else if(myLikeCheck == "N" && myDislikeCheck == "Y") {
		alert("싫어요가 좋아요로 바뀝니다.");
		const checkCnt = 2;	// likeCnt ++; dislikeCnt --;
		myLikeCheck = "Y";
		myDislikeCheck = "N";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.likeClick').style.backgroundColor = '#00B9FF';
		document.querySelector('.dislikeClick').style.backgroundColor = '#d2d2d2';
	} else if(myLikeCheck == "N" && myDislikeCheck == "N") {
		alert("좋아요를 선택했습니다.");
		const checkCnt = 3;	// likeCnt ++;
		myLikeCheck = "Y";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.likeClick').style.backgroundColor = '#00B9FF';
	}
	
	
	if(myLikeCheck == 'Y') {
		myChoice.innerHTML = username + '님의 선택은 좋아요 입니다.';
	} else if(myDislikeCheck == 'Y') {
		myChoice.innerHTML = username + '님의 선택은 싫어요 입니다.';
	} else if(myLikeCheck == 'N' && myDislikeCheck == 'N') {
		myChoice.innerHTML = username + '님은 아직 선택하지 않으셨습니다.';
	}
	
}

const dislikeView = () => {
	
	if(myDislikeCheck == "Y" && myLikeCheck == "N") { // 싫어요 취소
		alert("싫어요를 취소합니다.");
		const checkCnt = 4;	// dislikeCnt --;
		myDislikeCheck = "N";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.dislikeClick').style.backgroundColor = '#d2d2d2';
	} else if(myDislikeCheck == "N" && myLikeCheck == "Y") {
		alert("좋아요가 싫어요로 바뀝니다.");
		const checkCnt = 5;	// likeCnt --; dislikeCnt ++;
		myLikeCheck = "N";
		myDislikeCheck = "Y";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.dislikeClick').style.backgroundColor = '#00B9FF';
		document.querySelector('.likeClick').style.backgroundColor = '#d2d2d2';
	} else if(myLikeCheck == "N" && myDislikeCheck == "N") {
		alert("싫어요를 선택했습니다.");
		const checkCnt = 6;	// dislikeCnt ++;
		myDislikeCheck = "Y";
		sendDataToServer(myLikeCheck, myDislikeCheck, checkCnt);
		document.querySelector('.dislikeClick').style.backgroundColor = '#00B9FF';
	}
	
	
	if(myLikeCheck == 'Y') {
		myChoice.innerHTML = username + '님의 선택은 좋아요 입니다.';
	} else if(myDislikeCheck == 'Y') {
		myChoice.innerHTML = username + '님의 선택은 싫어요 입니다.';
	} else if(myLikeCheck == 'N' && myDislikeCheck == 'N') {
		myChoice.innerHTML = username + '님은 아직 선택하지 않으셨습니다.';
	}
	
}
// 좋아요 싫어요 처리 함수 끝

// 댓글 처리 시작
// 댓글 목록 보기
const replyList = (data) => {
	
	var session_userid = '${userid}';
	const jsonInfo = data;
	
	let replyList = document.querySelector('#replyList');
	replyList.innerHTML = '';
	
	var result = "";
	for(const i in jsonInfo){
		
		let elm = document.createElement('div');
		elm.setAttribute('id', 's' + jsonInfo[i].replyseqno);	//<div id="s0"></div>
		elm.setAttribute('style', 'font-size: 0.8em');			//<div id="s0" style='font-size:08em'></div>
		
		let result = "";
		
		result += "작성자: " + jsonInfo[i].replywriter;
		if(jsonInfo[i].userid == session_userid){
			result += "[<a href='javascript:replyModify(" + jsonInfo[i].replyseqno + ")' style='cursor:pointer'>수정</a> |";
			result += "<a href='javascript:replyDelete(" + jsonInfo[i].replyseqno + ")' style='cursor:pointer'>삭제</a>]";
		}
		result += "&nbsp;&nbsp;" + jsonInfo[i].replyregdate;
		result += "<div style='width:90%; height:auto; boarder-top:1px solid gray; overfolw:auto'>";
		result += "<pre id='c" + jsonInfo[i].replyseqno + "'>" + jsonInfo[i].replycontent + "</pre><div>";
		result += "<br>";
		
		elm.innerHTML = result;
		replyList.appendChild(elm);
	}
}

// 처음 페이지 시작할 때 댓글 목록 가져 오기
const startupPage = async () => {
	const data = {
		seqno: "${view.seqno}"
	};
	
	await fetch('/board/reply?kind=L', {
		method: 'POST',
		headers: {'content-type':"application/json"},
		body: JSON.stringify(data)
	}).then((response) => response.json())
	  .then((data) => replyList(data))
	  .catch((error) => {
		  console.log("error: " + error);
		  alert("시스템 장애로 댓글 가져오기가 실패했습니다.");
	});
}

// 댓글 등록
const replyRegistry = async () => {
	
	const replycontent = document.querySelector("#replycontent");
	const userid = document.querySelector("#userid");
	if(replycontent.value == ''){
		alert("댓글을 입력하세요.");
		replycontent.focus();
		return false;
	}
	
	const data = {
		replywriter: replywriter.value,
		replycontent: replycontent.value,
		userid: userid.value,
		seqno: seqno.value
	};
	
	await fetch('/board/reply?kind=I', {
		method: 'POST',
		headers: {"content-type": "application/json"},
		body: JSON.stringify(data)
	}).then((response) => response.json()
	).then((data) => {
		replyList(data);
	}).catch((error) => {
		console.log("error=" + error);
		alert("시스템 장애로 댓글 등록이 실패했습니다.");
	});
	
	replycontent.value = "";
}

// 댓글 삭제
const replyDelete = async (replyseqno) => {
	
	if(confirm('정말로 삭제 하시겠습니까?')){
		
		const data = {replyseqno: replyseqno, seqno: ${view.seqno}};
		await fetch('/board/reply?kind=D', {
			method: 'POST',
			headers: {"content-type": "application/json"},
			body: JSON.stringify(data)
		}).then((response) => response.json()
		).then((data) => {
			replyList(data);
		}).catch((error) => {
			console.log("error=" + error);
			alert("시스템 장애로 댓글 삭제를 실패했습니다.");
		});
	}
}

// 댓글 수정
const replyModify = (replyseqno) => {
	
	const modifyReplyContent = document.querySelector('#c' + replyseqno);
	
	var strReplyList = "작성자: ${username}&nbsp;"
		+ "<input type='button' id='btn_replyModify' value='수정'>"
		+ "<input type='button' id='btn_replyModifyCancel' value='취소'>"
		+ "<input type='hidden' name='replyseqno' value='" + replyseqno + "'>"
		+ "<input type='hidden' name='seqno' value='${view.seqno}'>"
		+ "<input type='hidden' id='writer' name='replywriter' value='${username}'>"
		+ "<input type='hidden' id='userid' name='userid' value='${userid}'><br>"
		+ "<textarea id='modify_replycontent' name='replycontent' cols='80' rows='5' maxlength='150' placeholder='글자수: 150자 이내'>"
		+ modifyReplyContent.innerHTML + "</textarea><br>";
	
	let elm = document.createElement('div');
	elm.innerHTML = strReplyList;
	
	let parentDiv = document.querySelector('#s' + replyseqno).parentNode;
	parentDiv.insertBefore(elm, document.querySelector('#s' + replyseqno));
	document.querySelector('#s' + replyseqno).style.display = 'none';
	
	const btnReplyModify = document.querySelector('#btn_replyModify');
	const btnReplyModifyCancel = document.querySelector('#btn_replyModifyCancel');
	
	btnReplyModify.addEventListener('click', async () => {
		
		const data = {
			replyseqno: replyseqno,
			replycontent: modify_replycontent.value
		}
		await fetch('/board/reply?kind=U', {
			method: 'POST',
			headers: {'content-type':'application/json'},
			body: JSON.stringify(data)
		}).catch((error) => {
			console.log("error: " + error);
			alert("시스템 장애로 댓글 수정을 실패했습니다.");
		});
		
		document.querySelector('#replyList').innerHTML = '';
		startupPage();
	});
	
	btnReplyModifyCancel.addEventListener('click', () => {
		if(confirm('정말로 취소하시겠습니까?')){
			document.querySelector('#replyList').innerHTML = '';
			startupPage();
		}
	});
}

// 댓글 작성 취소
const replyCancel = () => {
	if(confirm("정말로 취소 하시겠습니까?")) {
		replycontent.value = '';
		replycontent.focus();
	}
}

// 댓글 처리 끝

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
			<input type="hidden" id="userid" name="userid" value="${userid}">
		</form>
		<input type="button" id="btn_reply" value="댓글등록" onclick="replyRegistry()">
		<input type="button" id="btn_cancel" value="취소" onclick="replyCancel()">
		<hr>
		<div id="replyList" class="replyList"></div>
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