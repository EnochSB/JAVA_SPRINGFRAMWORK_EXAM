package com.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.board.dto.AddressDTO;

@Repository
public class BoardDAOImpl implements BoardDAO {
	
	@Autowired
	private SqlSession sql;
	private static String namespace = "com.board.mappers.Board";
	
	// 리스트
	@Override
	public List<AddressDTO> list(int startPoint, int postNum, String keyword) {
		Map<String,Object> data = new HashMap<>();
		data.put("startPoint", startPoint);
		data.put("postNum", postNum);
		data.put("keyword", keyword);
		
		return sql.selectList(namespace + ".list", data);
	}
	
	// 검색 갯수
	@Override
	public int getTotalCount(String keyword) {
		return sql.selectOne(namespace + ".getTotalCount", keyword);
	};

}
