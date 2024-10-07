/**
 * 
 */
 const getCookie = (name) => {

	const cookies = document.cookie.split(`; `).map((el) => el.split('='));
	// cookies[][] = { ['authekey', 임의의키], ['expires', 시간] }
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