package com.board.dto;

public class FileDTO {
	private int fileseqno;
	private int seqno;
	private String org_filename;
	private String stored_filename;
	private Long filesize;
	private String userid;
	private String checkfile;
	
	public int getFileseqno() {
		return fileseqno;
	}
	public void setFileseqno(int fileseqno) {
		this.fileseqno = fileseqno;
	}
	public int getSeqno() {
		return seqno;
	}
	public void setSeqno(int seqno) {
		this.seqno = seqno;
	}
	public String getOrg_filename() {
		return org_filename;
	}
	public void setOrg_filename(String org_filename) {
		this.org_filename = org_filename;
	}
	public String getStored_filename() {
		return stored_filename;
	}
	public void setStored_filename(String stored_filename) {
		this.stored_filename = stored_filename;
	}
	public Long getFilesize() {
		return filesize;
	}
	public void setFilesize(Long filesize) {
		this.filesize = filesize;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getCheckfile() {
		return checkfile;
	}
	public void setCheckfile(String checkfile) {
		this.checkfile = checkfile;
	}
}
