package com.board.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.board.dto.FileDTO;

@Repository
public class MasterDAOImpl implements MasterDAO {
	
	// Annotation 이용
	@Autowired
	private SqlSession sql;
	
	// 생성자 이용
	/*
	 * SqlSession sql;
	 * public MasterDAOImpl(SqlSession sql){
	 *     this.sql = sql;
	 * }
	 */
	
	// setter 메서드 이용
	/*
	 * SqlSession sql;
	 * public void setSql(SqlSession sql){
	 *     this.sql = sql;
	 * }
	 * 
	 */
	private static String namespace = "com.board.mappers.Master";
	
	// 삭제된 게시물 리스트 보기
	@Override
	public List<FileDTO> fileDeleteList() {
		return sql.selectList(namespace + ".fileDeleteList");
	};
	
	// tbl_file 내 데이터 삭제
	@Override
	public void deleteFile(int fileseqno) {
		sql.delete(namespace + ".deleteFile", fileseqno);
	};
	
	// 삭제할 파일 갯수
	@Override
	public int fileDeleteCount() {
		return sql.selectOne(namespace + ".fileDeleteCount");
	};

}
