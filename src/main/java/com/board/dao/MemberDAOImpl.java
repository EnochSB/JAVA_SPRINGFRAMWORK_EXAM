package com.board.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.board.dto.AddressDTO;
import com.board.dto.MemberDTO;

// DAO(Data Access Object)
@Repository
public class MemberDAOImpl implements MemberDAO {
	
	// root-context에서 설정한 마이바티스 스프링빈
	@Autowired
	private SqlSession sql;
	private static String namespace = "com.board.mappers.Member";
	
	// id 중복체크
	@Override
	public int idCheck(String userid) {
		
		return sql.selectOne(namespace + ".idCheck", userid);
		// com.board.mappers.Member.idCheck
	}
	
	// 주소 행 최대 갯수 계산
	@Override
	public int addrTotalCount(String addrSearch) {
		
		return sql.selectOne(namespace + ".addrTotalCount", addrSearch);
	}
	
	// 주소 검색
	@Override
	public List<AddressDTO> addrSearch(int startPoint, int postNum, String addrSearch) {
		Map<String,Object> data = new HashMap<>();
		data.put("startPoint", startPoint);
		data.put("postNum", postNum);
		data.put("addrSearch", addrSearch);
		
		return sql.selectList(namespace + ".addrSearch", data);
	}
	
	// 회원 등록
	@Override
	public void signup(MemberDTO member) {
		sql.insert(namespace + ".signup", member);
		
	}
	
	// 회원 정보 수정
	@Override
	public void modifyMemberInfo(MemberDTO member) {
		sql.update(namespace + ".modifyMemberInfo", member);
	}
	
	// 패스워드 변경
	@Override
	public void modifyMemberPassword(MemberDTO member) {
		sql.update(namespace + ".modifyMemberPassword", member);
	};
	
	// 30일 이후 패스워드 변경 연기
	@Override
	public void nextTime(String userid) {
		sql.update(namespace + ".nextTime", userid);
	};
	
	// 아이디 찾기
	@Override
	public String searchID(MemberDTO member) {
		return sql.selectOne(namespace + ".searchID", member);
	};
	
	// 비밀번호 찾기(임시 비밀번호 발급)
	@Override
	public MemberDTO searchPassword(MemberDTO member) {
		return sql.selectOne(namespace + ".searchPassword", member);
	};
	
	// 이름 중복체크(아이디/비밀번호 찾기에 사용)
	@Override
	public int usernameCheck(String username) {
		return sql.selectOne(namespace + ".usernameCheck", username);
	};
	
	// 전화번호 중복체크(아이디/비밀번호 찾기에 사용)
	@Override
	public int telnoCheck(String telno) {
		return sql.selectOne(namespace + ".telnoCheck", telno);
	};
	
	// 회원 정보
	@Override
	public MemberDTO memberInfo(String userid) {
		
		return sql.selectOne(namespace + ".memberInfo", userid);
	}

	// authkey 등록(update)
	@Override
	public void authkeyUpdate(MemberDTO member) {
		sql.update(namespace + ".authkeyUpdate", member);
		
	}
	
	// authkey로 회원 정보 검색
	@Override
	public MemberDTO memberInfoByAuthkey(String authkey) {
		
		return sql.selectOne(namespace + ".memberInfoByAuthkey", authkey);
	}
	
	// 회원 로그인, 로그아웃, 패스워드변경시간 등록(update)
	@Override
	public void lastdateUpdate(String userid, String status) {
		Map<String, Object> data = new HashMap<>();
		data.put("userid", userid);
		data.put("status", status);
		data.put("lastdate", new Date());
		sql.update(namespace + ".lastdateUpdate", data);
	};
	
	// 회원 로그 정보 등록
	@Override
	public void memberLogRegistry(String userid, String status) {
		Map<String, Object> data = new HashMap<>();
		data.put("userid", userid);
		data.put("status", status);
		sql.insert(namespace + ".memberLogRegistry", data);
	};

}
