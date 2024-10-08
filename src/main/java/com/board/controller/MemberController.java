package com.board.controller;

import java.io.File;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.board.dto.AddressDTO;
import com.board.dto.MemberDTO;
import com.board.service.MemberService;
import com.board.util.Page;
import com.board.util.PasswordMaker;

@Controller
public class MemberController {
	
	// 컴포넌트 방식으로 의존성 주입
	// 암호화 관련 스프링빈 호출
	// @Autowired
	// private BCryptPasswordEncoder pwdEncoder;
	
	
	// 스프링 빈을 생성자 방식으로 의존성 주입
	private BCryptPasswordEncoder pwdEncoder;
	public MemberController(BCryptPasswordEncoder pwdEncoder) {
		this.pwdEncoder = pwdEncoder;
	}
	
	
	// MemberService 스프링빈 의존성 주입
	@Autowired
	MemberService service;
	
	
	// 로그인 화면 보기
	@GetMapping("/member/login")
	public void getLogin() {}
	
	
	// 로그인 처리
	// ResponseBody: 페이지와 비동기 데이터 처리, 리턴 값이 respose message의 body가 됨.
	@ResponseBody
	@PostMapping("/member/login")
	public String postLogin(
			@RequestParam("autoLogin") String autoLogin,
			MemberDTO loginData,
			HttpSession session
			) throws Exception {
		
		String authkey = "";
		
		// autoLogin의 값이 NEW인 경우: 로그인 버튼으로 로그인하는 경우
		// authkey 없음
		// authkey 생성
		if(autoLogin.equals("NEW")) {
			
			// 난수로 생성
			authkey = UUID.randomUUID().toString().replace("-", "");
			// authkey(인증토큰)를 저장: DTO에 저장 후 tbl_member 테이블에 저장
			loginData.setAuthkey(authkey);
			service.authkeyUpdate(loginData);
			
		}
		
		// autoLogin이 PASS인 경우: 클라이언트 웹브라우저에 authkey 쿠키가 존재해 자동로그인하는 경우
		// 세션만 생성하고 게시판 목록 페이지로 이동
		if(autoLogin.equals("PASS")) {
			
			// authkey를 가지고 회원 정보를 검색 (select * from tbl_member where authkey='authkey값')
			// 그 회원 정보를 MemberDTO에 저장하고 이 값을 이용해 세션 생성
			MemberDTO memberInfo = service.memberInfoByAuthkey(loginData.getAuthkey());
			
			// authkey가 존재: 정당한 사용자
			if(memberInfo != null){
				// 세션 생성: 서버에서 정보를 저장
				session.setMaxInactiveInterval(3600*24*7); // 7일간 세션유지
				session.setAttribute("userid", memberInfo.getUserid());
				session.setAttribute("username", memberInfo.getUsername());
				session.setAttribute("role", memberInfo.getRole());
				
				// 로그인 날짜 및 회원 로그 정보 등록
				service.lastdateUpdate(memberInfo.getUserid(), "login");
				service.memberLogRegistry(memberInfo.getUserid(), "login");
				
				// 패스워드 변경 기한 도래 여부 확인
				Calendar cal = Calendar.getInstance(); // Calendar 객체를 사용하기 위해 Calender 인스턴스 생성
				cal.setTime(memberInfo.getLastpwdate()); // 마지막 패스워드 변경 시간을 Calendar 객체에 설정
				int addeddate = 30 * (memberInfo.getPwcheck() + 1);
				cal.add(Calendar.DAY_OF_MONTH, addeddate);	// addeddate를 현재 일수에 더함
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyYyMMdd");	// 날짜 포맷 설정
				String reDate = simpleDateFormat.format(cal.getTime());	// 계산한 날짜를 포맷에 맞춰 변환 후 String으로 반환
				String today = simpleDateFormat.format(new Date()); // 오늘 날짜를 포맷에 맞춰 변환 후 String으로 반환
				
				// compareTo: 두 문자가 같으면 0, 첫 번째 문자가 두 번째 문자보다 작으면 음수, 크면 양수 반환
				if(reDate.compareTo(today) < 0) {	// 패스워드 변경일이 넘었다...
					return "{\"message\":\"expired\"}";
				}
				
				return "{\"message\":\"good\"}";
			} else {
				return "{\"message\":\"bad\"}";
			}
		}
		
		// 아이디 존재 여부 확인
		if(service.idCheck(loginData.getUserid()) == 0) {	// 회원이 존재하지 않음
			return "{\"message\":\"ID_NOT_FOUND\"}";
		}
		// 아이디 존재하면 읽어 온 userid로 회원 정보 가져오기
		// SQL: select * from tbl_member where userid = 'xxx'
		MemberDTO memberInfo = service.memberInfo(loginData.getUserid());
		
		// 패스워드 확인
		if(!pwdEncoder.matches(loginData.getPassword(), memberInfo.getPassword())){
			return "{\"message\":\"PASSWORD_NOT_FOUND\"}";
		} else { // 패스워드가 아이디로 찾은 멤버 패스워드와 일치
			session.setMaxInactiveInterval(3600*24*7); // 7일간 세션유지
			session.setAttribute("userid", memberInfo.getUserid());
			session.setAttribute("username", memberInfo.getUsername());
			session.setAttribute("role", memberInfo.getRole());
			
			// 로그인 날짜 및 회원 로그 정보 등록
			service.lastdateUpdate(memberInfo.getUserid(), "login");
			service.memberLogRegistry(memberInfo.getUserid(), "login");
			

			// 패스워드 변경 기한 도래 여부 확인
			Calendar cal = Calendar.getInstance(); // Calendar 객체를 사용하기 위해 Calender 인스턴스 생성
			cal.setTime(memberInfo.getLastpwdate()); // 마지막 패스워드 변경 시간을 Calendar 객체에 설정
			int addeddate = 30 * (memberInfo.getPwcheck() + 1);
			cal.add(Calendar.DAY_OF_MONTH, addeddate);	// addeddate를 현재 일수에 더함
			SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyyMMdd");	// 날짜 포맷 설정
			String reDate = simpleDateFormat.format(cal.getTime());	// 계산한 날짜를 포맷에 맞춰 변환 후 String으로 반환
			String today = simpleDateFormat.format(new Date()); // 오늘 날짜를 포맷에 맞춰 변환 후 String으로 반환
			
			// compareTo: 두 문자가 같으면 0, 첫 번째 문자가 두 번째 문자보다 작으면 음수, 크면 양수 반환
			if(reDate.compareTo(today) < 0) {	// 패스워드 변경일이 넘었다...
				return "{\"message\":\"expired\", \"authkey\":\"" + memberInfo.getAuthkey() + "\"}";
			}
			System.out.println("로그인 확인 JSON = " + "{\"message\":\"good\", \"authkey\":\"" + memberInfo.getAuthkey() + "\"}");
			return "{\"message\":\"good\", \"authkey\":\"" + memberInfo.getAuthkey() + "\"}";
		}
	}
	
	
	// 로그아웃
	@GetMapping("/member/logout")
	public String getLogout(HttpSession session) throws Exception{
		
		String userid = (String) session.getAttribute("userid");
		
		// 로그아웃 날짜 및 회원 로그 정보 등록
		service.lastdateUpdate(userid, "logout");
		service.memberLogRegistry(userid, "logout");
		//세션 삭제
		session.invalidate();
		return "redirect:/";
	}
	
	// 30일 이후 패스워드 변경 화면 보기
	@GetMapping("/member/checkPasswordNotice")
	public void getCheckPasswordNotice(
			Model model,
			HttpSession session
			) throws Exception {
		String userid = (String) session.getAttribute("userid");
		MemberDTO memberInfo = service.memberInfo(userid);
		int addedDate = 30 * (memberInfo.getPwcheck() + 1);
		model.addAttribute("addedDate", addedDate);
	}
	
	
	// 패스워드 변경 30일 이후로 연기
	@GetMapping("/member/nextTime")
	public String postNextTime(
			HttpSession session
			) {
		String userid = (String) session.getAttribute("userid");
		service.nextTime(userid);
		return "redirect:/board/list";
	}
	
	// 아이디 찾기 화면 보기
	@GetMapping("/member/searchID")
	public void getSearchID() {}
	
	// 아이디 찾기
	@ResponseBody
	@PostMapping("/member/searchID")
	public String postSearchID(
			@RequestParam("username") String username,
			@RequestParam("telno") String telno
			) throws Exception{
		
		if(service.usernameCheck(username) == 0) {
			return "{\"message\":\"USERNAME_NOT_FOUND\"}";
		}
		
		if(service.telnoCheck(telno) == 0) {
			return "{\"message\":\"TELNO_NOT_FOUND\"}";
		}
		
		MemberDTO member = new MemberDTO();
		member.setUsername(username);
		member.setTelno(telno);
		String userid = service.searchID(member);
		if(userid == null) {
			return "{\"message\":\"bad\"}";
		}
		System.out.println(userid);
		
		return "{\"message\":\"good\", \"userid\":\"" + userid + "\"}";
	}
	
	// 비밀번호 찾기 화면 보기
	@GetMapping("/member/searchPassword")
	public void getSearchPassword() {}
	
	// 비밀번호 찾기(임시 패스워드 발급)
	@ResponseBody
	@PostMapping("/member/searchPassword")
	public String postSearchPassword(
			@RequestParam("userid") String userid,
			@RequestParam("telno") String telno
			) {
		
		if(service.idCheck(userid) == 0) {
			return "{\"message\":\"ID_NOT_FOUND\"}";
		}
		
		if(service.telnoCheck(telno) == 0) {
			return "{\"message\":\"TELNO_NOT_FOUND\"}";
		}
		
		PasswordMaker pwmaker = new PasswordMaker();
		String tempPW = pwmaker.tempPasswordMaker();
		
		MemberDTO member = new MemberDTO();
		member.setUserid(userid);
		member.setPassword(pwdEncoder.encode(tempPW));
		service.modifyMemberPassword(member);
		
		return "{\"message\":\"good\", \"tempPW\":\"" + tempPW + "\"}";
	}
	
	// 회원 가입 화면 보기
	@GetMapping("/member/signup")
	public void getSignup() {}
	
	
	// 회원 가입
	@ResponseBody
	@PostMapping("/member/signup")
	public String postSignUp(
			MemberDTO member,
			@RequestParam("kind") String kind,
			@RequestParam("fileUpload") MultipartFile mpr
			) throws Exception { // fileUpload: 태그의 name으로 인자를 받는다
		// mpr: 파일 정보가 직렬화된 데이터
		
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정
		String os = System.getProperty("os.name").toLowerCase();
		String path;
		if(os.contains("win")) {
			path ="c:\\Repository\\profile\\";
		} else {
			path = "/home/hasb/Repository/profile";
		}
		
		// 디렉토리가 존재하는지 체크 없다면 생성
		File p = new File(path);
		if(!p.exists()) {
			p.mkdir();
		}
		// 운영체제에 따라 이미지가 저장될 디렉토리 구조 설정 종료
		
		// 프로필 이미지 저장 경로
		//String path ="c:\\Repository\\profile\\";
		String org_filename = ""; // 첨부파일 원래 파일명
		long filesize = 0L;
		
		// 첨부파일이 들어 왔을 경우만 실행
		if(!mpr.isEmpty()) {
			File targetFile = null;
			
			// filename.확장자 -> .확장자만 추출
			org_filename = mpr.getOriginalFilename();
			String org_fileExtension = org_filename.substring(org_filename.lastIndexOf("."));
			// UUID.randomUUID() -> 대소영문자 + 특수문자인 무작위 문자열을 생성 -> 무작위 파일명.확장자가 생성
			String stored_filename = UUID.randomUUID().toString().replaceAll("-", "") + org_fileExtension;
			filesize = mpr.getSize(); // 파일사이즈 바이트 단위로 생성
			targetFile = new File(path + stored_filename); // c:\Repository\profile\무작위파일명.확장자로 저장할거라고 선언
			mpr.transferTo(targetFile); // Form 데이터의 일부로 들어온 첨부 파일 데이터를 파일명이 있는 파일 형태로 지정한 경로에 저장
			member.setOrg_filename(org_filename);
			member.setStored_filename(stored_filename);
			member.setFilesize(filesize);
			
		}
		// 회원 등록 시
		if(kind.equals("I")) {		
			// password 암호화
			member.setPassword(pwdEncoder.encode(member.getPassword()));
			// 마지막 패스워드 변경일: 가입일
			member.setLastpwdate(new Date());
			
			service.signup(member);
		}
		
		// 회원 정보 수정 시
		if(kind.equals("U")) {
			
			// 프로필 이미지 변경 시에 기존 프로필 이미지 삭제
			if(!mpr.isEmpty()) {
				MemberDTO m = service.memberInfo(member.getUserid());
				File file = new File(path + m.getStored_filename());	// 수정 되기 전의 stored_filename
				file.delete();
			}
			
			// 수정작업
			service.modifyMemberInfo(member);
		}
		// 예제: {"username":"김철수","status":"good"}
		System.out.println("회원등록 JSON = " + "{\"username\":\"" + member.getUsername() + "\", \"status\":\"good\"}");
		return "{\"username\":\"" + URLEncoder.encode(member.getUsername(), "UTF-8") + "\", \"status\":\"good\"}";
	}
	
	// 회원 정보 보기
	@GetMapping("/member/viewMemberInfo")
	public void getViewMemberInfo(Model model, HttpSession session) throws Exception {
		String userid = (String) session.getAttribute("userid");
		model.addAttribute("member", service.memberInfo(userid));
	}
	
	// 회원 정보 수정 화면 보기
	@GetMapping("/member/modifyMemberInfo")
	public void getModifyMemberInfo(Model model, HttpSession session) throws Exception {
		String userid = (String) session.getAttribute("userid");
		model.addAttribute("member", service.memberInfo(userid));
	}
	
	// 회원 패스워드 변경 화면 보기
	@GetMapping("/member/modifyMemberPassword")
	public void getModifyMemberPassword() throws Exception {
		
	}
	
	// 패스워드 변경
	@ResponseBody
	@PostMapping("/member/modifyMemberPassword")
	public String postModifyMemberPassword(
			@RequestParam("old_password") String old_password,
			@RequestParam("new_password") String new_password,
			HttpSession session
			) throws Exception {
		
		String userid = (String) session.getAttribute("userid");
		
		// 이전 패스워드가 제대로 된 패스워드인지 확인
		if(!pwdEncoder.matches(old_password, service.memberInfo(userid).getPassword())) {
			return "{\"message\":\"PASSWORD_NOT_FOUND\"}";
		}
		
		// 신규 패스워드로 수정
		MemberDTO member = new MemberDTO();
		member.setUserid(userid);
		member.setPassword(pwdEncoder.encode(new_password));
		service.modifyMemberPassword(member);
		
		return "{\"message\":\"good\"}";
	}
	
	// 아이디 중복 체크
	@ResponseBody
	@PostMapping("/member/idCheck")
	public int getIdCheck(@RequestBody String userid) throws Exception {
		
		return service.idCheck(userid);
	}
	
	// 주소 검색
	@GetMapping("/member/searchAddress")
	public void getAddrSearch(@RequestParam("addrSearch") String addrSearch,
			@RequestParam("page") int pageNum, Model model) throws Exception {
		
		int postNum = 5; // 한 페이지에 출력할 데이터 갯수
		int startPoint = (pageNum - 1)*postNum; // 테이블에서 읽어 올 행의 위치. 0부터 시작.
		// 1페이지: 0~4, 2페이지: 5~9,... => 0, 5, 10 ...이 startPoint에 들어가야함. 
		int listCount = 10; // 한 번에 보여줄 페이지 리스트의 페이지 갯수.
		
		Page page = new Page();
		
		// 주어진 키워드를 포함하고 있는 행의 전체 갯수
		int totalCount = service.addrTotalCount(addrSearch);
		
		List<AddressDTO> list = new ArrayList<>();
		list = service.addrSearch(startPoint, postNum, addrSearch);
		
		model.addAttribute("list", list);
		model.addAttribute("pageListView", page.getPageAddress(pageNum, postNum, listCount, totalCount, addrSearch));
	}
}
